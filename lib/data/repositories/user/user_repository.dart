import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cwt_ecommerce_app/features/shop/models/review_model.dart';
import 'package:cwt_ecommerce_app/features/shop/screens/users/user_profile_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../features/personalization/models/user_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../authentication/authentication_repository.dart';

/// Repository class for user-related operations.
class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _firebaseStorage = FirebaseStorage.instance;

  /// Function to save user data to Firestore.
  Future<void> saveUserRecord(UserModel user) async {
    try {
      await _db.collection("Users").doc(user.id).set(user.toJson());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Function to fetch user details based on user ID.
  Future<UserModel> fetchUserDetails() async {
    try {
      final documentSnapshot = await _db
          .collection("Users")
          .doc(AuthenticationRepository.instance.getUserID)
          .get();
      if (documentSnapshot.exists) {
        return UserModel.fromSnapshot(documentSnapshot);
      } else {
        return UserModel.empty();
      }
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<List<Review>> fetchReviewsWithUserDetails(String userId) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection("Reviews").where('uid', isEqualTo: userId).get();
      List<Review> reviews = [];
      for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
      in querySnapshot.docs) {
        final data = documentSnapshot.data();
        String userUID = data['uid'];

        UserModel? user = await _fetchUserDetailsById(userUID);
        Review review = Review.fromSnapshot(documentSnapshot, user);
        reviews.add(review);
      }
      return reviews;
    } catch (e) {
      throw 'Failed to fetch reviews: $e';
    }
  }


  Future<UserModel?> _fetchUserDetailsById(String userID) async {
    try {
      final documentSnapshot = await FirebaseFirestore.instance.collection("Users").doc(userID).get();
      if (documentSnapshot.exists) {
        return UserModel.fromSnapshot(documentSnapshot);
      } else {
        return null; // Return null if the document does not exist
      }
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }


  Future<UserReviews> fetchUserReviews(String userID) async {
    print("fetchUserReviews");
    print(userID);
    try {
      final userSnapshot = await FirebaseFirestore.instance.collection("Users").doc(userID).get();
      print("userSnapshot.exists");
      print(userSnapshot.exists);
      if (userSnapshot.exists) {
        final user = UserModel.fromSnapshot(userSnapshot);
        print("user.firstName");
        print(user.firstName);
        // Fetch reviews for the user from the "Reviews" collection
        final reviews = await fetchReviewsWithUserDetails(userID);

        return UserReviews(user: user, reviews: reviews);
      } else {
        throw 'User not found';
      }
    } on FirebaseException catch (e) {
      print("exception 1");
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      print("exception 2");
      throw const TFormatException();
    } on PlatformException catch (e) {
      print("exception 3");
      throw TPlatformException(e.code).message;
    } catch (e) {
      print("exception 4");
      print(e);
      throw 'Something went wrong while fetching user reviews: $e';
    }
  }

  Future<List<String>> fetchFollowingUserIDs(String currentUserID) async {
    try {
      // Get the document snapshot of the current user
      final currentUserSnapshot = await FirebaseFirestore.instance.collection("Users").doc(currentUserID).get();

      // Check if the user exists
      if (currentUserSnapshot.exists) {
        // Get the data of the current user
        final currentUserData = currentUserSnapshot.data() as Map<String, dynamic>;

        // Extract the list of following user IDs
        final List<dynamic> following = currentUserData['following'];

        // Convert the dynamic list to a list of strings
        final List<String> followingUserIDs = following.cast<String>();

        return followingUserIDs;
      } else {
        // User not found
        throw 'Current user not found';
      }
    } catch (e) {
      // Handle any errors
      throw 'Error fetching following user IDs: $e';
    }
  }

  Future<List<String>> toggleFollowUser(String currentUserID, String userID , List<String> followingUserIDs) async {
    try {
      // Create a local copy of followingUserIDs
      List<String> updatedFollowingUserIDs = List.from(followingUserIDs);

      if (updatedFollowingUserIDs.contains(userID)) {
        // User is already followed, so unfollow
        await unfollowUser(currentUserID, userID);
        // Remove userID from the updatedFollowingUserIDs list
        updatedFollowingUserIDs.remove(userID);
      } else {
        // User is not followed, so follow
        await followUser(currentUserID, userID);
        // Add userID to the updatedFollowingUserIDs list
        updatedFollowingUserIDs.add(userID);
      }
      // Return the updated list of following user IDs
      return updatedFollowingUserIDs;
    } catch (e) {
      throw 'Error toggling follow user: $e';
    }
  }

  Future<void> followUser(String currentUserID, String userID) async {
    try {
      // Add userID to the following list of currentUserID
      await FirebaseFirestore.instance.collection("Users").doc(currentUserID).update({
        'following': FieldValue.arrayUnion([userID]),
      });
    } catch (e) {
      throw 'Error following user: $e';
    }
  }

  Future<void> unfollowUser(String currentUserID, String userID) async {
    try {
      // Remove userID from the following list of currentUserID
      await FirebaseFirestore.instance.collection("Users").doc(currentUserID).update({
        'following': FieldValue.arrayRemove([userID]),
      });
    } catch (e) {
      throw 'Error unfollowing user: $e';
    }
  }


  /// Function to update user data in Firestore.
  Future<void> updateUserDetails(UserModel updatedUser) async {
    try {
      await _db
          .collection("Users")
          .doc(updatedUser.id)
          .update(updatedUser.toJson());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Update any field in specific Users Collection
  Future<void> updateSingleField(Map<String, dynamic> json) async {
    try {
      await _db
          .collection("Users")
          .doc(AuthenticationRepository.instance.getUserID)
          .update(json);
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<void> addReview(Review reviewData) async {
    try {
      // Add the review data to the "Reviews" collection
      await FirebaseFirestore.instance.collection("Reviews").add(reviewData.toJson());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Upload any Image
  Future<String> uploadImage(String path, XFile image) async {
    try {
      final ref = _firebaseStorage.ref(path).child(image.name);
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Function to remove user data from Firestore.
  Future<void> removeUserRecord(String userId) async {
    try {
      await _db.collection("Users").doc(userId).delete();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}


class UserReviews {
  final UserModel user;
  final List<Review> reviews;

  UserReviews({required this.user, required this.reviews});

  factory UserReviews.empty() {
    return UserReviews(user: UserModel.empty(), reviews: []);
  }
}

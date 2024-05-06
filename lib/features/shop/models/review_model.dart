
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cwt_ecommerce_app/features/personalization/models/user_model.dart';

class Review {
  final String uid;
  final String stars;
  final String comment;
  final UserModel? userModel;

  Review({
    required this.uid,
    required this.stars,
    required this.comment,
    this.userModel,
  });

  factory Review.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document, [UserModel? userModel]) {
    return Review(
      uid: document['uid'],
      stars: document['stars'],
      comment: document['comment'],
      userModel: userModel,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'stars': stars,
      'comment': comment,
    };
  }
}

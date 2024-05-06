import 'package:cwt_ecommerce_app/data/repositories/product/product_repository.dart';
import 'package:cwt_ecommerce_app/data/repositories/user/user_repository.dart';
import 'package:cwt_ecommerce_app/features/personalization/models/user_model.dart';
import 'package:cwt_ecommerce_app/features/shop/models/product_model.dart';
import 'package:cwt_ecommerce_app/features/shop/models/review_model.dart';
import 'package:cwt_ecommerce_app/utils/constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserProfileController extends GetxController {
  late UserModel user;
  final userRepository = Get.put(UserRepository());
  final productRepository = Get.put(ProductRepository());
  RxList<ProductModel> products = <ProductModel>[].obs;
  RxList<Review> reviews = <Review>[].obs;
  RxList<String> followingUserIDs = <String>[].obs;

  final isLoading = false.obs;

  void init(UserModel user) {
    this.user = user;
  }

  @override
  void onReady() {
    super.onReady();
    fetchFeaturedProducts();
    fetchReviewsWithUserDetails();
    fetchFollowingUserIDs();
  }

  void fetchFeaturedProducts() async {
    try {
      isLoading.value = true;

      final resultProducts =
          await productRepository.getProductsForUser(user.id);
      products.assignAll(resultProducts);
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  void fetchReviewsWithUserDetails() async {
    try {
      final resultProducts =
          await userRepository.fetchReviewsWithUserDetails(user.id);
      reviews.assignAll(resultProducts);
    } catch (e) {
    } finally {}
  }

  void fetchFollowingUserIDs() async {
    try {
      final resultProducts =
          await userRepository.fetchFollowingUserIDs(user.id);
      followingUserIDs.assignAll(resultProducts);
    } catch (e) {
    } finally {}
  }

  void addReview(BuildContext context) {
    // Show bottom sheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        int rating = 0;
        TextEditingController commentController = TextEditingController();

        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                // Wrap the content with SingleChildScrollView
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Add Review',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Rating:'),
                        Row(
                          children: List.generate(
                            5,
                            (index) => IconButton(
                              onPressed: () {
                                setState(() {
                                  rating = index + 1;
                                });
                              },
                              icon: Icon(
                                index < rating ? Icons.star : Icons.star_border,
                                color: Colors.yellow,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: commentController,
                      decoration: InputDecoration(
                        hintText: 'Enter your comment...',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          String comment = commentController.text;
                          if (rating > 0 && comment.isNotEmpty) {
                            Get.back();
                          }
                        },
                        child: Text('Submit'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColors.primary, // Background color
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> handleFollow() async {
    try {
      final resultProducts = await userRepository.toggleFollowUser(
          FirebaseAuth.instance.currentUser?.uid ?? "",
          user.id,
          followingUserIDs.value);
      print("resultProducts");
      print(resultProducts);
      followingUserIDs.clear();
      followingUserIDs.addAll(resultProducts);
    } catch (e) {
      // Handle error
    } finally {
      // Any cleanup or additional actions
    }
  }

}

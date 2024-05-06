import 'package:cwt_ecommerce_app/data/repositories/product/product_repository.dart';
import 'package:cwt_ecommerce_app/data/repositories/user/user_repository.dart';
import 'package:cwt_ecommerce_app/features/shop/models/order_model.dart';
import 'package:cwt_ecommerce_app/features/shop/models/product_model.dart';
import 'package:cwt_ecommerce_app/features/shop/models/review_model.dart'; // Import the review data model
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderDetailsController extends GetxController {
  final OrderModel order;
  final productRepository = Get.put(ProductRepository());
  Rx<ProductModel> product = ProductModel.empty().obs;
  final userRepository = Get.put(UserRepository());

  OrderDetailsController(this.order);

  @override
  void onReady() {
    super.onReady();
    getProductbyId();
  }

  void getProductbyId() async {
    try {
      final resultProducts =
      await productRepository.getProductByUid(order.items[0].productId);

      product.value = resultProducts!;
    } catch (e) {
      // Handle error
    }
  }


  void addUserReview() {
    RxInt rating = 1.obs;
    RxString comment = ''.obs;

    Get.dialog(
      AlertDialog(
        title: Text('Add Review'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() => Row(
              children: List.generate(
                5,
                    (index) => IconButton(
                  icon: Icon(
                    index < rating.value ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: () {
                    rating.value = index + 1;
                  },
                ),
              ),
            )),
            SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                comment.value = value;
              },
              decoration: InputDecoration(
                hintText: 'Add your comment...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final review = Review(
                uid: product.value.userId ?? "",
                stars: rating.value.toString(),
                comment: comment.value,
              );
              saveReview(review);

              Get.back();
            },
            child: Text('Submit'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> saveReview(Review review) async {
    try {
      // Save review to database using the user repository
      await userRepository.addReview(review);

      // Show success message
      showSuccessMessage();
    } catch (e) {
      // Show error message
      showErrorMessage(e.toString());
    }
  }

  void showSuccessMessage() {
    // Show success message dialog
    Get.dialog(
      AlertDialog(
        title: Text('Success'),
        content: Text('Review has been added successfully.'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void showErrorMessage(String errorMessage) {
    // Show error message dialog
    Get.dialog(
      AlertDialog(
        title: Text('Error'),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}

import 'package:cwt_ecommerce_app/data/repositories/user/user_repository.dart';
import 'package:cwt_ecommerce_app/features/personalization/models/user_model.dart';
import 'package:cwt_ecommerce_app/features/shop/models/product_model.dart';
import 'package:get/get.dart';

class ProductDetailController extends GetxController {
  late ProductModel product;
  final userRepository = Get.put(UserRepository());
  Rx<UserReviews> user = UserReviews.empty().obs;

  void init(ProductModel product) {
    this.product = product;
  }

  @override
  void onReady() {
    super.onReady();
    fetchUserById(product.userId ?? "");
  }

  Future<void> fetchUserById(String userID) async {
    try {
      final user = await userRepository.fetchUserReviews(userID);
      print("user.reviews.length");
      print(user.reviews.length);
      this.user(user);
    } catch (e) {
      user(UserReviews.empty());
    }
  }
}

import 'package:cwt_ecommerce_app/features/personalization/models/user_model.dart';
import 'package:cwt_ecommerce_app/features/shop/controllers/product/product_details_controller.dart';
import 'package:cwt_ecommerce_app/features/shop/screens/users/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:readmore/readmore.dart';

import '../../../../common/widgets/products/cart/bottom_add_to_cart_widget.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utility.dart';
import '../../models/product_model.dart';
import '../checkout/checkout.dart';
import '../product_reviews/product_reviews.dart';
import 'widgets/product_attributes.dart';
import 'widgets/product_detail_image_slider.dart';
import 'widgets/product_meta_data.dart';
import 'widgets/rating_share_widget.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final ProductDetailController controller =
        Get.put(ProductDetailController());
    controller.init(product);
    print("ProductDetailScreen");
    print(product.userId);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 1 - Product Image Slider
            TProductImageSlider(product: product),
            Obx(
              () {
                final user = controller.user.value;
                return TUserInfo(
                  user: user.user,
                );
                            },
            ),
            Container(
              padding: const EdgeInsets.only(
                  right: TSizes.defaultSpace,
                  left: TSizes.defaultSpace,
                  bottom: TSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// - Rating & Share
                  const TRatingAndShare(),

                  /// - Price, Title, Stock, & Brand
                  TProductMetaData(product: product),
                  const SizedBox(height: TSizes.spaceBtwSections / 2),

                  /// -- Attributes
                  // If Product has no variations do not show attributes as well.
                  TProductAttributes(product: product),
                  if (product.productVariations != null &&
                      product.productVariations!.isNotEmpty)
                    const SizedBox(height: TSizes.spaceBtwSections),

                  /// -- Checkout Button
                  SizedBox(
                    width: TDeviceUtils.getScreenWidth(context),
                    child: ElevatedButton(
                        child: const Text('Checkout'),
                        onPressed: () => Get.to(() => const CheckoutScreen())),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  /// - Description
                  const TSectionHeading(
                      title: 'Description', showActionButton: false),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  // Read more package
                  ReadMoreText(
                    product.description!,
                    trimLines: 2,
                    colorClickableText: Colors.pink,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: ' Show more',
                    trimExpandedText: ' Less',
                    moreStyle: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w800),
                    lessStyle: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  /// - Reviews
                  const Divider(),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TSectionHeading(
                            title:
                                'Reviews (${(controller.user.value.reviews.length).toString()})',
                            showActionButton: false,
                          ),
                          IconButton(
                            icon: const Icon(Iconsax.arrow_right_3, size: 18),
                            onPressed: () => Get.to(
                                () => ProductReviewsScreen(
                                      reviews: controller.user.value.reviews,
                                    ),
                                fullscreenDialog: true),
                          )
                        ],
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: TBottomAddToCart(product: product),
    );
  }
}

class TUserInfo extends StatelessWidget {
  final UserModel user;

  const TUserInfo({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: InkWell(
        onTap: () {
          Get.to(() => UserProfileScreen(user: user));
        },
        child: Column(
          children: [
            Row(
              children: [
                // User image or initials
                CircleAvatar(
                  radius: 25,
                  backgroundImage: user.profilePicture.isNotEmpty
                      ? NetworkImage(user.profilePicture)
                      : null,
                  child: user.profilePicture.isNotEmpty
                      ? null
                      : Text(
                          '${user.firstName.isNotEmpty ? user.firstName[0] : ""}${user.lastName.isNotEmpty ? user.lastName[0] : ""}',
                          style: TextStyle(fontSize: 20),
                        ),
                ),
                SizedBox(width: 10),
                // Full name
                Text(
                  '${user.firstName.isNotEmpty ? user.firstName : "Unknown"} ${user.lastName.isNotEmpty ? user.lastName : ""}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

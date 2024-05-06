import 'package:cwt_ecommerce_app/features/shop/models/review_model.dart';
import 'package:cwt_ecommerce_app/features/shop/screens/users/user_profile_screen.dart';
import 'package:flutter/material.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/sizes.dart';
import 'widgets/progress_indicator_and_rating.dart';
import 'widgets/rating_star.dart';
import 'widgets/review_details_container.dart';

class ProductReviewsScreen extends StatelessWidget {
  final List<Review> reviews;

  const ProductReviewsScreen({Key? key, required this.reviews})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// -- Appbar
      appBar:
          const TAppBar(title: Text('Reviews & Ratings'), showBackArrow: true),

      /// -- Body
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// -- Reviews List
              const Text(
                  "Ratings and reviews are verified and are from people who use the same type of device that you use."),
              const SizedBox(height: TSizes.spaceBtwItems),

              /// Overall Product Ratings
              TOverallProductRating(reviews : reviews),
              TRatingBarIndicator(
                rating: reviews.isNotEmpty
                    ? reviews
                    .map((review) => int.parse(review.stars))
                    .reduce((a, b) => a + b)
                    .toDouble() / reviews.length
                    : 0,
              ),
              Text(reviews.length.toString()),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// User Reviews List
              ListView.separated(
                shrinkWrap: true,
                itemCount: reviews.length,
                // Use the length of reviews
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (_, __) =>
                    const SizedBox(height: TSizes.spaceBtwSections),
                itemBuilder: (_, index) =>
                    UserReviewCard(productReview: reviews[index]),
              )
            ],
          ),
        ),
      ),
    );
  }
}

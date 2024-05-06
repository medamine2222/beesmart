import 'package:cwt_ecommerce_app/features/shop/models/review_model.dart';
import 'package:cwt_ecommerce_app/features/shop/screens/users/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'rating_progress_indicator.dart';

class TOverallProductRating extends StatelessWidget {
  final List<Review> reviews;

  const TOverallProductRating({
    Key? key,
    required this.reviews,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double averageRating = calculateAverageRating(reviews);

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            averageRating.toStringAsFixed(1),
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
        Expanded(
          flex: 7,
          child: Column(
            children: [
              for (int i = 5; i >= 1; i--)
                TRatingProgressIndicator(
                  text: i.toString(),
                  value: calculateRatingPercentage(reviews, i),
                ),
            ],
          ),
        ),
      ],
    );
  }

  double calculateAverageRating(List<Review> reviews) {
    if (reviews.isEmpty) return 0.0;
    double totalRating = reviews.map((review) => double.parse(review.stars)).reduce((a, b) => a + b);
    return totalRating / reviews.length;
  }


  double calculateRatingPercentage(List<Review> reviews, int rating) {
    if (reviews.isEmpty) return 0.0;
    int count = reviews.where((review) => review.stars == rating.toString()).length;
    return count / reviews.length;
  }
}

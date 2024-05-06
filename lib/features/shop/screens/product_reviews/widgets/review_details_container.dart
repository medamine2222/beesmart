import 'package:cwt_ecommerce_app/features/shop/models/review_model.dart';
import 'package:cwt_ecommerce_app/features/shop/screens/users/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/formatters/formatter.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import 'rating_star.dart';


class UserReviewCard extends StatelessWidget {
  const UserReviewCard({Key? key, required this.productReview}) : super(key: key);

  final Review productReview;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(backgroundImage: AssetImage(productReview.userModel?.profilePicture ?? '')),
                const SizedBox(width: 10.0),
                Text('${productReview.userModel!.firstName} ${productReview.userModel?.lastName}' ?? '', style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10.0),

        /// Review
        Row(
          children: [

            ///Review Stars
            TRatingBarIndicator(rating: double.parse(productReview.stars)),

            ///Review Date
            const SizedBox(width: 10.0),
            //Text(TFormatter.formatDate(productReview.timestamp)),
          ],
        ),
        const SizedBox(height: 10.0),

        ///Review Text
        ReadMoreText(
          productReview.comment ?? '',
          trimLines: 3,
          colorClickableText: Colors.blue,
          trimMode: TrimMode.Line,
          trimExpandedText: '  show less',
          moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue[700]),
          lessStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue[700]),
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }
}
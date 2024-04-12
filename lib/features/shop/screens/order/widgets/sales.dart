import 'package:cwt_ecommerce_app/common/widgets/loaders/animation_loader.dart';
import 'package:cwt_ecommerce_app/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/product/order_controller.dart';

class SalesScreen extends StatelessWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderController());
    return FutureBuilder(
      future: controller.fetchUserOrders(),
      builder: (_, snapshot) {
        /// Nothing Found Widget
        final emptyWidget = TAnimationLoaderWidget(
          text: 'Whoops! No Sales Yet!',
          animation: TImages.orderCompletedAnimation,
        );

        return emptyWidget;
      },
    );
  }
}

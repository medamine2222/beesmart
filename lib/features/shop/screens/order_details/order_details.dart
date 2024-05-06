import 'package:cwt_ecommerce_app/features/shop/controllers/order_details_controller.dart';
import 'package:cwt_ecommerce_app/features/shop/models/order_model.dart';
import 'package:cwt_ecommerce_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({Key? key, required this.orderModel})
      : super(key: key);

  final OrderModel orderModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.light,
      appBar: AppBar(
        title: Text('Order Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: GetBuilder<OrderDetailsController>(
          init: OrderDetailsController(orderModel),
          builder: (controller) => SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.blue,
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              controller.order.items[0].image ?? "",
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.order.items[0].title,
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              ),
                              Text(
                                'Description: ${controller.product.value.description}',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Total Price: \$${controller.order.totalAmount}',
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white, width: 1),
                                  borderRadius: BorderRadius.circular(36),
                                ),
                                child: Text(
                                  'Brand: ${controller.product.value.brand?.name ?? ""}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Steps of the order
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.order.deliveryStatus.length,
                  itemBuilder: (context, index) {
                    // Define the steps and associated dates
                    List<String> stepLabels = [
                      "En attente de confirmation",
                      "Confirmé",
                      "En cours de livraison",
                      "Livré",
                      "Finalisé"
                    ];

                    // Populate steps with static labels and dynamic dates
                    List<Map<String, String>> steps = [];
                    for (int i = 0; i < controller.order.deliveryStatus.length; i++) {
                      String date = controller.order.deliveryStatus[i].toString();
                      steps.add({"step": stepLabels[i], "date": date});
                    }

                    // Build each step widget
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            // Check icon
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.check, color: Colors.white),
                            ),
                            SizedBox(width: 16),
                            // Step text and date
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    steps[index]["step"]!,
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "Date: ${steps[index]["date"]}",
                                    style: TextStyle(fontSize: 14, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: GetBuilder<OrderDetailsController>(
        init: OrderDetailsController(orderModel),
        builder: (controller) => FloatingActionButton(
          onPressed: () {
            controller.addUserReview();
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

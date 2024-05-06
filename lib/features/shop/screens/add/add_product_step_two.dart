import 'package:cwt_ecommerce_app/features/shop/controllers/product/add_product_step_two_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProductStepTwoScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AddProductStepTwoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddProductStepTwoController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Product Step 2',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () {
                  controller.showAddAttributeDialog();
                },
                child: const Text('Add Attribute Variation'),
              ),
              const SizedBox(height: 20),
              Obx(() {
                final variations = controller.productVariations;

                if (variations.isEmpty) {
                  return const Center(
                    child: Text('No variations added yet.'),
                  );
                }

                return Obx(() => ListView.builder(
                  shrinkWrap: true,
                  itemCount: variations.length,
                  itemBuilder: (context, index) {
                    final variation = variations[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: SizedBox(
                          width: 60,
                          child: Image.network(
                            variation.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          variation.description ?? "",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('SKU: ${variation.sku}'),
                            Text('Price: \$${variation.price.toStringAsFixed(2)}'),
                            Text('Sale Price: \$${variation.salePrice.toStringAsFixed(2)}'),
                            Text('Stock: ${variation.stock}'),
                            const SizedBox(height: 8),
                            Text(
                              'Attributes:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: variation.attributeValues.entries
                                  .map((entry) => Text('${entry.key}: ${entry.value}'))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ));
              }),
              ElevatedButton(
                onPressed: () {
                  controller.addProduc();
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:cwt_ecommerce_app/data/repositories/brands/brand_repository.dart';
import 'package:cwt_ecommerce_app/data/repositories/categories/category_repository.dart';
import 'package:cwt_ecommerce_app/data/repositories/product/product_repository.dart';
import 'package:cwt_ecommerce_app/features/shop/models/brand_model.dart';
import 'package:cwt_ecommerce_app/features/shop/models/category_model.dart';
import 'package:cwt_ecommerce_app/features/shop/models/product_model.dart';
import 'package:cwt_ecommerce_app/features/shop/models/product_variation_model.dart';
import 'package:cwt_ecommerce_app/home_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AddProductStepTwoController extends GetxController {
  RxList<BrandModel> allBrands = <BrandModel>[].obs;
  final Rx<BrandModel?> selectedBrand = Rx<BrandModel?>(null);
  FirebaseAuth auth = FirebaseAuth.instance;

  RxList<CategoryModel> allCategories = <CategoryModel>[].obs;
  final Rx<CategoryModel?> selectedCategory = Rx<CategoryModel?>(null);
  final ProductRepository _repository = ProductRepository.instance;
  final brandRepository = Get.put(BrandRepository());
  final _categoryRepository = Get.put(CategoryRepository());
  late ProductModel product;
  final RxList<ProductVariationModel> productVariations = RxList<ProductVariationModel>();

  @override
  void onInit() {
    super.onInit();
    product = Get.arguments as ProductModel;
  }

  void showAddAttributeDialog() {
    String sku = '';
    String description = '';
    double price = 0;
    double salePrice = 0;
    int stock = 0;
    final Rx<String?> selectedImage = Rx<String?>(null);
    final Rx<String?> selectedColor = Rx<String?>(null);
    final Rx<String?> selectedSize = Rx<String?>(null);

    Get.dialog(
      Dialog(
        child: Obx(() => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min, // Adjust as per your need
            children: [
              Text(
                'Add Attribute Variation',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: product.images?.where((imageUrl) {
                  // Check if the image URL does not exist in any productVariations
                  return !productVariations.value.any((variation) => variation.image == imageUrl);
                }).map((imageUrl) {
                  final isSelected = imageUrl == selectedImage.value;

                  return GestureDetector(
                    onTap: () {
                      selectedImage.value = imageUrl;
                    },
                    child: Stack(
                      children: [
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: CachedNetworkImage(
                            imageUrl: imageUrl ?? "",
                            fit: BoxFit.cover,
                          ),
                        ),
                        if (isSelected)
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.green, width: 2),
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList() ?? [],
              ),
              SizedBox(height: 8),
              // Wrap for colors
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(
                  product.productAttributes?.length ?? 0,
                      (index) {
                    final attribute = product.productAttributes![index];
                    if (attribute.name == 'Color') {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Colors', // Title for colors
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: attribute.values?.where((colorName) {
                              final isUsedColor = productVariations.value.any((variation) =>
                              variation.attributeValues['Color'] == colorName);
                              return !isUsedColor; // Filter out used colors
                            }).map((colorName) {
                              final isSelected = colorName == selectedColor.value;

                              return GestureDetector(
                                onTap: () {
                                  selectedColor.value = colorName;
                                },
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: isSelected ? Colors.green : Colors.black,
                                      width: 2,
                                    ),
                                    color: isSelected ? Colors.green : Colors.transparent,
                                  ),
                                  child: Center(
                                    child: Text(
                                      colorName,
                                      style: TextStyle(
                                        color: isSelected ? Colors.white : Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList() ?? [],
                          )
                        ],
                      );
                    } else if (attribute.name == 'Size') {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sizes', // Title for sizes
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: attribute.values?.where((size) {
                              final isUsedSize = productVariations.value.any((variation) =>
                              variation.attributeValues['Size'] == size);
                              return !isUsedSize; // Filter out used sizes
                            }).map((size) {
                              final isSelected = size == selectedSize.value;

                              return GestureDetector(
                                onTap: () {
                                  selectedSize.value = size;
                                },
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: isSelected ? Colors.green : Colors.black,
                                      width: 2,
                                    ),
                                    color: isSelected ? Colors.green : Colors.transparent,
                                  ),
                                  child: Center(
                                    child: Text(
                                      size!,
                                      style: TextStyle(
                                        color: isSelected ? Colors.white : Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList() ?? [],
                          )
                        ],
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                onChanged: (value) => sku = value,
                decoration: InputDecoration(
                  labelText: 'SKU',
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                onChanged: (value) => description = value,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                onChanged: (value) => price = double.tryParse(value) ?? 0,
                keyboardType: TextInputType.number, // Set keyboard type to number
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                onChanged: (value) => salePrice = double.tryParse(value) ?? 0,
                keyboardType: TextInputType.number, // Set keyboard type to number
                decoration: InputDecoration(
                  labelText: 'Sale Price',
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                onChanged: (value) => stock = int.tryParse(value) ?? 0,
                decoration: InputDecoration(
                  labelText: 'Stock',
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.back(); // Close the dialog
                    },
                    child: const Text('Cancel'),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      final Map<String, String> attributeValues = {};

                      if (selectedColor.value != null && selectedColor.value!.isNotEmpty) {
                        attributeValues['Color'] = selectedColor.value!;
                      }

                      if (selectedSize.value != null && selectedSize.value!.isNotEmpty) {
                        attributeValues['Size'] = selectedSize.value!;
                      }

                      final productVariation = ProductVariationModel(
                        id: (productVariations.value.length + 1).toString(),
                        sku: sku,
                        image: selectedImage.value ?? '',
                        description: description,
                        price: price,
                        salePrice: salePrice,
                        stock: stock,
                        attributeValues: attributeValues,
                      );

                      productVariations.value.add(productVariation);
                      Get.back(); // Close the dialog

                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            ],
          ),
        )),
      ),
    );
  }

  Future<void> addProduc() async {
    try {
      product.productVariations = productVariations;
      await _repository.addProduct(product);
      Get.offAll(() => const HomeMenu());
    } catch (error) {
      // Handle error
      print('Error adding fake product: $error');
    }
  }

}

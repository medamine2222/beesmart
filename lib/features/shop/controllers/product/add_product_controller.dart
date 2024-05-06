import 'dart:io';

import 'package:cwt_ecommerce_app/data/repositories/brands/brand_repository.dart';
import 'package:cwt_ecommerce_app/data/repositories/categories/category_repository.dart';
import 'package:cwt_ecommerce_app/data/repositories/product/product_repository.dart';
import 'package:cwt_ecommerce_app/features/shop/models/brand_model.dart';
import 'package:cwt_ecommerce_app/features/shop/models/category_model.dart';
import 'package:cwt_ecommerce_app/features/shop/models/product_attribute_model.dart';
import 'package:cwt_ecommerce_app/features/shop/models/product_model.dart';
import 'package:cwt_ecommerce_app/features/shop/screens/add/add_product_step_two.dart';
import 'package:cwt_ecommerce_app/home_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddProductController extends GetxController {
  RxList<BrandModel> allBrands = <BrandModel>[].obs;
  final Rx<BrandModel?> selectedBrand = Rx<BrandModel?>(null);
  FirebaseAuth auth = FirebaseAuth.instance;

  RxList<CategoryModel> allCategories = <CategoryModel>[].obs;
  final Rx<CategoryModel?> selectedCategory = Rx<CategoryModel?>(null);

  final brandRepository = Get.put(BrandRepository());
  final _categoryRepository = Get.put(CategoryRepository());

  RxString title = ''.obs;
  RxString description = ''.obs;
  RxDouble price = 0.0.obs;
  RxString size = ''.obs;
  RxList<String> selectedColors = <String>[].obs;

  List<Map<String, String>> availableColors = [
    {'name': 'Red', 'code': '0xFFFF0000'},
    {'name': 'Green', 'code': '0xFF00FF00'},
    {'name': 'Blue', 'code': '0xFF0000FF'},
  ];

  void addColor(String colorCode) {
    selectedColors.clear();
    selectedColors.add(colorCode);
  }

  void removeColor(String colorCode) {
    selectedColors.remove(colorCode);
  }

  @override
  void onInit() {
    getFeaturedBrands();
    fetchCategories();
    super.onInit();
  }

  Future<void> fetchCategories() async {
    try {
      final fetchedCategories = await _categoryRepository.getAllCategories();

      allCategories.assignAll(fetchedCategories);
    } catch (e) {}
  }

  Future<void> getFeaturedBrands() async {
    try {
      final fetchedCategories = await brandRepository.getAllBrands();
      allBrands.assignAll(fetchedCategories);
    } catch (e) {}
  }

  final RxList<String> _selectedImages = <String>[].obs;

  List<String> get selectedImages => _selectedImages;

  final ProductRepository _repository = ProductRepository.instance;

  void pickImageFromGallery() async {
    await Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Gallery'),
              onTap: () {
                Get.back();
                _getImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Camera'),
              onTap: () {
                Get.back();
                _getImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage == null) return;
    final imageFile = File(pickedImage.path);

    // Upload the image to Firebase Storage and get the URL
    try {
      final imageUrl = await _repository.uploadImageToStorage(
          'Products', imageFile, pickedImage.path);
      // Save the URL in selectedImages
      print("imageUrl");
      print(imageUrl);
      _selectedImages.add(imageUrl);
    } catch (error) {
      // Handle error
      print('Error uploading image: $error');
    }
  }

  void removeImage(int index) {
    _selectedImages.removeAt(index);
  }

  void addFakeProduct() async {
    if (title.isEmpty) {
      Get.snackbar('Error', 'Title cannot be empty',
          snackPosition: SnackPosition.TOP);
      return;
    }
    if (description.isEmpty) {
      Get.snackbar('Error', 'Description cannot be empty',
          snackPosition: SnackPosition.TOP);
      return;
    }
    if (price.value <= 0) {
      Get.snackbar('Error', 'Price must be greater than 0',
          snackPosition: SnackPosition.TOP);
      return;
    }
    if (selectedCategory.value == null) {
      Get.snackbar('Error', 'Please select a category',
          snackPosition: SnackPosition.TOP);
      return;
    }

    if (selectedBrand.value == null) {
      Get.snackbar('Error', 'Please select a brand',
          snackPosition: SnackPosition.TOP);
      return;
    }

    if (_selectedImages.isEmpty) {
      Get.snackbar('Error', 'Please upload at least one image',
          snackPosition: SnackPosition.TOP);
      return;
    }

    List<ProductAttributeModel> productAttributes = [];
    if (selectedColors.isNotEmpty) {
      productAttributes.add(ProductAttributeModel(
        name: 'Color',
        values: selectedColors.map((colorCode) {
          final color = availableColors.firstWhere(
            (element) => element['code'] == colorCode,
            orElse: () => {'name': 'Unknown'},
          );
          return color['name']!;
        }).toList(),
      ));
    }

    productAttributes.add(ProductAttributeModel(
      name: 'Size',
      values: [size.value],
    ));

    ProductModel product = ProductModel(
      id: '',
      sku: "",
      title: title.value,
      stock: 1,
      price: price.value,
      thumbnail: selectedImages.first,
      salePrice: price.value,
      isFeatured: true,
      categoryId: selectedCategory.value?.id,
      brand: selectedBrand.value,
      images: selectedImages,
      description: description.value,
      productType: 'ProductType.single',
      productAttributes: productAttributes,
      userId: auth.currentUser?.uid ?? '',
    );
    try {
      await _repository.addProduct(product);
      Get.offAll(() => const HomeMenu());
    } catch (error) {
      // Handle error
      print('Error adding fake product: $error');
    }

  }


}

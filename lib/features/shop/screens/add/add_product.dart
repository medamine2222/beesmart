import 'package:cwt_ecommerce_app/features/shop/controllers/product/add_product_controller.dart';
import 'package:cwt_ecommerce_app/features/shop/models/brand_model.dart';
import 'package:cwt_ecommerce_app/features/shop/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AddScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddProductController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Product',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100.0),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Title:'),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: 'Enter title',
                    ),
                    onChanged: (value) {
                      controller.title.value = value;
                    },
                  ),
                  SizedBox(height: 16.0),
                  Text('Description:'),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: 'Enter description',
                    ),
                    onChanged: (value) {
                      controller.description.value = value;
                    },
                  ),
                  SizedBox(height: 16.0),
                  Text('Price:'),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: 'Enter price',
                    ),
                    onChanged: (value) {
                      controller.price.value = double.parse(value);
                    },
                  ),
                  SizedBox(height: 16.0),
                  Text('Select Category:'),
                  SizedBox(
                    height: 8.0,
                  ),
                  InputDecorator(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: Obx(() => DropdownButton<CategoryModel>(
                        value: controller.selectedCategory.value,
                        isDense: true,
                        isExpanded: true,
                        items: controller.allCategories
                            .map<DropdownMenuItem<CategoryModel>>(
                              (CategoryModel category) {
                            return DropdownMenuItem<CategoryModel>(
                              value: category,
                              child: Text(category.name),
                            );
                          },
                        ).toList(),
                        onChanged: (CategoryModel? newValue) {
                          controller.selectedCategory.value = newValue!;
                        },
                      )),
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text('Select Brand:'),
                  SizedBox(
                    height: 8.0,
                  ),
                  InputDecorator(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<BrandModel>(
                        value: controller.selectedBrand.value,
                        isDense: true,
                        isExpanded: true,
                        items: controller.allBrands
                            .map<DropdownMenuItem<BrandModel>>(
                              (BrandModel brand) {
                            return DropdownMenuItem<BrandModel>(
                              value: brand,
                              child: Text(brand.name),
                            );
                          },
                        ).toList(),
                        onChanged: (BrandModel? newValue) {
                          controller.selectedBrand.value = newValue!;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text('Sizes:'),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: 'Enter size',
                    ),
                    onChanged: (value) {
                      controller.size.value = value;
                    },
                  ),
                  SizedBox(height: 16.0),
                  Text('Colors:'),
                  SizedBox(height: 8.0),
                  Wrap(
                    children: List.generate(
                      controller.availableColors.length,
                          (index) {
                        final colorCode = controller.availableColors[index]['code'];
                        final isSelected = controller.selectedColors.contains(colorCode);
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: InkWell(
                            onTap: () {
                              if (isSelected) {
                                controller.removeColor(colorCode);
                              } else {
                                controller.addColor(colorCode);
                              }
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Color(int.parse(colorCode!)),
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                  color: isSelected ? Colors.blue : Colors.transparent,
                                  width: isSelected ? 2.0 : 0.0,
                                ),
                              ),
                              child: isSelected ? Icon(Icons.check, color: Colors.blue) : null,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text('Add Images :'),
                  SizedBox(
                    height: 8.0,
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                    ),
                    itemCount: controller.selectedImages.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            onPressed: () {
                              controller.pickImageFromGallery();
                            },
                            icon: const Icon(Icons.add_circle_outlined,
                                size: 40),
                          ),
                        );
                      } else {
                        final imageIndex = index - 1;
                        return Stack(
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  controller.selectedImages[imageIndex],
                                  width: 150,
                                  height: 200,
                                  fit: BoxFit.cover,
                                )),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: IconButton(
                                onPressed: () {
                                  controller.removeImage(imageIndex);
                                },
                                icon: const Icon(Icons.close),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(onPressed: () => controller.addFakeProduct(), child: const Text("Submit")),
                  )
                ],
              )),
            ),
          ),
        ),
      ),
    );
  }
}

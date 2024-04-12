import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddProduct();
}

class _AddProduct extends State<AddScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _selectedCategory;
  final List<String> _categories = ['Sports', 'Electronics', 'Clothes', 'Animals', 'Furniture', 'Shoes', 'Cosmetics'];
  String? _selectedWeight;
  String? _selectedState;
  final List<File?> _selectedImages = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _purchasePriceController = TextEditingController();
  final TextEditingController _sellingPriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const ListTile(
                  title: Text('Add Images :'),
                ),
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: _selectedImages.length < 4 ? _selectedImages.length + 1 : 4,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == _selectedImages.length && _selectedImages.length < 4) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            onPressed: () {
                              showImagePickerOption(context);
                            },
                            icon: const Icon(Icons.add_circle_outlined, size: 40),
                          ),
                        );
                      } else {
                        return Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.file(
                                  _selectedImages[index]!,
                                  width: 150,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedImages.removeAt(index);
                                  });
                                },
                                icon: const Icon(Icons.close),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
                const ListTile(
                  title: Text('Basic info :'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _titleController,
                    validator: _validateField,
                    decoration: const InputDecoration(
                      labelText: 'Product Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _descriptionController,
                    validator: _validateField,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Product Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                const ListTile(
                  title: Text('More Info :'),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                    },
                    items: _categories.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    validator: _validateField,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<String>(
                    value: _selectedState,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedState = newValue;
                      });
                    },
                    items: <String>[
                      'New',
                      'Very Good State',
                      'Good State',
                      'Satisfying',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      labelText: 'State',
                      border: OutlineInputBorder(),
                    ),
                    validator: _validateField,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<String>(
                    value: _selectedWeight,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedWeight = newValue;
                      });
                    },
                    items: <String>[
                      '1 - 10 kg',
                      '11 - 30 kg',
                      '31 - 60 kg',
                      '> 60 kg',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      labelText: 'Weight',
                      border: OutlineInputBorder(),
                    ),
                    validator: _validateField,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _sellingPriceController,
                          validator: _validateField,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Selling Price',
                            border: OutlineInputBorder(),
                            suffixText: 'DT',
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: TextFormField(
                          controller: _purchasePriceController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Purchase Price',
                            border: OutlineInputBorder(),
                            suffixText: 'DT',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Validation réussie
                          // Implémentez votre logique de sauvegarde ici
                          _saveProduct();
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showImagePickerOption(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 8,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _pickImageFromGallery();
                      },
                      child: const SizedBox(
                        height: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_rounded,
                              size: 35,
                            ),
                            Text("Gallery"),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _pickImageFromCamera();
                      },
                      child: const SizedBox(
                        height: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt_rounded,
                              size: 35,
                            ),
                            Text("Camera"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future _pickImageFromGallery() async {
    final pickedImage =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;
    setState(() {
      _selectedImages.add(File(pickedImage.path));
    });
    Navigator.of(context).pop();
  }

  Future _pickImageFromCamera() async {
    final pickedImage =
    await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedImage == null) return;
    setState(() {
      _selectedImages.add(File(pickedImage.path));
    });
    Navigator.of(context).pop();
  }

  String? _validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  void _saveProduct() {
    final String title = _titleController.text;
    final String description = _descriptionController.text;
  }
}

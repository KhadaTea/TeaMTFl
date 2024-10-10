import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:midterm/database/service.dart';
import 'package:midterm/database/product.dart';
import 'dart:io';

class ProductForm extends StatefulWidget {
  const ProductForm({super.key});

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  int k = 0;
  bool dataIsAvailable = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "ProductAdd",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, top: 30.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Product Name",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.only(left: 10.0),
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10)),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(border: InputBorder.none),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              "Price",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.only(left: 10.0),
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10)),
              child: TextField(
                controller: _priceController,
                decoration: InputDecoration(border: InputBorder.none),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              "Type",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.only(left: 10.0),
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10)),
              child: TextField(
                controller: _categoryController,
                decoration: InputDecoration(border: InputBorder.none),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            TextFormField(
              controller: _imageController,
              decoration:
                  const InputDecoration(hintText: 'Input link product'),
              readOnly: true,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                String? imagePath = await _uploadImage();
                if (imagePath != null && context.mounted) {
                  _imageController.text = imagePath;
                }
              },
              child: const Text('Upload image'),
            ),
            
            SizedBox(
              height: 30.0,
            ),
            Center(
              child: ElevatedButton(
                  onPressed: () async {
                    await addProductButton();
                    if (k == 0 && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Product has been added'),
                          backgroundColor: Color.fromARGB(255, 144, 59, 255),
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    "Add",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  )),
            )
          ],
        ),
      ),
    );
  }



  Future<void> addProductButton() async {
    final name = _nameController.text.trim();
    final image = _imageController.text.trim();
    final category = _categoryController.text.trim();
    final price = _priceController.text.trim();

    if (name.isEmpty || image.isEmpty || category.isEmpty || price.isEmpty) {
      k = 1;
      return;
    }
    final product = Product(
      id: Random().nextInt(1000000).toString(),
      name: name,
      image: image,
      category: category,
      price: int.parse(price),
      description: '',
    );
    addProduct(product);
    // Clear the text fields after adding the product
  _nameController.clear();
  _imageController.clear();
  _categoryController.clear();
  _priceController.clear();

  }

  Future<String?> _uploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}.png';
      Reference storageReference =
          FirebaseStorage.instance.ref().child(fileName);

      try {
        UploadTask uploadTask = storageReference.putFile(File(image.path));
        TaskSnapshot taskSnapshot = await uploadTask;

        String imageUrl = await taskSnapshot.ref.getDownloadURL();
        return imageUrl;
      } catch (e) {
        print("Lỗi khi tải ảnh lên: $e");
        return null;
      }
    }
    return null;
  }
}

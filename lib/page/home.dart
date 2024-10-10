import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:midterm/database/product.dart';
import 'package:midterm/database/service.dart';
import 'package:midterm/page/button_bar.dart'; // Đảm bảo rằng đây là đúng đường dẫn

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
    Container buildProductItem(Product product) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: NetworkImage(product.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Price: ${product.price} VNĐ',
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Type: ${product.category}',
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.purple),
                onPressed: () {
                  String id = product.id;
                  deleteProduct(id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Deleted product'),
                      backgroundColor: Color.fromARGB(255, 17, 161, 228),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.orange),
                onPressed: () {
                  // final details = BottomUpSheet(
                  //     id: product.id,
                  //     category: product.category,
                  //     name: product.name,
                  //     price: product.price.toString(),
                  //     image: product.image,
                  //     context: context);
                  // details.productDetailsForm();
                },
              ),
            ],
          ),
        ]
      )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ProductForm()));
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 20, 201, 225),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Product Data",
              style: TextStyle(
                color: const Color.fromARGB(255, 231, 57, 69),
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        elevation: 5,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // signOutUser(context);
            },
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: productListNotifier,
        builder: (BuildContext context, List<Product> data, Widget? child) {
          if (data.isEmpty) {
            return const Center(
                child: Text('No Data Found!!'));
          }
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final product = data[index];
              return buildProductItem(
                product,
              );
            },
          );
        },
      ),
      backgroundColor: const Color.fromARGB(255, 242, 243, 248),
    );
  }
}

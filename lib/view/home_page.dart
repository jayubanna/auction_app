import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_shoping/controller/cart_controller.dart';
import 'package:online_shoping/controller/product_controller.dart';
import '../model/product_model.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProductController productController = Get.put(ProductController());
  final CartController cartController = Get.put(CartController());

  final TextEditingController productNameController = TextEditingController();

  final TextEditingController categoryController = TextEditingController();

  final TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        centerTitle: true,
        backgroundColor: Colors.black26,
        actions: [IconButton(onPressed: () {
          Get.toNamed("/cart_page");
        }, icon: Icon(Icons.shopping_cart))],
      ),
      body: Obx(() {
        if (productController.products.isEmpty) {
          return Center(child: Text("No products found"));
        } else {
          return ListView.builder(
            itemCount: productController.products.length,
            itemBuilder: (context, index) {
              var product = productController.products[index];
              return Card(
                child: ListTile(
                  title: Text("${productController.products[index]["productname"]}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Category: ${productController.products[index]["catgory"]}"),
                      Text("Price: \$${productController.products[index]["price"]}"),
                      Row(
                        children: [
                          IconButton(onPressed: () {
                            productNameController.text = product["productname"];
                            categoryController.text = product["catgory"];
                            priceController.text = product["price"].toString();

                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Edit Product"),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Product Name", style: TextStyle(fontSize: 22)),
                                        SizedBox(height: 5),
                                        TextField(
                                          controller: productNameController,
                                          decoration: InputDecoration(border: OutlineInputBorder()),
                                        ),
                                        SizedBox(height: 10),
                                        Text("Category", style: TextStyle(fontSize: 22)),
                                        SizedBox(height: 5),
                                        TextField(
                                          controller: categoryController,
                                          decoration: InputDecoration(border: OutlineInputBorder()),
                                        ),
                                        SizedBox(height: 10),
                                        Text("Price", style: TextStyle(fontSize: 22)),
                                        SizedBox(height: 5),
                                        TextField(
                                          controller: priceController,
                                          decoration: InputDecoration(border: OutlineInputBorder()),
                                          keyboardType: TextInputType.number,
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        if (productNameController.text.isNotEmpty &&
                                            categoryController.text.isNotEmpty &&
                                            priceController.text.isNotEmpty) {
                                          Product updatedProduct = Product(
                                            productname: productNameController.text,
                                            catgory: categoryController.text,
                                            price: int.parse(priceController.text),
                                          );

                                          // Update product in SQLite
                                          productController.updateProduct(product["id"], updatedProduct);
                                          productNameController.clear();
                                          categoryController.clear();
                                          priceController.clear();
                                          Get.back();
                                        }
                                      },
                                      child: Text("Update"),
                                    ),
                                  ],
                                );
                              },
                            );
                          }, icon: Icon(Icons.edit)),
                          IconButton(onPressed: () {
                            Product productToDelete = Product(
                              productname: productController.products[index]["productname"],
                              catgory: productController.products[index]["catgory"],
                              price: productController.products[index]["price"],
                            );
                            productController.deleteProduct(productToDelete);
                          }, icon: Icon(Icons.delete)),
                        ],
                      )
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.add_shopping_cart),
                    onPressed: () async{
                      await cartController.addProductToCart(product);
                      Get.snackbar("Added to Cart", "${product["productname"]} added to cart");
                    },
                  ),
                ),
              );
            },
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Add Product"),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Product Name", style: TextStyle(fontSize: 22)),
                      SizedBox(height: 5),
                      TextField(
                        controller: productNameController,
                        decoration: InputDecoration(border: OutlineInputBorder()),
                      ),
                      SizedBox(height: 10),
                      Text("Category", style: TextStyle(fontSize: 22)),
                      SizedBox(height: 5),
                      TextField(
                        controller: categoryController,
                        decoration: InputDecoration(border: OutlineInputBorder()),
                      ),
                      SizedBox(height: 10),
                      Text("Price", style: TextStyle(fontSize: 22)),
                      SizedBox(height: 5),
                      TextField(
                        controller: priceController,
                        decoration: InputDecoration(border: OutlineInputBorder()),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () {
                      if (productNameController.text.isNotEmpty &&
                          categoryController.text.isNotEmpty &&
                          priceController.text.isNotEmpty) {
                        Product newProduct = Product(
                          productname: productNameController.text,
                          catgory: categoryController.text,
                          price: int.parse(priceController.text),
                        );

                        productController.addProduct(newProduct);
                        productNameController.clear();
                        categoryController.clear();
                        priceController.clear();
                        Get.back(); 
                      }
                    },
                    child: Text("Add"),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:online_shoping/helper/db_helper.dart';

import '../model/product_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController productnamecontroller = TextEditingController();
  TextEditingController priceecontroller = TextEditingController();
  TextEditingController catgorycontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: DbHelper.dbHelper.Fectallproduct(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else if (snapshot.hasData) {

            List<Map<String, dynamic>>? data= snapshot.data;

           return (data==null)? Center(child: Text("no data in found")): ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
               return ListTile(
                  title: Text("${data[index]["productname"]}"),
                  subtitle: Column(
                    children: [
                      Text("${data[index]["catgory"]}"),
                      Text("${data[index]["price"]}"),
                    ],
                  ),
                );
              },
            );
          }
          else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Add to Product"),
                    content: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "product name",
                            style: TextStyle(fontSize: 22),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: productnamecontroller,
                            decoration:
                                InputDecoration(border: OutlineInputBorder()),
                          ),
                          Text(
                            "catgory",
                            style: TextStyle(fontSize: 22),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: catgorycontroller,
                            decoration:
                                InputDecoration(border: OutlineInputBorder()),
                          ),
                          Text(
                            "price",
                            style: TextStyle(fontSize: 22),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: priceecontroller,
                            decoration:
                                InputDecoration(border: OutlineInputBorder()),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text("No")),
                      TextButton(
                          onPressed: () {
                            if (productnamecontroller.text.isNotEmpty &&
                                catgorycontroller.text.isNotEmpty &&
                                priceecontroller.text.isNotEmpty) {
                              Product NewProduct = Product(
                                productname: productnamecontroller.text,
                                catgory: catgorycontroller.text,
                                price: int.parse(priceecontroller.text),
                              );

                              DbHelper.dbHelper
                                  .insertproduct(product: NewProduct);

                              productnamecontroller.clear();
                              catgorycontroller.clear();
                              priceecontroller.clear();
                            }
                          },
                          child: Text("Yes")),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.add)),
      ),
    );
  }
}

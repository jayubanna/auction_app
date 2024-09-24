import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_shoping/controller/cart_controller.dart';

class CartPage extends StatelessWidget {
  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: cartController.getCartItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Your cart is empty."));
          } else {
            var cartItems = snapshot.data!;

            return ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                var cartItem = cartItems[index];

                String docId = cartItem['id'] ?? 'unknown_id';
                String productName = cartItem["productname"] ?? "Unknown Product";
                String category = cartItem["catgory"] ?? "Unknown Category";
                int price = (cartItem["price"] is int)
                    ? cartItem["price"]
                    : int.tryParse(cartItem["price"]?.toString() ?? "0") ?? 0;

                return ListTile(
                  title: Text(productName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Category: $category"),
                      Text("Price: \$${price.toString()}"),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      await cartController.firestore.collection('cart').doc(docId).delete();
                      Get.snackbar("Removed from Cart", "$productName removed from cart");
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

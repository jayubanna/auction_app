import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addProductToCart(Map<String, dynamic> product) async {
    await firestore.collection('cart').add(product);
  }

  Stream<List<Map<String, dynamic>>> getCartItems() {
    return firestore.collection('cart').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'productname': doc['productname'],
          'catgory': doc['catgory'],
          'price': doc['price'],
        };
      }).toList();
    });
  }
}

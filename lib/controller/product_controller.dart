import 'package:get/get.dart';
import 'package:online_shoping/helper/db_helper.dart';
import '../model/product_model.dart';

class ProductController extends GetxController {
  var products = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void fetchProducts() async {
    try {
      products.value = await DbHelper.dbHelper.fetchAllProducts();
    } catch (e) {
      print("Error fetching products: $e");
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      await DbHelper.dbHelper.insertProduct(product: product);
      fetchProducts();
    } catch (e) {
      print("Error adding product: $e");
    }
  }

  Future<void> deleteProduct(Product product) async {
    try {
      await DbHelper.dbHelper.deleteProduct(product: product);
      fetchProducts();
    } catch (e) {
      print("Error deleting product: $e");
    }
  }

  Future<void> updateProduct(int productId, Product updatedProduct) async {
    try {
      await DbHelper.dbHelper.updateProduct(productId, updatedProduct);
      fetchProducts();
    } catch (e) {
      print("Error updating product: $e");
    }
  }
}

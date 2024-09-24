import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/product_model.dart';

class DbHelper {
  static final DbHelper dbHelper = DbHelper._();

  DbHelper._();

  Database? db;

  Future<void> initDb() async {
    String databasePath = await getDatabasesPath();
    final path = join(databasePath, "product.db");

    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        String query = "CREATE TABLE product("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "productname TEXT, "
            "catgory TEXT, "
            "price INTEGER)";
        await db.execute(query);
      },
    );
  }

  Future<void> insertProduct({required Product product}) async {
    try {
      if (db == null) {
        await initDb();
      }
      String query = "INSERT INTO product(productname, catgory, price) VALUES (?, ?, ?)";
      List<dynamic> args = [product.productname, product.catgory, product.price];
      await db!.rawInsert(query, args);
    } catch (e) {
      print("Error inserting product: $e");
    }
  }

  Future<void> deleteProduct({required Product product}) async {
    try {
      if (db == null) {
        await initDb();
      }
      String query = "DELETE FROM product WHERE productname = ? AND catgory = ?";
      List<dynamic> args = [product.productname, product.catgory];
      await db!.rawDelete(query, args);
    } catch (e) {
      print("Error deleting product: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllProducts() async {
    try {
      if (db == null) {
        await initDb();
      }
      String query = "SELECT * FROM product";
      return await db!.rawQuery(query);
    } catch (e) {
      print("Error fetching products: $e");
      return [];
    }
  }

  Future<void> updateProduct(int id, Product updatedProduct) async {
    try {
      if (db == null) {
        await initDb();
      }
      String query = "UPDATE product SET productname = ?, catgory = ?, price = ? WHERE id = ?";
      List<dynamic> args = [updatedProduct.productname, updatedProduct.catgory, updatedProduct.price, id];
      await db!.rawUpdate(query, args);
    } catch (e) {
      print("Error updating product: $e");
    }
  }

  Future<Map<String, dynamic>?> fetchProductById(int id) async {
    try {
      if (db == null) {
        await initDb();
      }
      String query = "SELECT * FROM product WHERE id = ?";
      List<Map<String, dynamic>> result = await db!.rawQuery(query, [id]);
      return result.isNotEmpty ? result.first : null;
    } catch (e) {
      print("Error fetching product by ID: $e");
      return null;
    }
  }
}

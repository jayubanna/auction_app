import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/product_model.dart';

class DbHelper {
  static final DbHelper dbHelper = DbHelper._();

  DbHelper._();

  Database? Db;

  initDb() async {
    String? database = await getDatabasesPath();

    final path = join(database, "product.db");

    openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      String Query =
          "CREATE TABLE product(id INTEGER PRIMARY KEY,productname  TEXT,catgory TEXT,price INTEGER)";

      await db.execute(Query);
    });
  }

  insertproduct({required Product product}) async{
    if (Db == null) {
      initDb();
    }
    String Query="INSERT INTO product(productname,catgory,price) VALUES(?,?,?)";
    List arg=[product.productname,product.catgory,product.price];

    await Db?.rawInsert(Query,arg);
  }

  delateproduct({required Product product}) async{
    if (Db == null) {
      initDb();
    }
    String Query="DELETE * FORM product";
    List arg=[product.productname,product.catgory,product.price];

    await Db?.rawInsert(Query,arg);
  }


  Future<List<Map<String,dynamic>>> Fectallproduct()async{
    if (Db == null) {
      initDb();
    }
    String Query="SELECT * FORM product";

    List<Map<String,dynamic>> alldata= await Db!.rawQuery(Query);

    return alldata;
  }


}


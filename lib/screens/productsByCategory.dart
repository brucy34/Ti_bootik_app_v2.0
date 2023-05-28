import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:ti_bootik_app_vtwo/screens/infoProducts.dart';
import 'package:ti_bootik_app_vtwo/models/product.dart';



class productsByCategory extends StatefulWidget {
  List<Product> myList=[];
  String? mail;
  String idCategory;
  String dbname1;
  String dbname2;
  productsByCategory({required this.myList,required this.idCategory,this.mail,required this.dbname1,required this.dbname2});
  @override
  productsByCategoryPage createState() => productsByCategoryPage(myList: myList,idCategory: idCategory,mail: mail,dbname1: dbname1,dbname2: dbname2);
}
class productsByCategoryPage extends State<productsByCategory>{
  List<Product> myList=[];
  String? mail;
  String idCategory;
  String dbname1;
  String dbname2;
  productsByCategoryPage({required this.myList,required this.idCategory,this.mail,required this.dbname1,required this.dbname2});

  Future<Database?> initializeDB(String dbname) async {
    String path = await getDatabasesPath();
    if (mail != null) {
      return openDatabase(
        join(path, dbname),
        onCreate: (database, version) async {
          await database.execute(
              "CREATE TABLE IF NOT EXISTS ${mail?.substring(0, mail?.indexOf(
                  '@'))}products (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, price INTEGER, category TEXT,description TEXT,image TEXT )");
        },
        version: 1,
      );
    }
    else {
      return null;
    }
  }


  Future<String> insertProd(Product prod, String dbname) async {
    // Get a reference to the database.
    final db = await initializeDB(dbname);

    // Insert the product into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same product is inserted twice.
    //
    // In this case, replace any previous data.
    if (db != null) {
      await db.insert(
        '${mail?.substring(0, mail?.indexOf('@'))}products',
        prod.mapping(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return 'Add correctly';
    }
    else {
      return 'Must connected first';
    }
  }


  Future<List<Product>?> prodList(String dbname) async {
    // Get a reference to the database.
    final db = await initializeDB(dbname);

    // Query the table for all The products.
    if (db != null) {
      final List<Map<String, dynamic>> maps = await db.query(
          '${mail?.substring(0, mail?.indexOf('@'))}products');
      // Convert the List<Map<String, dynamic> into a List<Dog>.
      return List.generate(maps.length, (i) {
        return Product(
          id: maps[i]['id'],
          name: maps[i]['name'],
          price: maps[i]['price'],
          category: maps[i]['category'],
          description: maps[i]['description'],
          image: maps[i]['image'],
        );
      });
    }
    else {
      return null;
    }
  }
  Future<void> deleteProd(int id, String dbname) async {
    // Get a reference to the database.
    final db = await initializeDB(dbname);

    // Remove the Dog from the database.
    if (db != null) {
      await db.delete(
        '${mail?.substring(0, mail?.indexOf('@'))}products',
        // Use a `where` clause to delete a specific product.
        where: 'id = ?',
        // Pass the product's id as a whereArg to prevent SQL injection.
        whereArgs: [id],
      );
    }
  }

  void toggleIconState(Product product,BuildContext context,String dbname) {
    setState(() {
      product.isClicked1 = !product.isClicked1;

    });

    if(product.isClicked1 == true && mail != null){
      ScaffoldMessenger.of(context)
          .showSnackBar(
          SnackBar(
              content: FutureBuilder(
                future:insertProd(
                    product,
                    dbname),
                builder: (context,
                    AsyncSnapshot<
                        String> snapshot) {
                  if (snapshot
                      .hasError)
                    return Text(
                        'Error: ${snapshot
                            .error}');
                  if (snapshot
                      .hasData)
                    return Text(
                        '${snapshot
                            .data}');
                  return const CircularProgressIndicator();
                },
              ))
      );
    }
    else if(product.isClicked1 == false && mail != null){
      ScaffoldMessenger.of(context)
          .showSnackBar(
          SnackBar(
              content: FutureBuilder(
                future:deleteProd(
                    product.id,
                    dbname1),
                builder: (context,
                    AsyncSnapshot<void> snapshot) {
                  if (snapshot
                      .hasError)
                    return Text(
                        'Error: ${snapshot
                            .error}');
                  return Text(
                      'Deleted Successfully');
                  return const CircularProgressIndicator();
                },
              ))
      );
    }
    else{
      ScaffoldMessenger.of(context)
          .showSnackBar(
          SnackBar(
              content: Text("Must connected first"))
      );
    }
  }
  void toggleIconState2(Product product,BuildContext context,String dbname) {
    setState(() {
      product.isClicked2 = !product.isClicked2;

    });

    if(product.isClicked2 == true && mail != null){
      ScaffoldMessenger.of(context)
          .showSnackBar(
          SnackBar(
              content: FutureBuilder(
                future: insertProd(
                    product,
                    dbname),
                builder: (context,
                    AsyncSnapshot<
                        String> snapshot) {
                  if (snapshot
                      .hasError)
                    return Text(
                        'Error: ${snapshot
                            .error}');
                  if (snapshot
                      .hasData)
                    return Text(
                        '${snapshot
                            .data}');
                  return const CircularProgressIndicator();
                },
              ))
      );
    }
    else if(product.isClicked2 == false && mail != null){
      ScaffoldMessenger.of(context)
          .showSnackBar(
          SnackBar(
              content: FutureBuilder(
                future: deleteProd(
                    product.id,
                    dbname2),
                builder: (context,
                    AsyncSnapshot<void> snapshot) {
                  if (snapshot
                      .hasError)
                    return Text(
                        'Error: ${snapshot
                            .error}');
                  return Text(
                      'Deleted Successfully');
                  return const CircularProgressIndicator();
                },
              ))
      );
    }
    else{
      ScaffoldMessenger.of(context)
          .showSnackBar(
          SnackBar(
              content: Text("Must connected first"))
      );
    }
  }

  @override
  Widget build(BuildContext context){
    List<Product> theList=[];
    for(Product prod in myList){
      if(prod.category == idCategory){
        theList.add(prod);
      }
    }
    return  Scaffold(
      appBar: AppBar(
        title: Text('Product of $idCategory'),
      ),
      body: Container(
        height: 800.0,
        child:GridView.count(
          crossAxisCount: 2,
          children:
          theList.map(
                (product) =>
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [

                      Expanded(
                        child: Image.network(
                          product.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                      InkWell(
                        child:
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '\$${product.price}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children:  <Widget>[
                                  IconButton(
                                    icon:product.isClicked1 ? Icon(
                                      Icons.shopping_cart,
                                      color: Colors.lightGreen,
                                      size: 24.0,
                                      // semanticLabel: 'Text to announce in accessibility modes',
                                    ):Icon(
                                      Icons.add_shopping_cart,
                                      color: Colors.lightGreen,
                                      size: 24.0,
                                      // semanticLabel: 'Text to announce in accessibility modes',
                                    ) ,
                                    onPressed: () {
                                      return toggleIconState(product, context,dbname1);
                                    },
                                  ),
                                  IconButton(
                                    icon: product.isClicked2 ? Icon(
                                      Icons.favorite,
                                      color: Colors.pinkAccent,
                                      size: 30.0,
                                      // semanticLabel: 'Text to announce in accessibility modes',
                                    ): Icon(
                                      Icons.favorite_border,
                                      color: Colors.pinkAccent,
                                      size: 30.0,
                                      // semanticLabel: 'Text to announce in accessibility modes',
                                    ),
                                    onPressed: () {
                                      return toggleIconState2(product, context, dbname2);
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder:(_){return infoProducts(produ: product);}
                          )
                          );
                        },
                      )
                    ],
                  ),
                ),
          )
              .toList(),
        ),
      ),
    );
  }
}
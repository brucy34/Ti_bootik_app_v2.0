import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:ti_bootik_app_vtwo/login.dart';
import 'package:ti_bootik_app_vtwo/models/category.dart';
import 'package:ti_bootik_app_vtwo/models/product.dart';
import 'package:ti_bootik_app_vtwo/models/user.dart';
import 'package:ti_bootik_app_vtwo/screens/payment.dart';
import 'package:ti_bootik_app_vtwo/screens/allproducts.dart';
import 'package:ti_bootik_app_vtwo/screens/allCategories.dart';
import 'package:ti_bootik_app_vtwo/screens/infoProducts.dart';
import 'package:ti_bootik_app_vtwo/screens/productsByCategory.dart';

void main() {
  runApp(HomePage());
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ti bootik aw',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage1(),
    );
  }
}
class HomePage1 extends StatefulWidget {
  final String? mail;
  const HomePage1({Key? key,this.mail}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState(mail: mail);
}

class _HomePageState extends State<HomePage1> {
  String? mail;

  _HomePageState({this.mail});

  int _currentIndex = 1;
  String dbname1 = 'products.db';
  String dbname2 = 'favorites_products.db';

  late Widget selectWidget;
  List<Category> _categories = [];
  List<Product> _products = [];
  List<User> _users = [];

  Future<void> _fetchData() async {
    final response = await http.get(
        Uri.parse('https://api.escuelajs.co/api/v1/categories'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _categories = data.map((e) => Category.fromJson(e)).toList();
      });
    } else {
      throw Exception('Failed to fetch categories');
    }

    final response2 = await http.get(
        Uri.parse('https://api.escuelajs.co/api/v1/products'));

    if (response2.statusCode == 200) {
      final List<dynamic> data = json.decode(response2.body);
      setState(() {
        _products = data.map((e) => Product.fromJson(e)).toList();
      });
    } else {
      throw Exception('Failed to fetch products');
    }

    final response3 = await http.get(
        Uri.parse('https://api.escuelajs.co/api/v1/users'));

    if (response2.statusCode == 200) {
      final List<dynamic> data = json.decode(response3.body);
      setState(() {
        _users = data.map((e) => User.fromJson(e)).toList();
      });
    } else {
      throw Exception('Failed to fetch users');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
    prodList(dbname1);
    prodList(dbname2);
  }

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

  List<Product>? prod = [];
  List<Product>? prod1 = [];


  User myUser(String? mail) {
    User myUser = User(id: 0,
        name: 'Nobody is sign in',
        email: 'email',
        password: 'password',
        role: 'role',
        avatar: 'https://placeimg.com/640/480/any?r=0.9300320592588625');
    if (mail != null) {
      for (User user in _users) {
        if (mail ==
            user.email) {
          return user;
        }
      }
    }
      return myUser;
}


  @override
  Widget build(BuildContext context) {
    User myUser1=myUser(mail);

    prodList(dbname1).then((value) => prod=value);
    prodList(dbname2).then((value) => prod1=value);
    final List <Widget> _widget=[data1(response: prod,mail: mail,dbname: dbname1,),data2(cate: _categories, prod: _products,mail: mail,dbname1: dbname1,dbname2: dbname2),data3(response:prod1,mail: mail,dbname: dbname1,)];
    return Scaffold(
      drawer: Drawer(
        child: ListView(
            children:[
              DrawerHeader(child: Image.network(myUser1.avatar,fit: BoxFit.fill,),
                decoration: BoxDecoration(color: Colors.greenAccent),),
              ListTile(title:Text(myUser1.name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30))),
              SizedBox(height: 30.0,),
              ListTile(title:Text("All categories"),onTap:(){Navigator.push(context, MaterialPageRoute(builder:(_){return allCategories(myList: _categories,mylist: _products,dbname1: dbname1,dbname2: dbname2,);}
              )
              );} ,),
              ListTile(title:Text("All products"),onTap:(){Navigator.push(context, MaterialPageRoute(builder:(_){return allProducts(myList: _products,dbname1: dbname1,dbname2: dbname2,);}
              )
              );} ,),
              ListTile(title:Text("Pay"),onTap:(){
                Navigator.push(context, MaterialPageRoute(builder:(_){return payment();}
                )
                );
              } ,),
              ListTile(title:Text("Log in"),onTap:(){
                Navigator.push(context, MaterialPageRoute(builder:(_){return LoginPage();}));
              } ,),
              ListTile(title:Text("Log out"),onTap:(){
                mail=null;
                Navigator.push(context, MaterialPageRoute(builder:(_){return HomePage1();}));
              } ,),
            ]
        ),
      ),
      appBar: AppBar(
        title: Text('Ti bootik aw'),
      ),
      body: selectWidget=_widget[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (value){
          setState(() {
            _currentIndex=value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Panier',

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Acceuil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoris',
          ),
        ],
      ),
    );
  }
}


class data1 extends StatelessWidget{
  List<Product>? response;
  String? mail;
  String dbname;
  data1({super.key,this.response,this.mail,required this.dbname});

  @override
  Widget build(BuildContext context) {
    if (response != null && mail != null) {
      if(response!.isEmpty)
        return Center(
          child: Text("No products to display now"),
        );
      else
      return GridView.count(
        crossAxisCount: 2,
        children: response!.map(
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
                            children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.pink,
                                  size: 24.0,
                                  // semanticLabel: 'Text to announce in accessibility modes',
                                ),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: FutureBuilder(
                                        future: _HomePageState(mail: mail)
                                            .deleteProd(product.id,dbname),
                                        builder: (context,
                                            AsyncSnapshot<void> snapshot) {
                                          if (snapshot.hasError) return Text(
                                              'Error: ${snapshot.error}');
                                          if (snapshot.hasData)
                                            return Text('Deleted correctly');
                                          return const CircularProgressIndicator();
                                        },
                                      ))
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.payment,
                                  color: Colors.greenAccent,
                                  size: 30.0,
                                  // semanticLabel: 'Text to announce in accessibility modes',
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context, MaterialPageRoute(builder: (_) {
                                    return payment();
                                  }
                                  )
                                  );
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
        )
            .toList(),
      );
    }
    else{
      return Center(
        child: Text("Nothing to display"),
      );
    }

}
}

class data2 extends StatefulWidget {
  List<Category>? cate=[];
  List<Product>? prod=[];
  String? mail;
  String dbname1;
  String dbname2;
  data2({this.cate,this.prod,this.mail,required this.dbname1,required this.dbname2});
  @override
  dataPage createState() => dataPage(cate: cate,prod: prod,mail: mail,dbname1:dbname1,dbname2: dbname2);
}
class dataPage extends State<data2> {
  List<Category>? cate = [];
  List<Product>? prod = [];
  String? mail;
  String dbname1;
  String dbname2;

  dataPage({this.cate, this.prod, this.mail, required this.dbname1,required this.dbname2});

  void toggleIconState(Product product,BuildContext context,String dbname) {
    setState(() {
        product.isClicked1 = !product.isClicked1;

    });

    if(product.isClicked1 == true && mail != null){
       ScaffoldMessenger.of(context)
           .showSnackBar(
           SnackBar(
               content: FutureBuilder(
                 future: _HomePageState(
                     mail: mail)
                     .insertProd(
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
                future: _HomePageState(
                    mail: mail)
                    .deleteProd(
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
                future: _HomePageState(
                    mail: mail)
                    .insertProd(
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
                future: _HomePageState(
                    mail: mail)
                    .deleteProd(
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
  Widget build(BuildContext context) {
    if (prod != null && cate != null) {
      return ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Top 4 Categories", style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 30),),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: cate!.take(4).map((category) {
                      return InkWell(
                        child:
                        Card(
                          child:
                          Column(

                              children: [
                                Container(
                                  width: 500,
                                  height: 150.0,
                                  child: Image.network(
                                      category.image,
                                      fit: BoxFit.cover),
                                ),
                                Text(category.name)
                              ]
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (
                              _) {
                            return productsByCategory(
                              myList: prod!, idCategory: category.name,dbname1: dbname1,dbname2: dbname2,);
                          }
                          )
                          );
                        },

                      );
                    },
                    ).toList(),

                  ),
                  SizedBox(height: 30,),
                  Text("Top 6 Produits", style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 30),),
                  Container(
                    height: 800.0,
                    child:
                    GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      children:
                      prod!.take(6)
                          .map(
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
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
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
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceAround,
                                            children: <Widget>[
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
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (_) {
                                            return infoProducts(produ: product);
                                          }
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

                  )
                ]
            )
          ]
      );
    }
    else{
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}


class data3 extends StatelessWidget{
  List<Product>? response;
  String? mail;
  String dbname;
  data3({super.key,this.response, this.mail,required this.dbname});

  @override
  Widget build(BuildContext context) {
    if(response != null && mail != null) {
      if(response!.isEmpty)
        return Center(
          child: Text("No products to display now"),
        );
      else
      return GridView.count(
        crossAxisCount: 2,
        children: response!.map(
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
                            children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.pink,
                                  size: 24.0,
                                  // semanticLabel: 'Text to announce in accessibility modes',
                                ),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: FutureBuilder(
                                        future: _HomePageState(mail: mail)
                                            .deleteProd(product.id,dbname),
                                        builder: (context,
                                            AsyncSnapshot<void> snapshot) {
                                          if (snapshot.hasError) return Text(
                                              'Error: ${snapshot.error}');
                                          if (snapshot.hasData)
                                            return Text('Deleted correctly');
                                          return const CircularProgressIndicator();
                                        },
                                      ))
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.add_shopping_cart_outlined,
                                  color: Colors.greenAccent,
                                  size: 30.0,
                                  // semanticLabel: 'Text to announce in accessibility modes',
                                ),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: FutureBuilder(
                                        future: _HomePageState(mail: mail)
                                            .insertProd(product, dbname),
                                        builder: (context,
                                            AsyncSnapshot<String> snapshot) {
                                          if (snapshot.hasError) return Text(
                                              'Error: ${snapshot.error}');
                                          if (snapshot.hasData)
                                            return Text('${snapshot.data}');
                                          return const CircularProgressIndicator();
                                        },
                                      ))
                                  );
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
        )
            .toList(),
      );
    }else{
      return Center(
        child: Text("Nothing to display"),
      );
    }
  }
}
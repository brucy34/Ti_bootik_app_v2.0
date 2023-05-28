import 'package:flutter/material.dart';
import 'package:ti_bootik_app_vtwo/screens/productsByCategory.dart';
import 'package:ti_bootik_app_vtwo/models/category.dart';
import 'package:ti_bootik_app_vtwo/models/product.dart';


class allCategories extends StatelessWidget{
  List<Category> myList;
  List<Product> mylist;
  String dbname1;
  String dbname2;
  allCategories({super.key,required this.myList,required this.mylist,required this.dbname1,required this.dbname2});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("All categories"),
      ),
      body:GridView.count(
        crossAxisCount: 1,
        children: myList.map((category){
          return InkWell(
            child:
            Card(
              child:
              Column(
                  children:[
                    Container(
                      width: 500,
                      height: 150.0,
                      child:Image.network(
                          category.image,
                          fit: BoxFit.cover),
                    ),
                    Text(category.name)
                  ]
              ),
            ),
            onTap:(){
              Navigator.push(context, MaterialPageRoute(builder:(_){return productsByCategory(myList: mylist,idCategory: category.name,dbname1: dbname1,dbname2: dbname2,);}
              )
              );
            },

          );

        },
        ).toList(),
      ),
    );
  }
}
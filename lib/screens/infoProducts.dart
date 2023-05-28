import 'package:flutter/material.dart';
import 'package:ti_bootik_app_vtwo/models/product.dart';

class infoProducts extends StatelessWidget{
  Product produ;
  infoProducts({super.key,required this.produ});

  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
          title:Text('Information sur ${produ.name}')
      ),
      body: Center(
        child: Text('\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t${produ.name}\n\n${produ.description}\n\n\t\t\$${produ.price}'),
      ),
    );
  }
}
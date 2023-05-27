import 'package:flutter/material.dart';

class payment extends StatelessWidget{
  payment({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: Text("Payment"),
        ),
        body: Center(
          child: Center(child:Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: (){},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Icons.payment_rounded),
                    Text('Moncash')
                  ],
                ),
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red[800])),
              ),
              ElevatedButton(onPressed: (){},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Icons.payment_rounded),
                    Text('Natcash')
                  ],
                ),
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.orange[800])),
              ),
              ElevatedButton(onPressed: (){},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Icons.paypal),
                    Text('Paypal')
                  ],
                ),
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue[800])),
              ),
              ElevatedButton(onPressed: (){},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Icons.payment_rounded),
                    Text('Visa')
                  ],
                ),
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black38)),
              ),
              ElevatedButton(onPressed: (){},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Icons.payment_rounded),
                    Text('MasterCard')
                  ],
                ),
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blueGrey)),
              ),
            ],
          ),
        )
    )
    );
  }
}

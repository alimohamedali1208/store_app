import 'package:flutter/material.dart';

import '../ProductDetails.dart';

//dd
class Product extends StatefulWidget {
  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  var product_list = [
    {
      "name": "iphone 12",
      "picture": "images/iphone12.jpg",
      "old_price": 24000,
      "price": 20000
    },
    {
      "name": "Air Conditionier",
      "picture": "images/airconditionier.jpg",
      "old_price": 4000,
      "price": 3000
    },
    {
      "name": "Scanner",
      "picture": "images/scanner.jpg",
      "old_price": 2500,
      "price": 1500
    },
    {
      "name": "Dimond Ring",
      "picture": "images/dimond.jpg",
      "old_price": 50000,
      "price": 49000
    },
    {
      "name": "Shoes",
      "picture": "images/shoes.jpg",
      "old_price": 700,
      "price": 500
    },
    {
      "name": "Reciever",
      "picture": "images/reciever.jpg",
      "old_price": 300,
      "price": 250
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: product_list.length,
        gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return Single_product(
            prod_name: product_list[index]['name'],
            prod_picture: product_list[index]['picture'],
            prod_old_price: product_list[index]['old_price'],
            prod_price: product_list[index]['price'],
          );
        });
  }
}

class Single_product extends StatelessWidget {
  final prod_name;
  final prod_picture;
  final prod_old_price;
  final prod_price;

  const Single_product(
      {this.prod_name,
      this.prod_picture,
      this.prod_old_price,
      this.prod_price});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Hero(
        tag: prod_name,
        child: Material(
            child: InkWell(
          onTap: () {
            return Navigator.of(context).push(
              new MaterialPageRoute(
                builder: (context) => new ProductDetails(
                  // passing the values via constructor
                  product_detail_name: prod_name,
                  product_detail_new_price: prod_price,
                  product_detail_old_price: prod_old_price,
                  product_detail_picture: prod_picture,
                ),
              ),
            );
          },
          child: GridTile(
            footer: Container(
              color: Colors.white70,
              child: ListTile(
                leading: Text(
                  prod_name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                title: Text(
                  "\$$prod_price",
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.w800),
                ),
                subtitle: Text(
                  "\$$prod_old_price",
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w800,
                      decoration: TextDecoration.lineThrough),
                ),
              ),
            ),
            child: Image.asset(
              prod_picture,
              fit: BoxFit.cover,
            ),
          ),
        )),
      ),
    );
  }
}

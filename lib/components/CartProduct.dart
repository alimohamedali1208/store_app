import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CartProduct extends StatefulWidget {
  @override
  _CartProductState createState() => _CartProductState();
}

class _CartProductState extends State<CartProduct> {
  var products_on_cart = [
    {
      "name": "iphone 12",
      "picture": "images/iphone12.jpg",
      "price": 20000,
      "color": "Blue",
      "qty": 2
    },
    {
      "name": "Air Conditionier",
      "picture": "images/airconditionier.jpg",
      "price": 3000,
      "color": "White",
      "qty": 1
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: products_on_cart.length,
        itemBuilder: (context, index) {
          return SingleCartProduct(
            cart_prod_name: products_on_cart[index]["name"],
            cart_prod_picture: products_on_cart[index]["picture"],
            cart_prod_price: products_on_cart[index]["price"],
            cart_prod_color: products_on_cart[index]["color"],
            cart_prod_qty: products_on_cart[index]["qty"],
          );
        });
  }
}

class SingleCartProduct extends StatelessWidget {
  final cart_prod_name;
  final cart_prod_picture;
  final cart_prod_price;
  final cart_prod_color;
  final cart_prod_qty;

  const SingleCartProduct(
      {this.cart_prod_name,
      this.cart_prod_picture,
      this.cart_prod_price,
      this.cart_prod_color,
      this.cart_prod_qty});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        //    ======= the leading image section =======
        leading: Image.asset(
          cart_prod_picture,
          width: 80,
          height: 80,
        ),
        title: Text(cart_prod_name),
        subtitle: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                //    ======== this for color section =========
                Text("Color:"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    cart_prod_color,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                //    ========== this for Qty section =========
                Text("Quantity:"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "$cart_prod_qty",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
            //  ======= this for price section ======
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                "\$${cart_prod_price}",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
        //==============================
        //   trailing: Container(
        //     child: Column(
        //       children: <Widget>[
        //         IconButton(
        //           icon: Icon(
        //             Icons.arrow_drop_up,
        //           ),
        //           onPressed: () {},
        //         ),
        //         Text("$cart_prod_qty"),
        //         IconButton(
        //           icon: Icon(
        //             Icons.arrow_drop_down,
        //           ),
        //           onPressed: () {},
        //         )
        //       ],
        //     ),
        //   ),
        //   //============================
      ),
    );
  }
}

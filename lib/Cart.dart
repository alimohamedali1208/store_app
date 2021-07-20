import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:store_app/AddressCheckout.dart';
import 'package:store_app/Checkout.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  bool hasProducts = false;

  void navigateToCheckout() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddressCheckout()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(62),
        child: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          backgroundColor: Color(0xFF731800),
          elevation: 0.0,
          title: Text("Shopping Cart"),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                SizedBox(height: 10),
                Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Customers')
                      .doc(_auth.currentUser.uid)
                      .collection('cart')
                      .orderBy('ChangeFlag')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      print("no homo ");
                      return Text('no products available');
                    } else {
                      final products = snapshot.data.docs;
                      List<SingleCartProduct> productsview = [];
                      for (var product in products) {
                        final productname = product.data()['Product Name'];
                        final productprice = product.data()['Price'] as num;
                        final productdiscount = product.data()['Discount'];
                        final productdiscountpercent =
                            product.data()['Discount percent'];
                        final productnewprice = product.data()['New price'];
                        final productimg = product.data()['imgURL'];
                        final producttype = product.data()['type'];
                        final changeflag = product.data()['ChangeFlag'];
                        final productid = product.id;
                        print("$productname $productprice");
                        final productview = SingleCartProduct(
                          cart_prod_name: productname,
                          cart_prod_price: productprice,
                          cart_prod_newPrice: productnewprice,
                          cart_prod_discount: productdiscount,
                          cart_prod_discountPercent: productdiscountpercent,
                          cart_prod_picture: productimg,
                          cart_prod_type: producttype,
                          cart_prod_id: productid,
                          cart_prod_changeFlag: changeflag,
                        );
                        productsview.add(productview);
                      }
                      return ListView(
                        children: productsview,
                      );
                    }
                  },
                )),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Expanded(
                child: ListTile(
              title: Text("Total Amount"),
              subtitle: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Customers')
                      .doc(_auth.currentUser.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text('');
                    } else {
                      final totalPrice = snapshot.data.data()['Total'];
                      if (totalPrice == 0) {
                        hasProducts = false;
                      } else {
                        hasProducts = true;
                      }
                      return Text('$totalPrice EGP');
                    }
                  }),
            )),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialButton(
                onPressed: () {
                  if (hasProducts) {
                    navigateToCheckout();
                  } else {
                    Fluttertoast.showToast(msg: "Your cart is empty");
                  }
                },
                child: Text(
                  "Check Out",
                  style: TextStyle(color: Colors.white),
                ),
                color: Color(0xFF731800),
              ),
            ))
          ],
        ),
      ),
    );
  }
}

class SingleCartProduct extends StatelessWidget {
  final cart_prod_name;
  final cart_prod_picture;
  final cart_prod_price;
  final cart_prod_newPrice;
  final cart_prod_discount;
  final cart_prod_discountPercent;
  final cart_prod_type;
  final cart_prod_id;
  final cart_prod_changeFlag;

  const SingleCartProduct(
      {this.cart_prod_name,
      this.cart_prod_picture,
      this.cart_prod_price,
      this.cart_prod_newPrice,
      this.cart_prod_discount,
      this.cart_prod_discountPercent,
      this.cart_prod_type,
      this.cart_prod_changeFlag,
      this.cart_prod_id});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: (cart_prod_changeFlag == 'false')
          ? ListTile(
              //    ======= the leading image section =======
              leading: FadeInImage.assetNetwork(
                placeholder: 'images/PlaceHolder.gif',
                image: (cart_prod_picture == null)
                    ? "https://firebasestorage.googleapis.com/v0/b/store-cc25c.appspot.com/o/uploads%2FPlaceHolder.gif?alt=media&token=89558fba-e8b6-4b99-bcb7-67bf1412a83a"
                    : cart_prod_picture,
                height: 80,
                width: 80,
              ),
              title: Row(
                children: [
                  Flexible(flex: 15, child: Text(cart_prod_name)),
                  Spacer(),
                  Flexible(
                    flex: 2,
                    child: IconButton(
                      icon: Icon(Icons.highlight_remove),
                      color: Colors.red[300],
                      onPressed: () async {
                        double oldPrice;
                        if (cart_prod_discount == 'false')
                          oldPrice = cart_prod_price;
                        else
                          oldPrice = double.parse(cart_prod_newPrice);
                        await FirebaseFirestore.instance
                            .collection('Customers')
                            .doc(FirebaseAuth.instance.currentUser.uid)
                            .collection('cart')
                            .doc(cart_prod_id)
                            .delete();
                        await FirebaseFirestore.instance
                            .collection('Customers')
                            .doc(FirebaseAuth.instance.currentUser.uid)
                            .update({'Total': FieldValue.increment(-oldPrice)});
                      },
                    ),
                  ),
                ],
              ),
              subtitle: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        'Shipping: Free',
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Type: ${cart_prod_type}"),
                      ),
                    ],
                  ),
                  //  ======= this for price section ======
                  Container(
                    alignment: Alignment.topLeft,
                    child: (cart_prod_discount == 'false')
                        ? Text(
                            "${cart_prod_price} EGP",
                            style: TextStyle(color: Colors.red),
                          )
                        : Row(
                            children: [
                              Text(
                                "${cart_prod_price} EGP",
                                style: TextStyle(
                                    decoration: TextDecoration.lineThrough),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "${cart_prod_newPrice} EGP",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              )
                            ],
                          ),
                  ),
                ],
              ),
            )
          : Container(
              color: Colors.red[400],
              child: ListTile(
                title: Row(
                  children: [
                    Expanded(
                        child: Text(
                            "The Product named: '$cart_prod_name' has been removed or edited, try adding it again")),
                    IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('Customers')
                              .doc(FirebaseAuth.instance.currentUser.uid)
                              .collection('cart')
                              .doc(cart_prod_id)
                              .delete();
                        })
                  ],
                ),
              ),
            ),
    );
  }
}

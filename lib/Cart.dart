import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  final _auth = FirebaseAuth.instance;
  int checkoutSum =0;
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
          actions: <Widget>[
            new IconButton(
                icon: Icon(Icons.search, color: Colors.white), onPressed: () {}),
          ],
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
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return Text('no products available');
                        else {
                          final products = snapshot.data.docs;
                          List<SingleCartProduct> productsview = [];
                          for (var product in products) {

                              final productname = product.data()['Product Name'];
                              final productprice = product.data()['Price'];
                              final productimg = product.data()['imgURL'];
                              final producttype = product.data()['type'];
                              final productid = product.id;
                              checkoutSum += productprice;
                              final productview = SingleCartProduct(
                                cart_prod_name: productname,
                                cart_prod_price: productprice,
                                cart_prod_picture: productimg,
                                cart_prod_type: producttype,
                                cart_prod_id: productid,
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
      bottomNavigationBar: new Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Expanded(
                child: ListTile(
              title: Text("Total Amount"),
              subtitle: Text("$checkoutSum EGP"),
            )),
            Expanded(
                child: new MaterialButton(
              onPressed: () {},
              child: Text(
                "Check Out",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.grey,
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
  final cart_prod_type;
  final cart_prod_id;


  const SingleCartProduct(
      {this.cart_prod_name,
        this.cart_prod_picture,
        this.cart_prod_price,
        this.cart_prod_type,
        this.cart_prod_id});


  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        //    ======= the leading image section =======
        leading: FadeInImage.assetNetwork(
          placeholder: 'images/PlaceHolder.gif',
          image: (cart_prod_picture == null)
              ? "https://firebasestorage.googleapis.com/v0/b/store-cc25c.appspot.com/o/uploads%2FPlaceHolder.gif?alt=media&token=89558fba-e8b6-4b99-bcb7-67bf1412a83a"
              : cart_prod_picture,
          height: 80,
          width: 80,
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
                    'Shipping: Free',
                  ),
                ),
                //    ========== this for Qty section =========
                Text("Type:"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "$cart_prod_type",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
            //  ======= this for price section ======
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                "${cart_prod_price} EGP",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

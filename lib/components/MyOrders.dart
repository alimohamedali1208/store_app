import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class myOrders extends StatefulWidget {
  @override
  _myOrdersState createState() => _myOrdersState();
}

class _myOrdersState extends State<myOrders> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

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
          title: Text("My Orders"),
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
                          .collection('orders')
                          .orderBy('CreatedAt', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          print("no homo ");
                          return Center(child: CircularProgressIndicator());
                        }
                        else {
                          final products = snapshot.data.docs;
                          List<SingleCartProduct> productsview = [];
                          for (var product in products) {
                            final productname = product.data()['Product Name'];
                            final productprice = product.data()['Price'] as num;
                            final productdiscount = product.data()['Discount'];
                            final productnewprice = product.data()['New price'];
                            final productimg = product.data()['imgURL'];
                            final productquantity = product.data()['Quantity'];
                            final productDate = product.data()['CreatedAt'];
                            final productid = product.id;
                            print("$productname $productprice");
                            final productview = SingleCartProduct(
                              prod_name: productname,
                              prod_price: productprice,
                              prod_newPrice: productnewprice,
                              prod_discount: productdiscount,
                              prod_picture: productimg,
                              prod_date: productDate,
                              prod_id: productid,
                              prod_quantity: productquantity,
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
    );
  }
}

class SingleCartProduct extends StatelessWidget {
  final prod_name;
  final prod_picture;
  final prod_price;
  final prod_newPrice;
  final prod_discount;
  final prod_date;
  final prod_quantity;
  final prod_id;

  const SingleCartProduct(
      {this.prod_name,
        this.prod_picture,
        this.prod_price,
        this.prod_newPrice,
        this.prod_discount,
        this.prod_date,
        this.prod_quantity,
        this.prod_id});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        //    ======= the leading image section =======
        leading: FadeInImage.assetNetwork(
          placeholder: 'images/PlaceHolder.gif',
          image: (prod_picture == null)
              ? "https://firebasestorage.googleapis.com/v0/b/store-cc25c.appspot.com/o/uploads%2FPlaceHolder.gif?alt=media&token=89558fba-e8b6-4b99-bcb7-67bf1412a83a"
              : prod_picture,
          height: 80,
          width: 80,
        ),
        title: Text(prod_name),
        subtitle: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  'Date: $prod_date',
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Quantity: ${prod_quantity}"),
                ),
              ],
            ),
            //  ======= this for price section ======
            Container(
              alignment: Alignment.topLeft,
              child: (prod_discount == 'false')
                  ? Text(
                "${prod_price} EGP",
                style: TextStyle(color: Colors.red),
              )
                  : Row(
                children: [
                  Text(
                    "${prod_price} EGP",
                    style: TextStyle(
                        decoration: TextDecoration.lineThrough),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "${prod_newPrice} EGP",
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
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../ProductDetails.dart';
import '../productClass.dart';

/*

* */
class RecenProductsView extends StatelessWidget {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180.0,
      child: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collectionGroup('Products')
            .orderBy('CreatedAt', descending: true)
            .limit(7)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Text('no products available');
          else {
            final products = snapshot.data.docs;
            var productview;
            List<SingleProduct> productsview = [];
            for (var product in products) {
              ProductClass productInfo = ProductClass();
              productInfo.name = product.data()['Product Name'];
              productInfo.brand = product.data()['Brand Name'];
              productInfo.sellerEmail = product.data()['Seller Email'];
              productInfo.description = product.data()['Description'];
              productInfo.price = (product.data()['Price']).toDouble();
              productInfo.discount = product.data()['Discount'];
              productInfo.discountPercentage =
                  product.data()['Discount percent'];
              productInfo.newPrice = product.data()['New price'];
              productInfo.img = product.data()['imgURL'];
              productInfo.type = product.data()['type'];
              productInfo.rate = product.data()['Rating'];
              productInfo.rate1star = product.data()['1 star rate'];
              productInfo.rate2star = product.data()['2 star rate'];
              productInfo.rate3star = product.data()['3 star rate'];
              productInfo.rate4star = product.data()['4 star rate'];
              productInfo.rate5star = product.data()['5 star rate'];
              productInfo.quantity = product.data()['Quantity'];
              productInfo.id = product.id;
              if (productInfo.type == 'Mobiles') {
                productInfo.storage = product.data()['Storage'];
                productInfo.battery = product.data()['Battery'];
                productInfo.memory = product.data()['Memory'];
                productInfo.camera = product.data()['Camera'];
                productInfo.os = product.data()['OS'];
                productInfo.screenSize = product.data()['Screen Size'];
                productInfo.storageUnit = product.data()['Storage Unit'];
              } else if (productInfo.type == 'Laptops') {
                productInfo.storage = product.data()['Storage'];
                productInfo.battery = product.data()['Battery'];
                productInfo.memory = product.data()['Memory'];
                productInfo.os = product.data()['OS'];
                productInfo.screenSize = product.data()['ScreenSize'];
                productInfo.cpu = product.data()['CPU'];
                productInfo.gpu = product.data()['GPU'];
              }
              productview = SingleProduct(
                prd: productInfo,
              );
              productsview.add(productview);
            }
            return ListView(
              scrollDirection: Axis.horizontal,
              children: productsview,
            );
          }
        },
      ),
    );
  }
}

class SingleProduct extends StatefulWidget {
  ProductClass prd;

  SingleProduct({this.prd});

  @override
  _SingleProductState createState() => _SingleProductState();
}

class _SingleProductState extends State<SingleProduct> {
  //final _auth = FirebaseAuth.instance;
  //final _firestore = FirebaseFirestore.instance;
  bool isPressed = false;
  bool cartIsPressed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              new MaterialPageRoute(
                builder: (context) => ProductDetails(
                  // passing the values via constructor
                  prd: widget.prd,
                ),
              ),
            );
          },
          child: Column(
            children: [
              FadeInImage.assetNetwork(
                placeholder: 'images/PlaceHolder.gif',
                image: (widget.prd.img == null)
                    ? "https://firebasestorage.googleapis.com/v0/b/store-cc25c.appspot.com/o/uploads%2FPlaceHolder.gif?alt=media&token=89558fba-e8b6-4b99-bcb7-67bf1412a83a"
                    : widget.prd.img,
                height: 100,
                width: 100,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.prd.name),
              ),
              Container(
                alignment: Alignment.topLeft,
                child: (widget.prd.discount == 'false')
                    ? Text(
                        "${widget.prd.price} EGP",
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${widget.prd.price}",
                            style: TextStyle(
                                decoration: TextDecoration.lineThrough),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "${widget.prd.newPrice} EGP",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
              ),
            ],
          )),
    );
  }
}

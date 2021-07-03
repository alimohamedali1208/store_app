import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:store_app/UserCustomer.dart';
import 'package:store_app/productClass.dart';

UserCustomer customer = UserCustomer();

class ProductDetails extends StatefulWidget {
  ProductClass pRD;

  ProductDetails(
      {this.pRD});


  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  bool isPressed = false;
  //int rate;

  Future addToCart() async {
    setState(() {
      showSpinner = true;
    });
    if (customer.firstName == "temp") {
      Fluttertoast.showToast(msg: "You need to sign in first");
    } else {
      print('first check if product already in cart');
      await _firestore
          .collection('Customers')
          .doc(_auth.currentUser.uid)
          .collection('cart')
          .doc(widget.pRD.id)
          .get()
          .then((DocumentSnapshot snapshot) async {
        if (snapshot.exists) {
          print('product already in cart');
          Fluttertoast.showToast(msg: "Product already in cart");
        } else {
          print('insert product id in cart');
          await _firestore
              .collection('Customers')
              .doc(_auth.currentUser.uid)
              .collection('cart')
              .doc(widget.pRD.id)
              .set({
            'ProductID': widget.pRD.id,
            'CustomerID': _auth.currentUser.uid,
            'Product Quantity': 1,
            'Product Name': widget.pRD.name,
            'Price': widget.pRD.price,
            'New price': widget.pRD.newPrice,
            'Discount': widget.pRD.discount,
            'Discount percent': widget.pRD.discountPercentage,
            'type': widget.pRD.type,
            'imgURL': widget.pRD.img,
          });
          double price;
          if (widget.pRD.discount == 'false')
            price = widget.pRD.price;
          else
            price = double.parse(widget.pRD.newPrice);
          await _firestore
              .collection('Customers')
              .doc(_auth.currentUser.uid)
              .update({'Total': FieldValue.increment(price)});
          print('Product added to cart');
        }
      });
    }
    setState(() {
      showSpinner = false;
    });
  }

  Future updateProductRating(int rating) async {
    //int rate1star, rate2star, rate3star, rate4star, rate5star;
    int oldRating;
    int ratingMul;
    int overallRating;
    double avgRating;
    if (customer.firstName == 'temp') {
      print('user not signed in!');
      //BASEL WAS HERE
      Fluttertoast.showToast(msg: "You need to sign in first!");
    } else {
      print('User is signed in!');
      print('step1 get old rating');
      await _firestore
          .collection('Customers')
          .doc(_auth.currentUser.uid)
          .collection('rated products')
          .doc(widget.pRD.id)
          .get()
          .then((DocumentSnapshot snapshot) async {
        if (snapshot.exists) {
          print('step2 document exists then get old rating');
          await _firestore
              .collection('Customers')
              .doc(_auth.currentUser.uid)
              .collection('rated products')
              .doc(widget.pRD.id)
              .get()
              .then((value) {
            oldRating = value.data()['rating'];
            print('This is old rating $oldRating');
          });
          print('step2 change how many stars');
          await _firestore
              .collection('ProductsCollection')
              .doc('${widget.pRD.type}')
              .collection('Products')
              .doc(widget.pRD.id)
              .update({
            '$oldRating star rate': FieldValue.increment(-1),
            '$rating star rate': FieldValue.increment(1)
          });
          if (oldRating == 1) {
            widget.pRD.rate1star--;
          } else if (oldRating == 2) {
            widget.pRD.rate2star--;
          } else if (oldRating == 3) {
            widget.pRD.rate3star--;
          } else if (oldRating == 4) {
            widget.pRD.rate4star--;
          } else {
            widget.pRD.rate5star--;
          }
        } else {
          print('step2 document not found just change no. of stars');
          await _firestore
              .collection('ProductsCollection')
              .doc('${widget.pRD.type}')
              .collection('Products')
              .doc(widget.pRD.id)
              .update({'$rating star rate': FieldValue.increment(1)});
        }
      });
      print('step3 save customer rating in his account');
      await _firestore
          .collection('Customers')
          .doc(_auth.currentUser.uid)
          .collection('rated products')
          .doc(widget.pRD.id)
          .set({
        'rating': rating,
        'ProductID': widget.pRD.id,
        'CustomerID': _auth.currentUser.uid
      });
      print('step4 change actual rating for product');
      overallRating = (widget.pRD.rate1star +
          widget.pRD.rate2star +
          widget.pRD.rate3star +
          widget.pRD.rate4star +
          widget.pRD.rate5star);
      ratingMul = (5 * widget.pRD.rate5star +
          4 * widget.pRD.rate4star +
          3 * widget.pRD.rate3star +
          2 * widget.pRD.rate2star +
          1 * widget.pRD.rate1star);
      avgRating = ratingMul / overallRating;
      // print('avg rate before convert $avgRating');
      // print('This is it after converting ${avgRating.toStringAsPrecision(2)}');
      await _firestore
          .collection('ProductsCollection')
          .doc('${widget.pRD.type}')
          .collection('Products')
          .doc('${widget.pRD.id}')
          .update({"Rating": avgRating.toStringAsPrecision(2)});
    }
    print('finished');
  }

  String getMobileSpecs() {
    return "\u2022 Storage: ${widget.pRD.storage}\n"
        "\u2022 OS: ${widget.pRD.os}\n"
        "\u2022 Battery: ${widget.pRD.battery}\n"
        "\u2022 Camera: ${widget.pRD.camera}\n"
        "\u2022 Memory: ${widget.pRD.memory}";
  }

  String getLaptopSpecs() {
    return "\u2022 Storage: ${widget.pRD.storage}\n"
        "\u2022 OS: ${widget.pRD.os}\n"
        "\u2022 Battery: ${widget.pRD.battery}\n"
        "\u2022 CPU: ${widget.pRD.cpu}\n"
        "\u2022 GPU: ${widget.pRD.gpu}\n"
        "\u2022 Memory: ${widget.pRD.memory}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          addToCart();
        },
        isExtended: true,
        backgroundColor: Color(0xFF731800),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        icon: Icon(Icons.shopping_cart_outlined),
        label: Text('Add to Cart'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white70,
        title: Text(widget.pRD.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white70,
          ),
          child: ListView(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    flex: 5,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Container(
                        color: Colors.white70,
                        child: PhysicalModel(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          color: Colors.white70,
                          shape: BoxShape.rectangle,
                          child: FadeInImage.assetNetwork(
                            height: 250,
                            width: 250,
                            placeholder: 'images/PlaceHolder.gif',
                            image: (widget.pRD.img == null)
                                ? "https://firebasestorage.googleapis.com/v0/b/store-cc25c.appspot.com/o/uploads%2FPlaceHolder.gif?alt=media&token=89558fba-e8b6-4b99-bcb7-67bf1412a83a"
                                : widget.pRD.img,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        height: 60,
                        width: 60,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.8),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 4), // changes position of shadow
                              ),
                            ],
                            color: Color(0xFFFFE6E6),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10))),
                        child: IconButton(
                            alignment: Alignment.center,
                            icon: (isPressed)
                                ? Icon(Icons.favorite)
                                : Icon(Icons.favorite_outline),
                            tooltip: 'Add to favorites',
                            color: Colors.red,
                            onPressed: () {
                              setState(() {
                                if (isPressed)
                                  isPressed = false;
                                else
                                  isPressed = true;
                              });
                            }),
                      ),
                    ),
                  ),
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                child: Container(
                  height: MediaQuery.of(context).size.height * .6,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.8),
                        spreadRadius: 6,
                        blurRadius: 10,
                        offset: Offset(0, 7), // changes position of shadow
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: SingleChildScrollView(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, top: 10),
                          child: Text(
                            widget.pRD.name,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 20, top: 10),
                              child: Text(
                                "Price",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                            Spacer(
                              flex: 1,
                            ),
                            Container(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 10.0, top: 10),
                                child: (widget.pRD.discount == 'false')
                                    ? Text(
                                        "${widget.pRD.price} EGP",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      )
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "${widget.pRD.price}",
                                            style: TextStyle(
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                fontSize: 15),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "${widget.pRD.newPrice} EGP",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6,
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                            Spacer(
                              flex: 60,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 2),
                                height: 40,
                                width: 80,
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${widget.pRD.rate}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Icon(
                                      Icons.star_outlined,
                                      color: Colors.yellow,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 10),
                          child: Text(
                            "Description",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 60, top: 10),
                          child: Text(widget.pRD.description),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, top: 10, bottom: 10),
                              child: Text(
                                "Sold by ${widget.pRD.sellerEmail}",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                          ),
                        ),
                        /* Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),*/
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 10),
                          child: Text(
                            "Specifications ",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15.0,
                            right: 60,
                            top: 10,
                          ),
                          child: Text(
                              "\u2022 Brand: ${widget.pRD.brand}"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15.0,
                            right: 60,
                          ),
                          child: Text(
                              "\u2022 Quantity: ${widget.pRD.quantity}"),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                              left: 15.0,
                              right: 60,
                              bottom: 10,
                            ),
                            child: Text((() {
                              if (widget.pRD.type == 'Mobiles')
                                return getMobileSpecs();
                              else if (widget.pRD.type == 'Laptops')
                                return getLaptopSpecs();
                              else
                                return 'other';
                            })())),
                        Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 10),
                          child: Text(
                            "Rate product:",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        RatingBar.builder(
                          minRating: 1,
                          glow: false,
                          itemSize: 35.0,
                          direction: Axis.horizontal,
                          allowHalfRating: false,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            if (rating == 1.0) {
                              widget.pRD.rate1star++;
                            } else if (rating == 2.0) {
                              widget.pRD.rate2star++;
                            } else if (rating == 3.0) {
                              widget.pRD.rate3star++;
                            } else if (rating == 4.0) {
                              widget.pRD.rate4star++;
                            } else {
                              widget.pRD.rate5star++;
                            }
                            updateProductRating(rating.toInt());
                          },
                        ),
                        SizedBox(
                          height: 100,
                        ),
                        /*Container(
                          height: MediaQuery.of(context).size.height * 0.30,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.8),
                                  spreadRadius: 6,
                                  blurRadius: 10,
                                  offset:
                                      Offset(0, 7), // changes position of shadow
                                ),
                              ],
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15.0, top: 10),
                                child: Text(
                                  "Seller: ${widget.product_detail_seller}",
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15.0, top: 10),
                                child: Text(
                                  "price ",
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 40.0, top: 1),
                                child: Text(
                                  "${widget.product_detail_new_price} EGP",
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),*/
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

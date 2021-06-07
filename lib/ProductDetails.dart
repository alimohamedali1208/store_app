import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:store_app/UserCustomer.dart';

UserCustomer customer = UserCustomer();

class ProductDetails extends StatefulWidget {
  double customerRating = 0;
  String product_detail_name;
  String product_detail_new_price;
  //final product_detail_old_price;
  var product_detail_picture;
  String product_detail_desc;
  String product_detail_brand;
  String product_detail_quantity;
  String product_detail_seller;
  int rate1star;
  int rate2star;
  int rate3star;
  int rate4star;
  int rate5star;
  String product_detail_rating;
  String product_detail_type;
  String product_detail_id;
  //mobile/laptop Type Stuff
  int mobile_storage;
  String mobile_battery;
  String mobile_memory;
  String mobile_camera;
  String mobile_os;
  //Laptops Stuff
  String GPU;
  String CPU;

  ProductDetails(
      {this.product_detail_name,
      this.product_detail_new_price,
      this.product_detail_picture,
      this.product_detail_desc,
      this.product_detail_brand,
      this.product_detail_quantity,
      this.product_detail_seller,
      this.product_detail_rating,
      this.product_detail_type,
      this.product_detail_id,
      this.rate1star,
      this.rate2star,
      this.rate3star,
      this.rate4star,
      this.rate5star});

  ProductDetails.Mobile(
      {this.product_detail_name,
      this.product_detail_new_price,
      this.product_detail_picture,
      this.product_detail_desc,
      this.product_detail_brand,
      this.product_detail_quantity,
      this.product_detail_seller,
      this.product_detail_rating,
      this.product_detail_type,
      this.product_detail_id,
      this.mobile_battery,
      this.mobile_camera,
      this.mobile_memory,
      this.mobile_os,
      this.mobile_storage,
      this.rate1star,
      this.rate2star,
      this.rate3star,
      this.rate4star,
      this.rate5star});

  ProductDetails.Laptop(
      {this.product_detail_name,
      this.product_detail_new_price,
      this.product_detail_picture,
      this.product_detail_desc,
      this.product_detail_brand,
      this.product_detail_quantity,
      this.product_detail_seller,
      this.product_detail_rating,
      this.product_detail_type,
      this.product_detail_id,
      this.mobile_battery,
      this.CPU,
      this.GPU,
      this.mobile_memory,
      this.mobile_os,
      this.mobile_storage,
      this.rate1star,
      this.rate2star,
      this.rate3star,
      this.rate4star,
      this.rate5star});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  bool isPressed = false;
  //int rate;

  Future updateProductRating(int rating) async {
    //int rate1star, rate2star, rate3star, rate4star, rate5star;
    int oldRating;
    int ratingMul;
    int overallRating;
    double avgRating;
    if (customer.firstName == 'temp')
      print('user not signed in!');
    else {
      print('User is signed in!');
      print('step1 get old rating');
      await _firestore
          .collection('Customers')
          .doc(_auth.currentUser.uid)
          .collection('rated products')
          .doc(widget.product_detail_id)
          .get()
          .then((DocumentSnapshot snapshot) async {
        if (snapshot.exists) {
          print('step2 document exists then get old rating');
          await _firestore
              .collection('Customers')
              .doc(_auth.currentUser.uid)
              .collection('rated products')
              .doc(widget.product_detail_id)
              .get()
              .then((value) {
            oldRating = value.data()['rating'];
            print('This is old rating $oldRating');
          });
          print('step2 change how many stars');
          await _firestore
              .collection('ProductsCollection')
              .doc('${widget.product_detail_type}')
              .collection('Products')
              .doc(widget.product_detail_id)
              .update({
            '$oldRating star rate': FieldValue.increment(-1),
            '$rating star rate': FieldValue.increment(1)
          });
          if (oldRating == 1) {
            widget.rate1star--;
          } else if (oldRating == 2) {
            widget.rate2star--;
          } else if (oldRating == 3) {
            widget.rate3star--;
          } else if (oldRating == 4) {
            widget.rate4star--;
          } else {
            widget.rate5star--;
          }
        } else {
          print('step2 document not found just change no. of stars');
          await _firestore
              .collection('ProductsCollection')
              .doc('${widget.product_detail_type}')
              .collection('Products')
              .doc(widget.product_detail_id)
              .update({'$rating star rate': FieldValue.increment(1)});
        }
      });
      print('step3 save customer rating in his account');
      await _firestore
          .collection('Customers')
          .doc(_auth.currentUser.uid)
          .collection('rated products')
          .doc(widget.product_detail_id)
          .set({'rating': rating});
      print('step4 change actual rating for product');
      overallRating = (widget.rate5star + widget.rate4star + widget.rate3star + widget.rate2star + widget.rate1star);
      ratingMul = (5 * widget.rate5star + 4 * widget.rate4star + 3 * widget.rate3star + 2 * widget.rate2star + 1 * widget.rate1star);
      avgRating = ratingMul / overallRating;
      print('avg rate before convert $avgRating');
      print('This is it after converting ${avgRating.toStringAsPrecision(2)}');
      await _firestore
          .collection('ProductsCollection')
          .doc('${widget.product_detail_type}')
          .collection('Products')
          .doc('${widget.product_detail_id}')
          .update({"Rating": avgRating.toStringAsPrecision(2)});
    }
    print('finished');
  }

  String getMobileSpecs() {
    return "\u2022 Storage: ${widget.mobile_storage}\n"
        "\u2022 OS: ${widget.mobile_os}\n"
        "\u2022 Battery: ${widget.mobile_battery}\n"
        "\u2022 Camera: ${widget.mobile_camera}\n"
        "\u2022 Memory: ${widget.mobile_memory}";
  }

  String getLaptopSpecs() {
    return "\u2022 Storage: ${widget.mobile_storage}\n"
        "\u2022 OS: ${widget.mobile_os}\n"
        "\u2022 Battery: ${widget.mobile_battery}\n"
        "\u2022 CPU: ${widget.CPU}\n"
        "\u2022 GPU: ${widget.GPU}\n"
        "\u2022 Memory: ${widget.mobile_memory}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        isExtended: true,
        backgroundColor: Color(0xFF731800),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        icon: Icon(Icons.shopping_cart_outlined),
        label: Text('Add to Cart'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.grey[300],
        title: Text(widget.product_detail_name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search, color: Colors.black), onPressed: () {}),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
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
                        color: Colors.grey[300],
                        shape: BoxShape.rectangle,
                        child: FadeInImage.assetNetwork(
                          height: 250,
                          width: 250,
                          placeholder: 'images/PlaceHolder.gif',
                          image: (widget.product_detail_picture == null)
                              ? "https://firebasestorage.googleapis.com/v0/b/store-cc25c.appspot.com/o/uploads%2FPlaceHolder.gif?alt=media&token=89558fba-e8b6-4b99-bcb7-67bf1412a83a"
                              : widget.product_detail_picture,
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
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
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
                          widget.product_detail_name,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      Row(children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 20, top: 10),
                          child: Text(
                            "Price",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 100, top: 10),
                          child: Text(
                            "${widget.product_detail_new_price} EGP",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Align(
                            alignment: Alignment.bottomRight,
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
                                    "${widget.product_detail_rating}",
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
                        ),
                      ]),
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
                        child: Text(widget.product_detail_desc),
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
                              "Sold by ${widget.product_detail_seller}",
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
                            "\u2022 Brand: ${widget.product_detail_brand}"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 15.0,
                          right: 60,
                          top: 10,
                        ),
                        child: Text(
                            "\u2022 Quantity: ${widget.product_detail_quantity}"),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                            left: 15.0,
                            right: 60,
                            top: 10,
                          ),
                          child: Text((() {
                            if (widget.product_detail_type == 'Mobiles')
                              return getMobileSpecs();
                            else if (widget.product_detail_type == 'Laptops')
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
                        initialRating: widget.customerRating,
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
                            widget.rate1star++;
                          } else if (rating == 2.0) {
                            widget.rate2star++;
                          } else if (rating == 3.0) {
                            widget.rate3star++;
                          } else if (rating == 4.0) {
                            widget.rate4star++;
                          } else {
                            widget.rate5star++;
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
    );
  }
}

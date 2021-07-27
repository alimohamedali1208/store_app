import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:readmore/readmore.dart';
import 'package:store_app/UserCustomer.dart';
import 'package:store_app/components/quantitySlider.dart';
import 'package:store_app/login.dart';
import 'package:store_app/productClass.dart';

UserCustomer customer = UserCustomer();

class ProductDetails extends StatefulWidget {
  ProductClass prd;
  bool favPressed = false;

  ProductDetails({this.prd});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  //int rate;

  Future addToCart() async {
    setState(() {
      showSpinner = true;
    });
    if (customer.firstName == "temp") {
      Navigator.push(context, MaterialPageRoute(builder: (context) => login()));
      Fluttertoast.showToast(msg: "You need to sign in first");
    } else {
      print('first check if product already in cart');
      await _firestore
          .collection('Customers')
          .doc(_auth.currentUser.uid)
          .collection('cart')
          .doc(widget.prd.id)
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
              .doc(widget.prd.id)
              .set({
            'ProductID': widget.prd.id,
            'CustomerID': _auth.currentUser.uid,
            'Product Quantity': widget.prd.quantity,
            'Ordered Quantity': '1',
            'Product Name': widget.prd.name,
            'Price': widget.prd.price,
            'New price': widget.prd.newPrice,
            'Discount': widget.prd.discount,
            'Discount percent': widget.prd.discountPercentage,
            'type': widget.prd.type,
            'ChangeFlag': 'false',
            'imgURL': widget.prd.img,
          });
          double price;
          if (widget.prd.discount == 'false')
            price = widget.prd.price;
          else
            price = double.parse(widget.prd.newPrice);
          await _firestore
              .collection('Customers')
              .doc(_auth.currentUser.uid)
              .update({'Total': FieldValue.increment(price)});
          print('Product added to cart');
          //remove product from favorites
          removeFromFav();
        }
      });
    }
    setState(() {
      showSpinner = false;
    });
  }

  Future addToFav() async {
    if (customer.firstName == "temp") {
      Navigator.push(context, MaterialPageRoute(builder: (context) => login()));
      Fluttertoast.showToast(msg: "You need to sign in first");
    } else {
      print('first check if product already in fav');

      await _firestore
          .collection('Customers')
          .doc(_auth.currentUser.uid)
          .collection('favorite')
          .doc(widget.prd.id)
          .get()
          .then((DocumentSnapshot snapshot) async {
        if (snapshot.exists) {
          print('product already in fav');
          await removeFromFav();
          setState(() {
            widget.favPressed = false;
          });
        } else {
          print('insert product id in fav');
          await _firestore
              .collection('Customers')
              .doc(_auth.currentUser.uid)
              .collection('favorite')
              .doc(widget.prd.id)
              .set({
            'ProductID': widget.prd.id,
            'CustomerID': _auth.currentUser.uid,
            'Product Name': widget.prd.name,
            'Product Quantity': widget.prd.quantity,
            'Ordered Quantity': '1',
            'Price': widget.prd.price,
            'New price': widget.prd.newPrice,
            'Discount': widget.prd.discount,
            'Discount percent': widget.prd.discountPercentage,
            'type': widget.prd.type,
            'ChangeFlag': 'false',
            'imgURL': widget.prd.img
          });
          setState(() {
            widget.favPressed = true;
          });
        }
      });
    }
  }

  Future removeFromFav() async {
    if (customer.firstName == "temp") {
      Fluttertoast.showToast(msg: "You need to sign in first");
    } else {
      print('first check if product already in fav');
      await _firestore
          .collection('Customers')
          .doc(_auth.currentUser.uid)
          .collection('favorite')
          .doc(widget.prd.id)
          .get()
          .then((DocumentSnapshot snapshot) async {
        if (!snapshot.exists) {
          print('product not in favorites');
        } else {
          print('remove product from fav');
          await _firestore
              .collection('Customers')
              .doc(_auth.currentUser.uid)
              .collection('favorite')
              .doc(widget.prd.id)
              .delete();
        }
      });
      setState(() {
        widget.favPressed = false;
      });
    }
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
      Navigator.push(context, MaterialPageRoute(builder: (context) => login()));
      Fluttertoast.showToast(msg: "You need to sign in first!");
    } else {
      print('User is signed in!');
      print('step1 get old rating');
      await _firestore
          .collection('Customers')
          .doc(_auth.currentUser.uid)
          .collection('rated products')
          .doc(widget.prd.id)
          .get()
          .then((DocumentSnapshot snapshot) async {
        if (snapshot.exists) {
          print('step2 document exists then get old rating');
          await _firestore
              .collection('Customers')
              .doc(_auth.currentUser.uid)
              .collection('rated products')
              .doc(widget.prd.id)
              .get()
              .then((value) {
            oldRating = value.data()['rating'];
            print('This is old rating $oldRating');
          });
          print('step2 change how many stars');
          await _firestore
              .collection('ProductsCollection')
              .doc('${widget.prd.type}')
              .collection('Products')
              .doc(widget.prd.id)
              .update({
            '$oldRating star rate': FieldValue.increment(-1),
            '$rating star rate': FieldValue.increment(1)
          });
          if (oldRating == 1) {
            widget.prd.rate1star--;
          } else if (oldRating == 2) {
            widget.prd.rate2star--;
          } else if (oldRating == 3) {
            widget.prd.rate3star--;
          } else if (oldRating == 4) {
            widget.prd.rate4star--;
          } else {
            widget.prd.rate5star--;
          }
        } else {
          print('step2 document not found just change no. of stars');
          await _firestore
              .collection('ProductsCollection')
              .doc('${widget.prd.type}')
              .collection('Products')
              .doc(widget.prd.id)
              .update({'$rating star rate': FieldValue.increment(1)});
        }
      });
      print('step3 save customer rating in his account');
      await _firestore
          .collection('Customers')
          .doc(_auth.currentUser.uid)
          .collection('rated products')
          .doc(widget.prd.id)
          .set({
        'rating': rating,
        'ProductID': widget.prd.id,
        'CustomerID': _auth.currentUser.uid
      });
      print('step4 change actual rating for product');
      overallRating = (widget.prd.rate1star +
          widget.prd.rate2star +
          widget.prd.rate3star +
          widget.prd.rate4star +
          widget.prd.rate5star);
      ratingMul = (5 * widget.prd.rate5star +
          4 * widget.prd.rate4star +
          3 * widget.prd.rate3star +
          2 * widget.prd.rate2star +
          1 * widget.prd.rate1star);
      avgRating = ratingMul / overallRating;
      // print('avg rate before convert $avgRating');
      // print('This is it after converting ${avgRating.toStringAsPrecision(2)}');
      await _firestore
          .collection('ProductsCollection')
          .doc('${widget.prd.type}')
          .collection('Products')
          .doc('${widget.prd.id}')
          .update({"Rating": avgRating.toStringAsPrecision(2)});
    }
    print('finished');
  }

  String getMobileSpecs() {
    return "\u2022 Storage: ${widget.prd.storage} ${widget.prd.storageUnit}\n"
        "\u2022 OS: ${widget.prd.os}\n"
        "\u2022 Battery: ${widget.prd.battery} mAh\n"
        "\u2022 Camera: ${widget.prd.camera} megapixels\n"
        "\u2022 Memory: ${widget.prd.memory} ${widget.prd.memoryUnit}\n"
        "\u2022 Color: ${widget.prd.color}\n"
        "\u2022 Screen size: ${widget.prd.screenSize} inches";
  }

  String getLaptopSpecs() {
    return "\u2022 Storage: ${widget.prd.storage} ${widget.prd.storageUnit}\n"
        "\u2022 OS: ${widget.prd.os}\n"
        "\u2022 Battery: ${widget.prd.battery} mAh\n"
        "\u2022 CPU: ${widget.prd.cpu}\n"
        "\u2022 GPU: ${widget.prd.gpu}\n"
        "\u2022 Memory: ${widget.prd.memory} GB\n"
        "\u2022 Color: ${widget.prd.color}\n"
        "\u2022 Screen size: ${widget.prd.screenSize} inches";
  }

  String getCameraSpecs() {
    return "\u2022 Photo resolution: ${widget.prd.megapixel}\n"
        "\u2022 Optical zoom: ${widget.prd.opticalzoom}\n"
        "\u2022 Camera type: ${widget.prd.cameratype}\n"
        "\u2022 Screen type: ${widget.prd.screenType}\n"
        "\u2022 Screen size: ${widget.prd.screenSize}";
  }

  String getCameraAccessorySpecs() {
    return "\u2022 Accessory Type: ${widget.prd.accessoryType}";
  }

  String getProjectorSpecs() {
    return "\u2022 Projector Type: ${widget.prd.projectorType}";
  }

  String getPrinterSpecs() {
    return "\u2022 Paper Size: ${widget.prd.paperSize}\n"
        "\u2022 Printer Type: ${widget.prd.printerType}";
  }

  String getStorageDeviceSpecs() {
    return "\u2022 Storage Type: ${widget.prd.storageType}\n"
        "\u2022 Capacity: ${widget.prd.storageUnit}";
  }

  String getFridgeSpecs() {
    return "\u2022 Weight: ${widget.prd.weight} Kg\n"
        "\u2022 Depth: ${widget.prd.depth}\n"
        "\u2022 Width: ${widget.prd.width}\n"
        "\u2022 Height: ${widget.prd.height}\n"
        "\u2022 Color: ${widget.prd.color}\n"
        "\u2022 Material: ${widget.prd.material}";
  }

  String getTVSpecs() {
    return "\u2022 Weight: ${widget.prd.weight} Kg\n"
        "\u2022 Depth: ${widget.prd.depth}\n"
        "\u2022 Width: ${widget.prd.width}\n"
        "\u2022 Color: ${widget.prd.color}\n"
        "\u2022 TV type: ${widget.prd.tvType}\n"
        "\u2022 Screen resolution: ${widget.prd.screenRes}\n"
        "\u2022 Screen type: ${widget.prd.screenType}\n"
        "\u2022 Screen size: ${widget.prd.screenSize} inches";
  }

  String getAirConditionerSpecs() {
    return "\u2022 Weight: ${widget.prd.weight} Kg\n"
        "\u2022 Depth: ${widget.prd.depth}\n"
        "\u2022 Width: ${widget.prd.width}\n"
        "\u2022 Horse Power: ${widget.prd.horsePower}\n"
        "\u2022 Color: ${widget.prd.color}\n"
        "\u2022 Conditioner type: ${widget.prd.conditionerType}";
  }

  String getOtherHomeSpecs() {
    return "\u2022 Weight: ${widget.prd.weight} Kg\n"
        "\u2022 Depth: ${widget.prd.depth}\n"
        "\u2022 Width: ${widget.prd.width}\n"
        "\u2022 Color: ${widget.prd.color}";
  }

  String getJewelrySpecs() {
    return "\u2022 Metal type: ${widget.prd.metalType}\n"
        "\u2022 Target group: ${widget.prd.targetGroup}";
  }

  String getFashionSpecs() {
    return "\u2022 Clothing type: ${widget.prd.clothType}\n"
        "\u2022 Size: ${widget.prd.ClothSize}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (customer.firstName == "temp") {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => login()));
            Fluttertoast.showToast(msg: "You need to sign in first");
          } else {
            if (widget.prd.quantity == '0') {
              Fluttertoast.showToast(msg: "Out of stock");
            } else {
              addToCart();
            }
          }
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
        title: Text(widget.prd.name,
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
                            image: (widget.prd.img == null)
                                ? "https://firebasestorage.googleapis.com/v0/b/store-cc25c.appspot.com/o/uploads%2FPlaceHolder.gif?alt=media&token=89558fba-e8b6-4b99-bcb7-67bf1412a83a"
                                : widget.prd.img,
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
                            icon: (widget.favPressed)
                                ? Icon(Icons.favorite)
                                : Icon(Icons.favorite_outline),
                            tooltip: 'Add to favorites',
                            color: Colors.red,
                            onPressed: () {
                              if (widget.prd.quantity == '0') {
                                Fluttertoast.showToast(msg: "Out of stock");
                              } else {
                                addToFav();
                              }
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
                            widget.prd.name,
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
                                child: (widget.prd.discount == 'false')
                                    ? Text(
                                        "${widget.prd.price} EGP",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      )
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "${widget.prd.price}",
                                            style: TextStyle(
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                fontSize: 15),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "${widget.prd.newPrice} EGP",
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
                                      "${widget.prd.rate}",
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
                          padding: const EdgeInsets.only(left: 2.0, top: 2),
                          child: (widget.prd.quantity == '0')
                              ? Column(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            color: Colors.red[600],
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Text(
                                          "Out of stock",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 7),
                                      child: Text(
                                        "Description",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  "Description",
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 60, top: 10),
                          child: ReadMoreText(
                            widget.prd.description,
                            trimLines: 3,
                            colorClickableText: Color(0xFF731800),
                            trimMode: TrimMode.Line,
                            trimCollapsedText: ' ...Show more',
                            trimExpandedText: '  Show less',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
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
                                "Sold by ${widget.prd.sellerEmail}",
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
                          child: Text("\u2022 Brand: ${widget.prd.brand}"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15.0,
                            right: 60,
                          ),
                          child:
                              Text("\u2022 Quantity: ${widget.prd.quantity}"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15.0,
                            right: 60,
                            bottom: 10,
                          ),
                          child: Text((() {
                            if (widget.prd.type == 'Mobiles')
                              return getMobileSpecs();
                            else if (widget.prd.type == 'Laptops')
                              return getLaptopSpecs();
                            else if (widget.prd.type == 'Cameras')
                              return getCameraSpecs();
                            else if (widget.prd.type == 'Fridges')
                              return getFridgeSpecs();
                            else if (widget.prd.type == 'TV')
                              return getTVSpecs();
                            else if (widget.prd.type == 'AirConditioner')
                              return getAirConditionerSpecs();
                            else if (widget.prd.type == 'OtherHome')
                              return getOtherHomeSpecs();
                            else if (widget.prd.type == 'OtherPC' ||
                                widget.prd.type == 'CameraAccessories')
                              return getCameraAccessorySpecs();
                            else if (widget.prd.type == 'Jewelery')
                              return getJewelrySpecs();
                            else if (widget.prd.type == 'Printers')
                              return getPrinterSpecs();
                            else if (widget.prd.type == 'StorageDevices')
                              return getStorageDeviceSpecs();
                            else if (widget.prd.type == 'Projectors')
                              return getProjectorSpecs();
                            else if (widget.prd.type == 'Fashion')
                              return getFashionSpecs();
                            else
                              return '';
                          })()),
                        ),
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
                            if (customer.firstName == 'temp') {
                            } else {
                              if (rating == 1.0) {
                                widget.prd.rate1star++;
                              } else if (rating == 2.0) {
                                widget.prd.rate2star++;
                              } else if (rating == 3.0) {
                                widget.prd.rate3star++;
                              } else if (rating == 4.0) {
                                widget.prd.rate4star++;
                              } else {
                                widget.prd.rate5star++;
                              }
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

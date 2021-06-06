import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:store_app/MobileCatSearch.dart';
import 'package:store_app/ProductDetails.dart';
import 'package:store_app/SearchPages/LaptopCatSearch.dart';

class autoSearchCompelete extends StatefulWidget {
  @override
  _autoSearchCompeleteState createState() => _autoSearchCompeleteState();
}

class _autoSearchCompeleteState extends State<autoSearchCompelete> {
  //final _auth = FirebaseAuth.instance;
  final database = FirebaseFirestore.instance;
  String searchString = '';
  String ddSearchCategory;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 110),
        child: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                TextField(
                  textAlignVertical: TextAlignVertical.center,
                  textCapitalization: TextCapitalization.none,
                  autofocus: false,
                  style: TextStyle(fontSize: 16),
                  cursorColor: Colors.blue[900],
                  onChanged: (val) {
                    setState(() {
                      searchString = val.toLowerCase().trim();
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.white70,
                    prefixIcon: IconButton(
                      color: Colors.black,
                      icon: Icon(Icons.arrow_back),
                      iconSize: 20.0,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    contentPadding: EdgeInsets.only(left: 25.0),
                    hintText: 'Search By Name',
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 30,
                  margin: EdgeInsets.only(left: 5, right: 5),
                  padding: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(20)),
                  child: DropdownButton<String>(
                    style: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.w600),
                    items: [
                      DropdownMenuItem<String>(
                        child: Text('Laptops'),
                        value: 'laptops',
                      ),
                      DropdownMenuItem<String>(
                        child: Text('Mobiles'),
                        value: 'mobiles',
                      ),
                      DropdownMenuItem<String>(
                        child: Text('Home Appliances'),
                        value: 'home',
                      ),
                    ],
                    onChanged: (String value) {
                      setState(() {
                        if (value == 'laptops') {
                           Navigator.push(context,
                               MaterialPageRoute(builder: (context) => laptopCatSearch()));
                        } else if (value == 'mobiles') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => mobileCatSearch()));
                        } else {}
                      });
                    },
                    hint: Text('Choose Category'),
                    value: ddSearchCategory,
                  ),
                ),
              ],
            ),
          ),
          centerTitle: false,
          backgroundColor: Color(0xFF731800),
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
                      .collectionGroup('Products')
                      .where('searchIndex', arrayContains: searchString)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError)
                      return Text('Error: ${snapshot.error}');
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                      default:
                        final products = snapshot.data.docs;
                        var productview;
                        List<SingleProduct> productsview = [];
                        for (var product in products) {
                          final productname = product.data()['Product Name'];
                          final productprice = product.data()['Price'].toString();
                          final productimg = product.data()['imgURL'];
                          final producttype = product.data()['type'];
                          final productdesc = product.data()['Description'];
                          final productbrand = product.data()['Brand Name'];
                          final productquantity = product.data()['Quantity'];
                          final productseller = product.data()['Seller Email'];
                          final productrating = product.data()['Rating'];
                          final productid = product.id;
                          //now stuff that's specific for every product type
                          if(producttype == 'Mobiles'){
                            final productStorage = product.data()['Storage'];
                            final productbattery = product.data()['Battery'];
                            final productmemory = product.data()['Memory'];
                            final productcamera = product.data()['Camera'];
                            final productos = product.data()['OS'];
                             productview = SingleProduct.mobile(
                              productName: productname,
                              productPrice: productprice,
                              productImg: productimg,
                              productType: producttype,
                              productDesc: productdesc,
                              productBrand: productbrand,
                              productQuantity: productquantity,
                              productSeller: productseller,
                              productID: productid,
                              productRating: productrating,
                              productOS: productos,
                              productMemory: productmemory,
                              productCamera: productcamera,
                              productStorage: productStorage,
                              productBattery: productbattery,
                            );
                          }
                          else if (producttype == 'Laptops'){
                            final productStorage = product.data()['Storage'];
                            final productbattery = product.data()['Battery'];
                            final productmemory = product.data()['Memory'];
                            final productcpu = product.data()['CPU'];
                            final productgpu = product.data()['GPU'];
                            final productos = product.data()['OS'];
                            productview = SingleProduct.laptop(
                              productName: productname,
                              productPrice: productprice,
                              productImg: productimg,
                              productType: producttype,
                              productDesc: productdesc,
                              productBrand: productbrand,
                              productQuantity: productquantity,
                              productSeller: productseller,
                              productID: productid,
                              productRating: productrating,
                              productOS: productos,
                              productMemory: productmemory,
                              productCPU: productcpu,
                              productGPU: productgpu,
                              productStorage: productStorage,
                              productBattery: productbattery,
                            );
                          }
                          else{
                           productview = SingleProduct(
                            productName: productname,
                            productPrice: productprice,
                            productImg: productimg,
                            productType: producttype,
                            productDesc: productdesc,
                            productBrand: productbrand,
                            productQuantity: productquantity,
                            productSeller: productseller,
                            productID: productid,
                            productRating: productrating,
                          );}
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

class SingleProduct extends StatefulWidget {
  final String productName;
  final String productPrice;
  final String productImg;
  final String productType;
  final String productID;
  final String productDesc;
  final String productBrand;
  final String productQuantity;
  final String productSeller;
  final int productRating;
  //mobile/laptop stuff
   int productStorage;
   String productBattery;
   String productMemory;
   String productCamera;
   String productOS;
   //laptop stuff
   String productCPU;
   String productGPU;

  SingleProduct(
      {this.productName,
      this.productPrice,
      this.productImg,
      this.productID,
      this.productType,
      this.productDesc,
      this.productBrand,
      this.productQuantity,
      this.productSeller,
      this.productRating});

  SingleProduct.mobile(
      {this.productName,
        this.productPrice,
        this.productImg,
        this.productID,
        this.productType,
        this.productDesc,
        this.productBrand,
        this.productQuantity,
        this.productSeller,
        this.productRating,
        this.productStorage,
        this.productOS,
        this.productBattery,
        this.productCamera,
        this.productMemory});

  SingleProduct.laptop(
      {this.productName,
        this.productPrice,
        this.productImg,
        this.productID,
        this.productType,
        this.productDesc,
        this.productBrand,
        this.productQuantity,
        this.productSeller,
        this.productRating,
        this.productStorage,
        this.productOS,
        this.productBattery,
        this.productCPU,
        this.productGPU,
        this.productMemory});

  @override
  _SingleProductState createState() => _SingleProductState();
}

class _SingleProductState extends State<SingleProduct> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () { if(widget.productType == 'Mobiles'){
          Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (context) => ProductDetails.Mobile(
                // passing the values via constructor
                product_detail_name: widget.productName,
                product_detail_new_price: widget.productPrice,
                product_detail_picture: widget.productImg,
                product_detail_desc: widget.productDesc,
                product_detail_brand: widget.productBrand,
                product_detail_quantity: widget.productQuantity,
                product_detail_seller: widget.productSeller,
                product_detail_rating: widget.productRating,
                product_detail_type: widget.productType,
                product_detail_id: widget.productID,
                mobile_storage: widget.productStorage,
                mobile_battery: widget.productBattery,
                mobile_camera: widget.productCamera,
                mobile_memory: widget.productMemory,
                mobile_os: widget.productOS,
              ),
            ),
          );
        }
        else if(widget.productType=='Laptops'){
          Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (context) => ProductDetails.Laptop(
                // passing the values via constructor
                product_detail_name: widget.productName,
                product_detail_new_price: widget.productPrice,
                product_detail_picture: widget.productImg,
                product_detail_desc: widget.productDesc,
                product_detail_brand: widget.productBrand,
                product_detail_quantity: widget.productQuantity,
                product_detail_seller: widget.productSeller,
                product_detail_rating: widget.productRating,
                product_detail_type: widget.productType,
                product_detail_id: widget.productID,
                mobile_storage: widget.productStorage,
                mobile_battery: widget.productBattery,
                CPU: widget.productCPU,
                GPU: widget.productGPU,
                mobile_memory: widget.productMemory,
                mobile_os: widget.productOS,
              ),
            ),
          );
        }
          else{
          Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (context) => ProductDetails(
                // passing the values via constructor
                product_detail_name: widget.productName,
                product_detail_new_price: widget.productPrice,
                product_detail_picture: widget.productImg,
                product_detail_desc: widget.productDesc,
                product_detail_brand: widget.productBrand,
                product_detail_quantity: widget.productQuantity,
                product_detail_seller: widget.productSeller,
                product_detail_rating: widget.productRating,
                product_detail_type: widget.productType,
                product_detail_id: widget.productID,
              ),
            ),
          );
        }
        },
        child: ListTile(
          //    ======= the leading image section =======
          leading: FadeInImage.assetNetwork(
            placeholder: 'images/PlaceHolder.gif',
            image: (widget.productImg == null)
                ? "https://firebasestorage.googleapis.com/v0/b/store-cc25c.appspot.com/o/uploads%2FPlaceHolder.gif?alt=media&token=89558fba-e8b6-4b99-bcb7-67bf1412a83a"
                : widget.productImg,
            height: 80,
            width: 80,
          ),
          title: Text(widget.productName),
          subtitle: Column(
            children: <Widget>[
              //  ======= this for price section ======
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  "${widget.productPrice} EGP",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
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
                  SizedBox(
                    width: 10,
                  ),
                  IconButton(
                      icon: const Icon(Icons.add_shopping_cart_outlined),
                      tooltip: 'Add to cart',
                      color: Colors.black,
                      onPressed: () {}),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
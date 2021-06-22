import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:store_app/ProductDetails.dart';

class mobileCatSearch extends StatefulWidget {
  @override
  _mobileCatSearchState createState() => _mobileCatSearchState();
}

class _mobileCatSearchState extends State<mobileCatSearch> {
  final database = FirebaseFirestore.instance;
  String searchString = '';
  int ddStorage, ddRatings;
  String ddCamera, ddBattery, ddOS, ddSearchBrand, ddMemory;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 110),
        child: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Padding(
            padding: EdgeInsets.only(top: 10),
            child: Column(
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
                    hintText: 'Search for phones',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 30,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 5, right: 5),
                        padding: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(20)),
                        child: DropdownButton<String>(
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600),
                          items: [
                            DropdownMenuItem<String>(
                              child: Text('Sony'),
                              value: 'Sony',
                            ),
                            DropdownMenuItem<String>(
                              child: Text('Apple'),
                              value: 'Apple',
                            ),
                            DropdownMenuItem<String>(
                              child: Text('Samsung'),
                              value: 'Samsung',
                            ),
                            DropdownMenuItem<String>(
                              child: Text('Other'),
                              value: 'Other',
                            ),
                          ],
                          onChanged: (String value) {
                            setState(() {
                              ddSearchBrand = value;
                            });
                          },
                          hint: Text('Choose Brand'),
                          value: ddSearchBrand,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5, right: 5),
                        padding: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(20)),
                        child: DropdownButton<int>(
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600),
                          items: [
                            DropdownMenuItem<int>(
                              child: Text('>16 GB'),
                              value: 16,
                            ),
                            DropdownMenuItem<int>(
                              child: Text('>32 GB'),
                              value: 32,
                            ),
                            DropdownMenuItem<int>(
                              child: Text('>64 GB'),
                              value: 64,
                            ),
                          ],
                          onChanged: (int value) {
                            setState(() {
                              ddStorage = value;
                            });
                          },
                          hint: Text('Choose Storage'),
                          value: ddStorage,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5, right: 5),
                        padding: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(20)),
                        child: DropdownButton<String>(
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600),
                          items: [
                            DropdownMenuItem<String>(
                              child: Text('16'),
                              value: '16',
                            ),
                            DropdownMenuItem<String>(
                              child: Text('32'),
                              value: '32',
                            ),
                            DropdownMenuItem<String>(
                              child: Text('Other'),
                              value: null,
                            ),
                          ],
                          onChanged: (String value) {
                            setState(() {
                              ddCamera = value;
                            });
                          },
                          hint: Text('Camera resolution'),
                          value: ddCamera,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5, right: 5),
                        padding: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(20)),
                        child: DropdownButton<String>(
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600),
                          items: [
                            DropdownMenuItem<String>(
                              child: Text('IOS'),
                              value: 'IOS',
                            ),
                            DropdownMenuItem<String>(
                              child: Text('Android'),
                              value: 'Android',
                            ),
                            DropdownMenuItem<String>(
                              child: Text('Other'),
                              value: null,
                            ),
                          ],
                          onChanged: (String value) {
                            setState(() {
                              ddOS = value;
                            });
                          },
                          hint: Text('Choose OS'),
                          value: ddOS,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5, right: 5),
                        padding: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(20)),
                        child: DropdownButton<String>(
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600),
                          items: [
                            DropdownMenuItem<String>(
                              child: Text('2800 mAH'),
                              value: '2800',
                            ),
                            DropdownMenuItem<String>(
                              child: Text('3800 mAH'),
                              value: '3800',
                            ),
                            DropdownMenuItem<String>(
                              child: Text('4800 mAH'),
                              value: '4800',
                            ),
                            DropdownMenuItem<String>(
                              child: Text('Other'),
                              value: null,
                            ),
                          ],
                          onChanged: (String value) {
                            setState(() {
                              ddBattery = value;
                            });
                          },
                          hint: Text('Choose Battery'),
                          value: ddBattery,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5, right: 5),
                        padding: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(20)),
                        child: DropdownButton<int>(
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600),
                          items: [
                            DropdownMenuItem<int>(
                              child: Text('>1 Star'),
                              value: 1,
                            ),
                            DropdownMenuItem<int>(
                              child: Text('>2 Stars'),
                              value: 2,
                            ),
                            DropdownMenuItem<int>(
                              child: Text('>3 Stars'),
                              value: 3,
                            ),
                            DropdownMenuItem<int>(
                              child: Text('>4 Stars'),
                              value: 4,
                            ),
                            DropdownMenuItem<int>(
                              child: Text('5 Stars'),
                              value: 5,
                            ),
                            DropdownMenuItem<int>(
                              child: Text('No Reviews'),
                              value: null,
                            ),
                          ],
                          onChanged: (int value) {
                            setState(() {
                              ddRatings = value;
                            });
                          },
                          hint: Text('Choose Rating'),
                          value: ddRatings,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5, right: 5),
                        padding: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(20)),
                        child: DropdownButton<String>(
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600),
                          items: [
                            DropdownMenuItem<String>(
                              child: Text('3 GB'),
                              value: '3',
                            ),
                            DropdownMenuItem<String>(
                              child: Text('4 GB'),
                              value: '4',
                            ),
                            DropdownMenuItem<String>(
                              child: Text('6 GB'),
                              value: '6',
                            ),
                            DropdownMenuItem<String>(
                              child: Text('Other'),
                              value: null,
                            ),
                          ],
                          onChanged: (String value) {
                            setState(() {
                              ddMemory = value;
                            });
                          },
                          hint: Text('Choose Memory'),
                          value: ddMemory,
                        ),
                      ),
                    ],
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
                Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('ProductsCollection')
                      .doc('Mobiles')
                      .collection('Products')
                      .where('searchIndex', arrayContains: searchString)
                      .where('Brand Name', isEqualTo: ddSearchBrand)
                      .where('OS', isEqualTo: ddOS)
                      .where('Camera', isEqualTo: ddCamera)
                      .where('Memory', isEqualTo: ddMemory)
                      .where('Battery', isEqualTo: ddBattery)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError)
                      return Text('Error: ${snapshot.error}');
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                      default:
                        final products = snapshot.data.docs;
                        List<SingleProduct> productsview = [];
                        for (var product in products) {
                          final productStorage = product.data()['Storage'];
                          final productRating = product.data()['Rating'];
                          if (ddStorage == null || productStorage >= ddStorage) {
                            if (ddRatings == null || productRating >= ddRatings) {
                              final productname = product.data()['Product Name'];
                              final productprice = product.data()['Price'];
                              final productimg = product.data()['imgURL'];
                              final producttype = product.data()['type'];
                              final productdesc = product.data()['Description'];
                              final productbrand = product.data()['Brand Name'];
                              final productquantity = product.data()['Quantity'];
                              final productseller = product.data()['Seller Email'];
                              final productrating = product.data()['Rating'];
                              final productid = product.id;
                              //stuff specific to this type of products
                              final productbattery = product.data()['Battery'];
                              final productmemory = product.data()['Memory'];
                              final productcamera = product.data()['Camera'];
                              final productos = product.data()['OS'];
                              final productview = SingleProduct(
                                productName: productname,
                                productPrice: productprice,
                                productImg: productimg,
                                productType: producttype,
                                productDesc: productdesc,
                                productBrand: productbrand,
                                productQuantity: productquantity,
                                productSeller: productseller,
                                productRating: productrating,
                                productID: productid,
                                //stuff specific to this type of products
                                productStorage: productStorage,
                                productBattery: productbattery,
                                productCamera: productcamera,
                                productMemory: productmemory,
                                productOS: productos,
                              );
                              productsview.add(productview);
                            }
                          }
                        }
                        return ListView(children: productsview);
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
  final double productPrice;
  final String productImg;
  final String productType;
  final String productID;
  final String productDesc;
  final String productBrand;
  final String productQuantity;
  final String productSeller;
  final String productRating;
  final int rate1star;
  final int rate2star;
  final int rate3star;
  final int rate4star;
  final int rate5star;
  //stuff specific to this type of products
  final int productStorage;
  final String productBattery;
  final String productMemory;
  final String productCamera;
  final String productOS;

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
      this.productRating,
      this.productStorage,
      this.productOS,
      this.productBattery,
      this.productCamera,
      this.productMemory,
      this.rate1star,
      this.rate2star,
      this.rate3star,
      this.rate4star,
      this.rate5star});

  @override
  _SingleProductState createState() => _SingleProductState();
}

class _SingleProductState extends State<SingleProduct> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (context) => ProductDetails.Mobile(
                // passing the values via constructor
                product_detail_name: widget.productName,
                product_detail_price: widget.productPrice,
                product_detail_picture: widget.productImg,
                product_detail_desc: widget.productDesc,
                product_detail_brand: widget.productBrand,
                product_detail_quantity: widget.productQuantity,
                product_detail_seller: widget.productSeller,
                product_detail_id: widget.productID,
                product_detail_type: widget.productType,
                product_detail_rating: widget.productRating,
                mobile_storage: widget.productStorage,
                mobile_battery: widget.productBattery,
                mobile_camera: widget.productCamera,
                mobile_memory: widget.productMemory,
                mobile_os: widget.productOS,
                rate1star: widget.rate1star,
                rate2star: widget.rate2star,
                rate3star: widget.rate3star,
                rate4star: widget.rate4star,
                rate5star: widget.rate5star,
              ),
            ),
          );
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

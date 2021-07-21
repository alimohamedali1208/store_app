import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../ProductDetails.dart';
import '../productClass.dart';

/*

* */
class DiscountProductsView extends StatelessWidget {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180.0,
      child: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collectionGroup('Products')
            .where('Discount', isEqualTo: 'true')
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
              productInfo.color = product.data()['Color'];
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
                productInfo.memoryUnit = product.data()['Memory Unit'];
                productInfo.camera = product.data()['Camera'];
                productInfo.os = product.data()['OS'];
                productInfo.screenSize = product.data()['Screen Size'];
                productInfo.storageUnit = product.data()['Storage Unit'];
              } else if (productInfo.type == 'Laptops') {
                productInfo.storage = product.data()['Storage'];
                productInfo.storageUnit = product.data()['Storage Unit'];
                productInfo.battery = product.data()['Battery'];
                productInfo.memory = product.data()['Memory'];
                productInfo.os = product.data()['OS'];
                productInfo.screenSize = product.data()['ScreenSize'];
                productInfo.cpu = product.data()['CPU'];
                productInfo.gpu = product.data()['GPU'];
              }else if (productInfo.type == 'Cameras') {
                productInfo.megapixel = product.data()['Mega Pixel'];
                productInfo.screenType = product.data()['Screen Type'];
                productInfo.opticalzoom = product.data()['Optical Zoom'];
                productInfo.cameratype = product.data()['Camera Type'];
                productInfo.screenSize = product.data()['Screen Size'];
              }else if (productInfo.type == 'CameraAccessories' || productInfo.type == 'OtherPC') {
                productInfo.accessoryType = product.data()['AccessoryType'];
              }else if (productInfo.type == 'Fridges') {
                productInfo.weight = product.data()['Weight'];
                productInfo.width = product.data()['Width'];
                productInfo.depth = product.data()['Depth'];
                productInfo.height = product.data()['Height'];
                productInfo.material = product.data()['Material'];
              } else if (productInfo.type == 'AirConditioner') {
                productInfo.weight = product.data()['Weight'];
                productInfo.width = product.data()['Width'];
                productInfo.depth = product.data()['Depth'];
                productInfo.conditionerType = product.data()['Conditioner Type'];
                productInfo.horsePower = product.data()['Horse Power'];
              } else if (productInfo.type == 'TV') {
                productInfo.weight = product.data()['Weight'];
                productInfo.width = product.data()['Width'];
                productInfo.depth = product.data()['Depth'];
                productInfo.screenSize = product.data()['Screen Size'];
                productInfo.screenType = product.data()['Screen Type'];
                productInfo.screenRes = product.data()['Screen Resolution'];
                productInfo.tvType = product.data()['Category Type'];
              } else if (productInfo.type == 'OtherHome') {
                productInfo.weight = product.data()['Weight'];
                productInfo.width = product.data()['Width'];
                productInfo.depth = product.data()['Depth'];
                productInfo.height = product.data()['Height'];
              } else if (productInfo.type == 'Jewelry') {
                productInfo.metalType = product.data()['Metal Type'];
                productInfo.targetGroup = product.data()['Target Group'];
              }else if (productInfo.type == 'Projectors') {
                productInfo.projectorType = product.data()['Projector Type'];
              }else if (productInfo.type == 'Printers') {
                productInfo.printerType = product.data()['Printer Type'];
                productInfo.paperSize = product.data()['Paper Type'];
              }else if (productInfo.type == 'StorageDevices') {
                productInfo.storageType = product.data()['Storage Type'];
                productInfo.storageUnit = product.data()['Capacity'];
              }else if (productInfo.type == 'Fashion') {
                productInfo.clothType = product.data()['Clothing Type'];
                productInfo.ClothSize = product.data()['Size'];
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

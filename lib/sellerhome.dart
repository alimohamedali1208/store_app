import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:store_app/EditPages/editAirConditioner.dart';
import 'package:store_app/EditPages/editCameraAccessory.dart';
import 'package:store_app/EditPages/editCameras.dart';
import 'package:store_app/EditPages/editElectronics.dart';
import 'package:store_app/EditPages/editFashion.dart';
import 'package:store_app/EditPages/editFridge.dart';
import 'package:store_app/EditPages/editHomeAppliances.dart';
import 'package:store_app/EditPages/editJewelary.dart';
import 'package:store_app/EditPages/editLaptop.dart';
import 'package:store_app/EditPages/editMobile.dart';
import 'package:store_app/EditPages/editPCAccessories.dart';
import 'package:store_app/EditPages/editPrinter.dart';
import 'package:store_app/EditPages/editProjector.dart';
import 'package:store_app/EditPages/editStorageDevice.dart';
import 'package:store_app/EditPages/editTV.dart';
import 'package:store_app/Home.dart';
import 'package:store_app/UserSeller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_app/addCategory.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'SellerEditProfile.dart';

class sellerhome extends StatefulWidget {
  static String id = 'sellerHome';
  @override
  _sellerhomeState createState() => _sellerhomeState();
}

class _sellerhomeState extends State<sellerhome> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  UserSeller seller = UserSeller();
  String name;
  int price;
  String picURL;

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to sign out?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () {
                  _auth.signOut();
                  Navigator.pushNamed(context, Home.id);
                  seller.lastName = 'temp';
                  seller.firstName = 'temp';
                },
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: AppBar(
            title: Column(
              children: [
                SizedBox(height: 30),
                Text(seller.firstName),
              ],
            ),
            centerTitle: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
            backgroundColor: Color(0xFF731800),
            actions: <Widget>[],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(seller.firstName + ' ' + seller.lastName),
                accountEmail: Text(_auth.currentUser.email),
                currentAccountPicture: GestureDetector(
                  child: new CircleAvatar(
                    backgroundColor: Colors.black12,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                ),
                decoration: new BoxDecoration(color: Color(0xFF731800)),
              ),
              InkWell(
                onTap: () {},
                child: ListTile(
                  title: Text('Home Page'),
                  leading: Icon(Icons.home, color: Colors.black),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SellerEditProfile()));
                },
                child: ListTile(
                  title: Text('Edit Profile'),
                  leading: Icon(Icons.person, color: Colors.black),
                ),
              ),
              InkWell(
                child: ListTile(
                  onTap: () {},
                  title: Text('Edit Products'),
                  leading: Icon(Icons.help, color: Colors.black),
                ),
              ),
              Divider(color: Colors.black),
              InkWell(
                child: ListTile(
                  onTap: () {},
                  title: Text('Settings'),
                  leading: Icon(Icons.settings, color: Colors.black),
                ),
              ),
              InkWell(
                child: ListTile(
                  onTap: () {
                    _auth.signOut();
                    Navigator.pushNamed(context, Home.id);
                    seller.lastName = 'temp';
                    seller.firstName = 'temp';
                  },
                  title: Text('Log out'),
                  leading: Icon(Icons.logout, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collectionGroup('Products').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Text('no products available');
            else {
              final products = snapshot.data.docs;
              List<SingleProduct> productsview = [];
              for (var product in products) {
                if (_auth.currentUser.uid == product.data()['SellerID']) {
                  final productname = product.data()['Product Name'];
                  final productprice = product.data()['Price'].toString();
                  final productimg = product.data()['imgURL'];
                  final producttype = product.data()['type'];
                  final productrate = product.data()['Rating'];
                  final productid = product.id;
                  final productview = SingleProduct(
                    productName: productname,
                    productPrice: productprice,
                    productImg: productimg,
                    productType: producttype,
                    productID: productid,
                    productRating: productrate,
                  );
                  productsview.add(productview);
                }
              }
              return ListView(
                children: productsview,
              );
            }
          },
        ),
        bottomNavigationBar: ConvexButton.fab(
            icon: Icons.add,
            color: Colors.white,
            backgroundColor: Color(0xFF731800),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => addCategory()));
            }),
      ),
    );
  }
}

class SingleProduct extends StatelessWidget {
  final String productName;
  final String productPrice;
  final String productImg;
  final String productType;
  final String productID;
  final int productRating;

  SingleProduct(
      {this.productName,
      this.productPrice,
      this.productImg,
      this.productID,
      this.productType,
      this.productRating});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        //    ======= the leading image section =======
        leading: FadeInImage.assetNetwork(
          placeholder: 'images/PlaceHolder.gif',
          image: (productImg == null)
              ? "https://firebasestorage.googleapis.com/v0/b/store-cc25c.appspot.com/o/uploads%2FPlaceHolder.gif?alt=media&token=89558fba-e8b6-4b99-bcb7-67bf1412a83a"
              : productImg,
          height: 80,
          width: 80,
        ),
        title: Text(productName),
        subtitle: Column(
          children: <Widget>[
            //  ======= this for price section ======
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                "${productPrice} EGP",
                style: TextStyle(color: Colors.red),
              ),
            ),
            Row(
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    // ignore: unrelated_type_equality_checks
                    if (productType == 'Laptops') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => editLaptops()));
                    } else if (productType == 'AirConditioner') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => editAirConditioner()));
                    } else if (productType == 'Cameras') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => editCameras()));
                    } else if (productType == 'CameraAccessories') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => editCameraAccessory()));
                    } else if (productType == 'CameraAccessories') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => editCameraAccessory()));
                    } else if (productType == 'OtherElectronics') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => editElectronics()));
                    } else if (productType == 'Fashion') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => editFashion()));
                    } else if (productType == 'Fridges') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => editFridge()));
                    } else if (productType == 'Jewelry') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => editJewelary()));
                    } else if (productType == 'Mobiles') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => editMobile()));
                    } else if (productType == 'OtherHome') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => editHomeAppliances()));
                    } else if (productType == 'OtherPC') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => editPCAccessories()));
                    } else if (productType == 'Printers') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => editPrinter()));
                    } else if (productType == 'Projectors') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => editProjector()));
                    } else if (productType == 'StorageDevice') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => editStorageDevice()));
                    } else if (productType == 'TV') {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => editTV()));
                    }
                  },
                  child: Text('Edit'),
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
                SizedBox(
                  width: 10,
                ),
                FlatButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('ProductsCollection')
                        .doc(productType)
                        .collection('Products')
                        .doc(productID)
                        .delete();
                    Reference firebaseStorageRef =
                        FirebaseStorage.instance.ref();
                    firebaseStorageRef
                        .child(
                            "ProductImage/$productType/$productID/$productName")
                        .delete()
                        .whenComplete(() => print('delelet success'));
                  },
                  child: Text('Delete'),
                  color: Colors.red,
                  textColor: Colors.white,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                  height: 40,
                  width: 80,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$productRating',
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
              ],
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:store_app/Cart.dart';
import 'login.dart';
// my own imports
import 'package:store_app/components/horizoontal_list_view.dart';
import 'package:store_app/components/Product.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Widget image_carusel = new Container(
      height: 200.0,
      child: Carousel(
        boxFit: BoxFit.cover,
        images: [
          AssetImage("images/mobiles.jpg"),
          AssetImage("images/home.jpg"),
          AssetImage("images/laptop.jpg"),
          AssetImage("images/tv.jpg"),
          AssetImage("images/watches.jpg"),
          AssetImage("images/clothes.jpg"),
        ],
        autoplay: false,
        animationCurve: Curves.fastOutSlowIn,
        animationDuration: Duration(microseconds: 1000),
        dotSize: 4.0,
        indicatorBgPadding: 4.0,
        dotBgColor: Colors.transparent,
      ),
    );
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        backgroundColor: Colors.blueGrey[900],
        title: Text("El Wekala"),
        actions: <Widget>[
          new IconButton(
              icon: Icon(Icons.search, color: Colors.white), onPressed: () {}),
          new IconButton(
              icon: Icon(Icons.shopping_cart, color: Colors.white),
              onPressed: () {
                return Navigator.push(context, MaterialPageRoute(
                    builder: (context)=> Cart()));
              }),
          IconButton(
              icon: Icon(Icons.account_circle_sharp),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => login()));
              }),
        ],
      ),
      drawer: new Drawer(
        child: ListView(
          children: <Widget>[
            //header
            new UserAccountsDrawerHeader(
              accountName: Text('Ali'),
              accountEmail: Text('alimohamedali1208@gmail.com'),
              currentAccountPicture: GestureDetector(
                child: new CircleAvatar(
                    backgroundColor: Colors.blueGrey,
                    child: Icon(Icons.person, color: Colors.white)),
              ),
              decoration: new BoxDecoration(color: Colors.blueGrey[900]),
            ),

            //body

            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('Home Page'),
                leading: Icon(Icons.home, color: Colors.blueGrey[900]),
              ),
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('My Account'),
                leading: Icon(Icons.person, color: Colors.blueGrey[900]),
              ),
            ),
            InkWell(
              onTap: () {
                return Navigator.push(context, MaterialPageRoute(
                    builder: (context)=> Cart()));
              },
              child: ListTile(
                title: Text('My Orders'),
                leading:
                Icon(Icons.shopping_basket, color: Colors.blueGrey[900]),
              ),
            ),

            InkWell(
              child: ListTile(
                onTap: () {},
                title: Text('Categories'),
                leading: Icon(Icons.category, color: Colors.blueGrey[900]),
              ),
            ),

            InkWell(
              child: ListTile(
                onTap: () {},
                title: Text('Favorites'),
                leading: Icon(Icons.favorite, color: Colors.blueGrey[900]),
              ),
            ),
            Divider(color: Colors.black),
            InkWell(
              child: ListTile(
                onTap: () {},
                title: Text('Settings'),
                leading: Icon(Icons.settings, color: Colors.blueGrey[900]),
              ),
            ),
            InkWell(
              child: ListTile(
                onTap: () {},
                title: Text('Help'),
                leading: Icon(Icons.help, color: Colors.blueGrey[900]),
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        children: <Widget>[
          // carusel list
          image_carusel,
          // padding
          new Padding(padding: const EdgeInsets.all(8.0)),
          Text('Categories'),
          // horizontal list

          Horizontal(),
          // grid view list

          new Padding(padding: const EdgeInsets.all(14)),
          Text('Recentproducts'),
          Container(
            height: 320.0,
            child: Product(),
          )
        ],
      ),
    );
  }
}
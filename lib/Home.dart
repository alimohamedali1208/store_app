import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/services.dart';
import 'package:store_app/Cart.dart';
import 'autoSearchCompelete.dart';
import 'login.dart';
// my own imports
import 'package:store_app/components/horizoontal_list_view.dart';
import 'package:store_app/components/Product.dart';

class Home extends StatefulWidget {
  static String id = 'Home';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () {
                  SystemNavigator.pop();
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
    Widget image_carusel = new Container(
      height: 200.0,
      child: Carousel(
        boxFit: BoxFit.cover,
        images: [
          //AssetImage("images/mobiles.jpg"),
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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: AppBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
            backgroundColor: Color(0xFF731800),
            title: Text("El Wekala"),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    return Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => autoSearchCompelete()));
                  }),
              IconButton(
                  icon: Icon(Icons.account_circle_sharp),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => login()));
                  }),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              //header
              UserAccountsDrawerHeader(
                accountName: Text('Guest'),
                accountEmail: Text(''),
                currentAccountPicture: GestureDetector(
                  child: new CircleAvatar(
                      backgroundColor: Colors.black12,
                      child: Icon(Icons.person, color: Colors.white)),
                ),
                decoration: new BoxDecoration(
                  color: Color(0xFF731800),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
              ),

              //body

              InkWell(
                onTap: () {},
                child: ListTile(
                  title: Text('Home Page'),
                  leading: Icon(Icons.home, color: Colors.black),
                ),
              ),
              InkWell(
                onTap: () {},
                child: ListTile(
                  title: Text('My Account'),
                  leading: Icon(Icons.person, color: Colors.black),
                ),
              ),

              InkWell(
                child: ListTile(
                  onTap: () {},
                  title: Text('Categories'),
                  leading: Icon(Icons.category, color: Colors.black),
                ),
              ),

              InkWell(
                child: ListTile(
                  onTap: () {},
                  title: Text('Favorites'),
                  leading: Icon(Icons.favorite, color: Colors.black),
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
                  onTap: () {},
                  title: Text('Help'),
                  leading: Icon(Icons.help, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
        resizeToAvoidBottomInset: false,
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
              child: Product(),
            )
          ],
        ),
      ),
    );
  }
}

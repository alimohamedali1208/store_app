import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/services.dart';
import 'package:store_app/components/Drawer.dart';
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
          preferredSize: Size.fromHeight(62),
          child: AppBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            backgroundColor: Color(0xFF731800),
            title: Column(
              children: [
                SizedBox(height: 5),
                Text(
                  "ElweKalA",
                  style: TextStyle(fontFamily: 'Zanzabar', fontSize: 25),
                ),
              ],
            ),
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
        drawer: MyDrawer(),
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
            Text('Recent products'),
            Container(
              child: Product(),
            )
          ],
        ),
      ),
    );
  }
}

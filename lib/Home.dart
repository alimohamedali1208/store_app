import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:store_app/components/CarouselImages.dart';
import 'package:store_app/components/discountProductsView.dart';
import 'package:store_app/components/recentProductsView.dart';
import 'autoSearchCompelete.dart';
import 'login.dart';
import 'package:store_app/components/horizoontal_list_view.dart';

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
    Widget image_carusel = CarouselImages();
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          backgroundColor: Color(0xFF731800),
          title: Text(
            "ElweKalA",
            style: TextStyle(fontFamily: 'Zanzabar', fontSize: 25),
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
        /*drawer: MyDrawer(),*/
        resizeToAvoidBottomInset: false,
        body: ListView(
          children: <Widget>[
            // carusel list
            image_carusel,
            // padding
            new Padding(padding: const EdgeInsets.all(8.0)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Categories',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // horizontal list

            Horizontal(),
            // grid view list

            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Recently Added ',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            Container(
              child: RecenProductsView(),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text('Hot Deals ',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      )),
                  Image.asset("images/fire.png", width: 30.0, height: 25.0),
                ],
              ),
            ),
            Container(
              child: DiscountProductsView(),
            ),
          ],
        ),
      ),
    );
  }
}

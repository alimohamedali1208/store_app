import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
    );
  }
}

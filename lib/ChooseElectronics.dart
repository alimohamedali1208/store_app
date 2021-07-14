import 'package:flutter/material.dart';
import 'package:store_app/addElectronics.dart';
import 'package:store_app/addProjector.dart';

import 'UserSeller.dart';

class ChooseElectronics extends StatefulWidget {
  @override
  _ChooseElectronicsState createState() => _ChooseElectronicsState();
}

class _ChooseElectronicsState extends State<ChooseElectronics> {
  UserSeller seller = UserSeller();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Electronics"),
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        backgroundColor: Color(0xFF731800),
      ),
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    child: productCard(
                      img: 'images/Projector2.png',
                      categoryName: 'Projector',
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => addProjector()));
                    },
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    child: productCard(
                      img: 'images/toaster.png',
                      categoryName: 'Other',
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => addElectronics()));
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class productCard extends StatelessWidget {
  productCard({@required this.img, this.categoryName});

  final String img;

  final String categoryName;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      child: Column(
        children: [
          Expanded(child: Image.asset(img)),
          Text(categoryName),
        ],
      ),
    );
  }
}

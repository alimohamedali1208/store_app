import 'package:flutter/material.dart';
import 'package:store_app/ChooseElectronics.dart';
import 'package:store_app/ChooseHomeAppliances.dart';
import 'package:store_app/ChoosePCAccessory.dart';
import 'package:store_app/addJewelary.dart';
import 'package:store_app/addMobile.dart';
import 'package:store_app/addFashion.dart';
import 'ChooseCameras.dart';
import 'addLaptop.dart';

import 'UserSeller.dart';

class addCategory extends StatefulWidget {
  @override
  _addCategoryState createState() => _addCategoryState();
}

class _addCategoryState extends State<addCategory> {
  UserSeller seller = UserSeller();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Choose a Category"),
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
                      img: 'images/iphone12.jpg',
                      categoryName: 'Phones',
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => addMobile()));
                    },
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    child: productCard(
                      img: 'images/airconditionier.jpg',
                      categoryName: 'Home Appliances',
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChooseHomeAppliances()));
                    },
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    child: productCard(
                      img: 'images/scanner.jpg',
                      categoryName: 'PC Accessories',
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChoosePCAccessory()));
                    },
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    child: productCard(
                      img: 'images/camera.jpg',
                      categoryName: 'Cameras',
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChooseCameras()));
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    child: productCard(
                      img: 'images/dimond.jpg',
                      categoryName: 'Jewelry',
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => addJewelary()));
                    },
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    child: productCard(
                      img: 'images/Projector.png',
                      categoryName: 'Electronics',
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChooseElectronics()));
                    },
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    child: productCard(
                      img: 'images/mac.png',
                      categoryName: 'Laptops',
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => addLaptop()));
                    },
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    child: productCard(
                      img: 'images/pants.jpg',
                      categoryName: 'Fashion',
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => addFashion()));
                    },
                  ),
                ),
              ],
            ),
          )
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

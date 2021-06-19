import 'package:flutter/material.dart';
import 'package:store_app/addCamera.dart';
import 'package:store_app/addCameraAccessory.dart';

import 'UserSeller.dart';

class ChooseCameras extends StatefulWidget {
  @override
  _ChooseCamerasState createState() => _ChooseCamerasState();
}

class _ChooseCamerasState extends State<ChooseCameras> {
  UserSeller seller = UserSeller();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          title: Column(
            children: [
              SizedBox(height: 20),
              Text("Cameras"),
            ],
          ),
          centerTitle: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          backgroundColor: Color(0xFF731800),
        ),
      ),
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    child: productCard(
                      img: 'images/camera.jpg',
                      categoryName: 'Camera',
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => addCamera()));
                    },
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    child: productCard(
                      img: 'images/tripod.jpg',
                      categoryName: 'Camera Accessories',
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => addCameraAccessory()));
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

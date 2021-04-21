import 'package:flutter/material.dart';
import 'package:store_app/addCamera.dart';
import 'package:store_app/addCameraAccessory.dart';
import 'package:store_app/addElectronics.dart';
import 'package:store_app/addProjector.dart';

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
      appBar: AppBar(
        title: Text('Add Cameras'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900],
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
                      img: 'images/toaster.png',
                      categoryName: 'Other',
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

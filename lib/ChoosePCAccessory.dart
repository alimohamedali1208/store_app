import 'package:flutter/material.dart';
import 'package:store_app/addPCAccessories.dart';
import 'package:store_app/addPrinter.dart';
import 'package:store_app/addStorageDevice.dart';

import 'UserSeller.dart';

class ChoosePCAccessory extends StatefulWidget {
  @override
  _ChoosePCAccessoryState createState() => _ChoosePCAccessoryState();
}

class _ChoosePCAccessoryState extends State<ChoosePCAccessory> {
  UserSeller seller = UserSeller();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('PC Accessory'),
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
                      img: 'images/usb.png',
                      categoryName: 'Storage Device',
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => addStorageDevice()));
                    },
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    child: productCard(
                      img: 'images/scanner.jpg',
                      categoryName: 'Printer',
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => addPrinter()));
                    },
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    child: productCard(
                      img: 'images/keyboard.png',
                      categoryName: 'Other',
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => addPCAccessories()));
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

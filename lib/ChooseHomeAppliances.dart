import 'package:flutter/material.dart';
import 'package:store_app/addAirConditioner.dart';
import 'package:store_app/addFridge.dart';
import 'package:store_app/addHomeAppliances.dart';
import 'package:store_app/addTV.dart';
import 'UserSeller.dart';

class ChooseHomeAppliances extends StatefulWidget {
  @override
  _ChooseHomeAppliancesState createState() => _ChooseHomeAppliancesState();
}

class _ChooseHomeAppliancesState extends State<ChooseHomeAppliances> {
  UserSeller seller = UserSeller();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Home Appliances"),
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
                      img: 'images/fridge.png',
                      categoryName: 'Fridge',
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => addFridge()));
                    },
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    child: productCard(
                      img: 'images/airconditionier.jpg',
                      categoryName: 'Air Conditioner',
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => addAirConditioner()));
                    },
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    child: productCard(
                      img: 'images/TV.png',
                      categoryName: 'TV',
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => addTV()));
                    },
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    child: productCard(
                      img: 'images/washing.png',
                      categoryName: 'Other',
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => addHomeAppliances()));
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

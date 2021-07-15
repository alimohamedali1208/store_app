import 'package:flutter/material.dart';
import 'package:store_app/CategoryPages/CamerasCategoryPage.dart';
import 'package:store_app/CategoryPages/ElectronicsCategoryPage.dart';
import 'package:store_app/CategoryPages/FashionCategoryPage.dart';
import 'package:store_app/CategoryPages/HomeAppliancesCategoryPage.dart';
import 'package:store_app/CategoryPages/JewelryCategoryPage.dart';
import 'package:store_app/CategoryPages/LaptopCategoryPage.dart';
import 'package:store_app/CategoryPages/MobileCategoryPage.dart';
import 'package:store_app/CategoryPages/PCAccesoriesCategoryPage.dart';
import 'package:store_app/MobileCatSearch.dart';
import 'package:store_app/SearchPages/LaptopCatSearch.dart';

/*

* */
class Horizontal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => mobileCategoryPage()));
            },
            child: Category(
              image_location: 'icons/mobile.png',
              image_caption: 'Mobiles',
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => laptopCategorypage()));
            },
            child: Category(
              image_location: 'icons/laptop.png',
              image_caption: 'Laptops',
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => homeAppliancesCategoryPage()));
            },
            child: Category(
              image_location: 'icons/stove.png',
              image_caption: 'Appliances',
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => pcAccessoriesCategoryPage()));
            },
            child: Category(
              image_location: 'icons/flashDrive.png',
              image_caption: 'PC Accessories',
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => electronicsCategoryPage()));
            },
            child: Category(
              image_location: 'icons/electronics.png',
              image_caption: 'Electronics',
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => camerasCategoryPage()));
            },
            child: Category(
              image_location: 'icons/camera.png',
              image_caption: 'Cameras',
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => jewelryCategoryPage()));
            },
            child: Category(
              image_location: 'icons/Ring.png',
              image_caption: 'Jewellery ',
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => fashionCategoryPage()));
            },
            child: Category(
              image_location: 'icons/shirt.png',
              image_caption: 'Fashion',
            ),
          ),
        ],
        //addAutomaticKeepAlives: false,
      ),
    );
  }
}

class Category extends StatelessWidget {
  final String image_location;
  final String image_caption;

  Category({this.image_location, this.image_caption});

  //Image.asset(image_location, width: 100.0, height: 80.0),
  /*
  * Container(

              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(image_caption,
                    style:
                        TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold)),
              ),
            )
            * */
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.grey[300]),
          width: 130.0,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                ),
                child: Image.asset(image_location, width: 100.0, height: 80.0),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(image_caption,
                    style:
                        TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)),
              ),
            ],
          )),
    );
  }
}

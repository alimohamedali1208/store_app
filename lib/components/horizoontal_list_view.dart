import 'package:flutter/material.dart';

class Horizontal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 115.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Category(
            image_location: 'images/tablets.jpg',
            image_caption: 'Mobiles',
          ),
          Category(
            image_location: 'images/cooker.jpg',
            image_caption: 'Appliances',
          ),
          Category(
            image_location: 'images/usb.jpg',
            image_caption: 'PC Accessories',
          ),
          Category(
            image_location: 'images/projector.jpg',
            image_caption: 'Electronics',
          ),
          Category(
            image_location: 'images/rings.jpg',
            image_caption: 'Jewelary',
          ),
          Category(
            image_location: 'images/pants.jpg',
            image_caption: 'Fashion',
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: InkWell(
        onTap: () {},
        child: Container(
          width: 100.0,
          child: ListTile(
              title: Image.asset(image_location, width: 100.0, height: 80.0),
              subtitle: Container(
                alignment: Alignment.topCenter,
                child:
                    Text(image_caption, style: new TextStyle(fontSize: 12.0)),
              )),
        ),
      ),
    );
  }
}

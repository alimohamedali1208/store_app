import 'package:flutter/cupertino.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';

class CarouselImages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        height: 200.0,
        child: Carousel(
          boxFit: BoxFit.cover,
          images: [
            //AssetImage("images/mobiles.jpg"),
            AssetImage("images/home.png"),
            AssetImage("images/laptops.jpg"),
            AssetImage("images/tvs.png"),
            AssetImage("images/watches.jpg"),
            AssetImage("images/clothes.jpg"),
          ],
          autoplay: true,
          animationCurve: Curves.easeIn,
          animationDuration: Duration(microseconds: 10000),
          borderRadius: true,
          radius: Radius.circular(20),
          dotSize: 10.0,
          indicatorBgPadding: 4.0,
          dotBgColor: Colors.transparent,
        ),
      ),
    );
    ;
  }
}

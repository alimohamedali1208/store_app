import 'package:flutter/material.dart';

class ProductDetails extends StatefulWidget {
  final product_detail_name;
  final product_detail_new_price;
  //final product_detail_old_price;
  final product_detail_picture;
  final String product_detail_desc;
  final String product_detail_brand;
  final String product_detail_quantity;
  final String product_detail_seller;

  const ProductDetails(
      {this.product_detail_name,
      this.product_detail_new_price,
      this.product_detail_picture,
      this.product_detail_desc,
      this.product_detail_brand,
      this.product_detail_quantity,
      this.product_detail_seller});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.grey[300],
        title: Text(widget.product_detail_name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search, color: Colors.black), onPressed: () {}),
        ],
      ),
      /*widget.product_detail_name,
      ${widget.product_detail_new_price} EGP
      ${widget.product_detail_seller}
      * */
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
        ),
        child: ListView(
          children: <Widget>[
            Container(
              height: 250,
              child: Container(
                color: Colors.white70,
                child: PhysicalModel(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  color: Colors.grey[300],
                  shape: BoxShape.rectangle,
                  child: FadeInImage.assetNetwork(
                    placeholder: 'images/PlaceHolder.gif',
                    image: (widget.product_detail_picture == null)
                        ? "https://firebasestorage.googleapis.com/v0/b/store-cc25c.appspot.com/o/uploads%2FPlaceHolder.gif?alt=media&token=89558fba-e8b6-4b99-bcb7-67bf1412a83a"
                        : widget.product_detail_picture,
                  ),
                ),
              ),
            ),
            Container(
              height: 400,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 10),
                    child: Text(
                      widget.product_detail_name,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      height: 60,
                      width: 60,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          color: Color(0xFFFFE6E6),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10))),
                      child: IconButton(
                          alignment: Alignment.center,
                          icon: (isPressed)
                              ? Icon(Icons.favorite)
                              : Icon(Icons.favorite_outline),
                          tooltip: 'Add to favorites',
                          color: Colors.red,
                          onPressed: () {
                            setState(() {
                              if (isPressed)
                                isPressed = false;
                              else
                                isPressed = true;
                            });
                          }),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10.0, right: 60, top: 10),
                    child: Text(widget.product_detail_desc),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    height: 199,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, top: 10),
                          child: Text(
                            "Seller: ${widget.product_detail_seller}",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, top: 10),
                          child: Text(
                            "price ",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 40.0, top: 1),
                          child: Text(
                            "${widget.product_detail_new_price} EGP",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                            child: FlatButton(
                          color: Color(0xFF731800),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(10),
                            top: Radius.circular(10),
                          )),
                          onPressed: () {},
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 80.0, right: 80),
                            child: Text(
                              "Add to Cart",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

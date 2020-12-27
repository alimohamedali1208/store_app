import 'package:flutter/material.dart';

class ProductDetails extends StatefulWidget {
  final product_detail_name;
  final product_detail_new_price;
  final product_detail_old_price;
  final product_detail_picture;

  const ProductDetails(
      {this.product_detail_name,
      this.product_detail_new_price,
      this.product_detail_old_price,
      this.product_detail_picture});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        backgroundColor: Colors.blueGrey[900],
        title: Text("El Wekala"),
        actions: <Widget>[
          new IconButton(
              icon: Icon(Icons.search, color: Colors.white), onPressed: () {}),
          new IconButton(
              icon: Icon(Icons.shopping_cart, color: Colors.white),
              onPressed: () {}),
        ],
      ),
      body: new ListView(
        children: <Widget>[
          new Container(
            height: 300,
            child: GridTile(
              child: Container(
                color: Colors.white70,
                child: Image.asset(widget.product_detail_picture),
              ),
              footer: new Container(
                color: Colors.white,
                child: ListTile(
                  leading: new Text(
                    widget.product_detail_name,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                  title: new Row(
                    children: <Widget>[
                      Expanded(
                        child: new Text("\$${widget.product_detail_new_price}",
                            style: TextStyle(
                              color: Colors.red,
                            )),
                      ),
                      Expanded(
                          child: new Text(
                        "\$${widget.product_detail_old_price}",
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w800,
                            decoration: TextDecoration.lineThrough),
                      )),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: <Widget>[
//======== color button ==========
              Expanded(
                  child: MaterialButton(
                onPressed: () {},
                color: Colors.grey,
                textColor: Colors.black,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: new Text("Color",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    Expanded(child: new Icon(Icons.arrow_drop_down)),
                  ],
                ),
              )),
              // ========== the qty button =========
              Expanded(
                  child: MaterialButton(
                onPressed: () {},
                color: Colors.grey,
                textColor: Colors.black,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: new Text("Quantity",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    Expanded(child: new Icon(Icons.arrow_drop_down)),
                  ],
                ),
              )),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: MaterialButton(
                  onPressed: () {},
                  color: Colors.grey,
                  textColor: Colors.black,
                  child: new Text("Buy Now",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),
              new IconButton(icon: Icon(Icons.add_shopping_cart), onPressed: (){}),
              new IconButton(icon: Icon(Icons.favorite_border), onPressed: (){})
            ],
          ),
        ],
      ),
    );
  }
}

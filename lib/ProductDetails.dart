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
      this.product_detail_picture,this.product_detail_desc,this.product_detail_brand,this.product_detail_quantity,this.product_detail_seller});

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
        ],
      ),
      body: new ListView(
        children: <Widget>[
          new Container(
            height: 300,
            child: GridTile(
              child: Container(
                color: Colors.white70,
                child: FadeInImage.assetNetwork(
                  placeholder: 'images/PlaceHolder.gif',
                  image: (widget.product_detail_picture == null)
                      ? "https://firebasestorage.googleapis.com/v0/b/store-cc25c.appspot.com/o/uploads%2FPlaceHolder.gif?alt=media&token=89558fba-e8b6-4b99-bcb7-67bf1412a83a"
                      : widget.product_detail_picture,
                ),
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
                        child: new Text("${widget.product_detail_new_price} EGP",
                            style: TextStyle(
                              color: Colors.red,
                            )),
                      ),
                      Expanded(
                          child: new Text("Seller: ${widget.product_detail_seller}",
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
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return new AlertDialog(
                          title: new Text("Color"),
                          content: new Text("Choose The Color"),
                          actions: <Widget>[
                            new MaterialButton(
                              onPressed: () {
                                Navigator.of(context).pop(context);
                              },
                              child: new Text("Close"),
                            )
                          ],
                        );
                      });
                },
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
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return new AlertDialog(
                          title: new Text("Quantity"),
                          content: new Text("Choose The Quantity"),
                          actions: <Widget>[
                            new MaterialButton(
                              onPressed: () {
                                Navigator.of(context).pop(context);
                              },
                              child: new Text("Close"),
                            )
                          ],
                        );
                      });
                },
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
              new IconButton(
                  icon: Icon(Icons.add_shopping_cart), onPressed: () {}),
              new IconButton(
                  icon: Icon(Icons.favorite_border), onPressed: () {})
            ],
          ),
          Divider(color: Colors.black87),
          new ListTile(
            title: new Text("Product Details"),
            subtitle: new Text(widget.product_detail_desc),
          ),
          new Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: new Text(
                  "Product Name",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(widget.product_detail_name),
              )
            ],
          ),
//          the brand
          new Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: new Text(
                  "Product Brand",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(widget.product_detail_brand),
              )
            ],
          ),
//             filtering the product
          new Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: new Text(
                  "product filtering",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text("product condition or filtering"),
              )
            ],
          ),
        ],
      ),
    );
  }
}

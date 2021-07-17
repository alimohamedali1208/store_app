import 'package:flutter/material.dart';

class OrderPlaced extends StatefulWidget {
  OrderPlaced(this.numOfPops);

  /*Navigator.popUntil(context, (route) {
                              return count++ == 3;
                            });*/
  int numOfPops;

  @override
  _OrderPlacedState createState() => _OrderPlacedState();
}

class _OrderPlacedState extends State<OrderPlaced> {
  void continueButtonOnPressed() {
    int count = 0;
    Navigator.popUntil(context, (route) {
      return count++ == widget.numOfPops;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "\t\t\t\t\t\t\t\t\t\t\t\t Order Placed! \n Thank You For Your Purchase!",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          Spacer(
            flex: 2,
          ),
          Flexible(
            child: ElevatedButton(
              onPressed: () {
                continueButtonOnPressed();
              },
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              child: Ink(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xFF731800), Colors.grey]),
                    borderRadius: BorderRadius.circular(20)),
                child: Container(
                  width: 200,
                  height: 50,
                  alignment: Alignment.center,
                  child: Text(
                    'Continue Shopping',
                    style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

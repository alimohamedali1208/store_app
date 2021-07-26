import 'package:flutter/material.dart';
import 'package:store_app/productClass.dart';

class sliderBoy extends StatefulWidget {
  ProductClass prd;
  sliderBoy({this.prd});


  @override
  _sliderBoyState createState() => _sliderBoyState();
}

class _sliderBoyState extends State<sliderBoy> {
  double orderedQuantity = 1;
  double max;
  double min;
  int divisions;
@override
  void initState() {
    max = double.parse(widget.prd.quantity);
    min = 1;

    if(max>=5) {
      max = 5;
      divisions = max.toInt()-1;
    }
    else if(max == 1) {
      min = 0;
      divisions = 1;
    }
    else{
      divisions = max.toInt()-1;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Choose quantity"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Max you can order is $max"),
          Slider(
            value: orderedQuantity,
            min: min,
            max: max,
            onChanged: (double value) {
              setState(() {
                orderedQuantity = value;
              });
            },
            divisions: divisions,
            label: "${orderedQuantity.toInt()}",
            activeColor: Color(0xFF731800),
            inactiveColor: Colors.grey,
          ),
          TextButton(
              onPressed: () {Navigator.of(context).pop(orderedQuantity);},
              child: Text('Confirm',
                  style: TextStyle(
                    color: Color(0xFF731800),
                  )))
        ],
      ),
    );
  }
}

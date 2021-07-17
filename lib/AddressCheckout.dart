import 'package:flutter/material.dart';
import 'package:store_app/Checkout.dart';
import 'package:store_app/OrderPlaced.dart';

class AddressCheckout extends StatefulWidget {
  @override
  _AddressCheckoutState createState() => _AddressCheckoutState();
}

enum SingingCharacter { Cash, Card }

class _AddressCheckoutState extends State<AddressCheckout> {
  SingingCharacter _paymentOption = SingingCharacter.Cash;
  final _checkoutFormKey = GlobalKey<FormState>();
  bool _validate = false;
  void toggleValidate() {
    setState(() {
      _validate = true;
    });
  }

  String validateEmpty(String value) {
    if (value.isEmpty) {
      return "This field is required";
    }
    return null;
  }

  void proceedButtonOnPressed() {
    if (_checkoutFormKey.currentState.validate()) {
      if (_paymentOption == SingingCharacter.Cash) {
        int num = 3;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => OrderPlaced(num)));
      } else if (_paymentOption == SingingCharacter.Card) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Checkout()));
      }
    } else {
      toggleValidate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        backgroundColor: Color(0xFF731800),
        elevation: 0.0,
        title: Text("Checkout"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _checkoutFormKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  autovalidate: _validate,
                  validator: validateEmpty,
                  decoration: InputDecoration(
                    labelText: "Address",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  autovalidate: _validate,
                  validator: validateEmpty,
                  decoration: InputDecoration(
                    labelText: "City",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  autovalidate: _validate,
                  validator: validateEmpty,
                  decoration: InputDecoration(
                    labelText: "Building number",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        autovalidate: _validate,
                        validator: validateEmpty,
                        decoration: InputDecoration(
                          labelText: "Floor",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        autovalidate: _validate,
                        validator: validateEmpty,
                        decoration: InputDecoration(
                          labelText: "Apartment number",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    child: ListTile(
                      title: Text("Pay in Cash"),
                      leading: Radio<SingingCharacter>(
                        value: SingingCharacter.Cash,
                        groupValue: _paymentOption,
                        onChanged: (SingingCharacter value) {
                          setState(() {
                            _paymentOption = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Flexible(
                    child: ListTile(
                      title: Text("Pay by Card"),
                      leading: Radio<SingingCharacter>(
                        value: SingingCharacter.Card,
                        groupValue: _paymentOption,
                        onChanged: (SingingCharacter value) {
                          setState(() {
                            _paymentOption = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  proceedButtonOnPressed();
                },
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                child: Ink(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xFF731800), Colors.blue]),
                      borderRadius: BorderRadius.circular(20)),
                  child: Container(
                    width: 100,
                    height: 50,
                    alignment: Alignment.center,
                    child: Text(
                      'Proceed',
                      style:
                          TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

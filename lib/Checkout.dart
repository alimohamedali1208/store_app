import 'package:awesome_card/credit_card.dart';
import 'package:awesome_card/extra/card_type.dart';
import 'package:awesome_card/style/card_background.dart';
import 'package:credit_card_validator/credit_card_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Checkout extends StatefulWidget {
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  CreditCardValidator _ccValidator = CreditCardValidator();

  final _checkoutFormKey = GlobalKey<FormState>();
  bool validate = false;

  void toggleValidate() {
    setState(() {
      validate = true;
    });
  }

  //Card variables
  String cardNumber = '';
  String cardHolderName = '';
  String expiryDate = '';
  String cvv = '';
  bool showBack = false;
  CardType cardType = CardType.other;
  FocusNode _focusNode;
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _focusNode.hasFocus ? showBack = true : showBack = false;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            CreditCard(
              cardNumber: cardNumber,
              cardExpiry: expiryDate,
              cardHolderName: cardHolderName,
              cvv: cvv,
              cardType: cardType,
              showBackSide: showBack,
              frontBackground: CardBackgrounds.black,
              backBackground: CardBackgrounds.white,
              showShadow: true,
            ),
            SizedBox(
              height: 40,
            ),
            Form(
              key: _checkoutFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(hintText: 'Card Number'),
                      maxLength: 19,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        new CustomInputFormatter()
                      ],
                      onChanged: (value) {
                        setState(() {
                          cardNumber = value;
                          if (cardNumber == "") {
                            setState(() {
                              cardType = CardType.other;
                            });
                          } else if (cardNumber.substring(0, 1) == "4") {
                            setState(() {
                              cardType = CardType.visa;
                            });
                          } else if (cardNumber.substring(0, 1) == "5") {
                            setState(() {
                              cardType = CardType.masterCard;
                            });
                          } else {
                            setState(() {
                              cardType = CardType.other;
                            });
                          }
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: TextFormField(
                      decoration:
                          InputDecoration(hintText: 'Card Expiry Month'),
                      maxLength: 5,
                      validator: validateExpDate,
                      autovalidate: validate,
                      onChanged: (value) {
                        setState(() {
                          expiryDate = value;
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(hintText: 'Card Holder Name'),
                      onChanged: (value) {
                        setState(() {
                          cardHolderName = value;
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                    child: TextFormField(
                      decoration: InputDecoration(hintText: 'CVV'),
                      maxLength: 3,
                      onChanged: (value) {
                        setState(() {
                          cvv = value;
                        });
                      },
                      focusNode: _focusNode,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF731800),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (_checkoutFormKey.currentState.validate()) {
                            Fluttertoast.showToast(
                                msg: "Order Placed!",
                                backgroundColor: Colors.black);
                            int count = 0;
                            Navigator.popUntil(context, (route) {
                              return count++ == 2;
                            });
                          } else {
                            toggleValidate();
                          }
                        },
                        child: Text(
                          "PAY",
                          style: TextStyle(fontSize: 14.0),
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String validateExpDate(String expDate) {
    var expDateResults = _ccValidator.validateExpDate(expDate);
    if (expDateResults.isPotentiallyValid) {
      return null;
    }
    return expDateResults.message;
  }
}

// text inputfromatter to add space after every 4th character in card number string
class CustomInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = new StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(
            ' '); // Replace this with anything you want to put after each 4 numbers
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: new TextSelection.collapsed(offset: string.length));
  }
}

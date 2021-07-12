import 'package:flutter/material.dart';

class AddOfferOnCategory extends StatefulWidget {
  @override
  _AddOfferOnCategoryState createState() => _AddOfferOnCategoryState();
}

class _AddOfferOnCategoryState extends State<AddOfferOnCategory> {
  final _offersFormKey = GlobalKey<FormState>();

  String validateEmpty(String value) {
    if (value.isEmpty) {
      return "This field is required";
    }
    return null;
  }

  void _toggleValidate() {
    setState(() {
      validate = !validate;
    });
  }

  //variables
  String ddCategory = "Mobiles";
  double offer;
  bool validate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add offer on category"),
          centerTitle: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          backgroundColor: Color(0xFF731800),
        ),
        body: Form(
          key: _offersFormKey,
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                    flex: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.only(top: 3, left: 5, right: 5),
                        ),
                        child: DropdownButtonHideUnderline(
                            child: DropdownButtonFormField(
                          value: ddCategory,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            labelText: "Choose Category",
                          ),
                          validator: validateEmpty,
                          onChanged: (String newValue) {
                            setState(() {
                              ddCategory = newValue;
                            });
                          },
                          items: <String>[
                            'Mobiles',
                            'Printers',
                            'Laptops',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        )),
                      ),
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Flexible(
                    flex: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        //if we wnat to toggle validaton
                        //autovalidate: validate,
                        validator: validateEmpty,
                        decoration: InputDecoration(
                          labelText: 'Offer',
                          hintText: "Enter an offer value",
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) {
                          offer = double.parse(value.trim());
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                color: Color(0xFF731800),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                  top: Radius.circular(30),
                )),
                child: Text(
                  'Add product',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (_offersFormKey.currentState.validate()) {
                    _offersFormKey.currentState.save();

                    Navigator.pop(context);
                  } else {
                    _toggleValidate();
                  }
                },
              ),
            ))));
  }
}

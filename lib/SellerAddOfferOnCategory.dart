import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:store_app/UserSeller.dart';

class AddOfferOnCategory extends StatefulWidget {
  @override
  _AddOfferOnCategoryState createState() => _AddOfferOnCategoryState();
}

class _AddOfferOnCategoryState extends State<AddOfferOnCategory> {
  final _offersFormKey = GlobalKey<FormState>();

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Color(0xFF731800);
  }

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
  String ddCategory = UserSeller.typeList.first;
  int offer;
  bool validate = false;
  bool isChecked = false;

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
                          autovalidate: validate,
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
                              print(ddCategory);
                            });
                          },
                          items: UserSeller.typeList
                              .map<DropdownMenuItem<String>>((var value) {
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
                        keyboardType: TextInputType.number,
                        maxLines: null,
                        //if we wnat to toggle validaton
                        //autovalidate: validate,
                        validator: validateEmpty,
                        enableInteractiveSelection: false,
                        inputFormatters: [
                          WhitelistingTextInputFormatter(RegExp("[0-9]")),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Offer',
                          hintText: "Enter an offer value",
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) {
                          offer = int.parse(value.trim());
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                      flex: 1,
                      child: Text(
                        "Notify customers via email",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      )),
                  Flexible(
                    flex: 1,
                    child: Checkbox(
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.resolveWith(getColor),
                      value: isChecked,
                      onChanged: (bool value) {
                        setState(() {
                          isChecked = value;
                        });
                      },
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
                  'Add offer',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (_offersFormKey.currentState.validate()) {
                    _offersFormKey.currentState.save();
                    print("$ddCategory  $offer  $isChecked");
                    Navigator.pop(context);
                  } else {
                    _toggleValidate();
                  }
                },
              ),
            ))));
  }
}

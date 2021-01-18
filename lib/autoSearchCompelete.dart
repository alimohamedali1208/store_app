import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:store_app/searchService.dart';

class autoSearchCompelete extends StatefulWidget {
  @override
  _autoSearchCompeleteState createState() => _autoSearchCompeleteState();
}

class _autoSearchCompeleteState extends State<autoSearchCompelete> {
  TextEditingController textEditingController = TextEditingController();
  final database = FirebaseFirestore.instance;
  String searchString;

  var queryResultSet = [];
  var tempSearchStore = [];
  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet=[];
        tempSearchStore=[];
      });
    }
    var capitalizedValue=value.substring(0,1).toUpperCase()+value.substring(1);
    if(queryResultSet.length==0&& value.length==1){
      SearchService().searchByName(value).then((QuerySnapshot docs){
        for(int i=0;i<docs.docs.length;++i){
          queryResultSet.add(docs.docs[i].data);
        }
      });
    }
    else {
        tempSearchStore=[];
        queryResultSet.forEach((element) {
          if(element['searchKey'].startsWith(capitalizedValue)){
            setState(() {
              tempSearchStore.add(element);
            });
          }
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('fireStore Search'),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                onChanged: (val){
                  initiateSearch(val);
                },
                decoration: InputDecoration(
                  prefixIcon: IconButton (
                    color: Colors.black,
                    icon: Icon(Icons.arrow_back),
                    iconSize: 20.0,
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                  ),
                  contentPadding:EdgeInsets.only(left: 25.0),
                  hintText:'Search By Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0)
                  )
                ),
              ),
          ),
          SizedBox(height: 10.0,),
          GridView.count(
            padding: EdgeInsets.only(left: 10.0,right: 10.0) ,
            crossAxisCount: 2,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
            primary: false,
            shrinkWrap: true,
            children: tempSearchStore.map((element) {
              return buileResultCard(element);
            }).toList()
          )

        ],
      ),
    );
  }

  Widget buileResultCard(element) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 2.0,
      child: Container(
        child: Center(
          child: Text(element['searchKey'],
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}

// return Scaffold(
// body: Column(
// children: <Widget>[
// Expanded(
// child: Column(
// children: <Widget>[
// Padding(
// padding: const EdgeInsets.all(15.0),
// child: Container(
// child: TextField(
// onChanged: (val) {
// setState(() {
// searchString = val.toLowerCase();
// });
// },
// controller: textEditingController,
// decoration: InputDecoration(
// suffixIcon: IconButton(
// icon: Icon(Icons.clear),
// onPressed: () => textEditingController.clear(),
// ),
// hintText: 'search names here',
// hintStyle:
// TextStyle(fontFamily: 'Arial', color: Colors.black)),
// ),
// ),
// ),
// Expanded(
// child: StreamBuilder<QuerySnapshot>(
// stream: (searchString == null || searchString.trim() == '')
// ? FirebaseFirestore.instance
//     .collection('Sellers')
// .snapshots()
//     : FirebaseFirestore.instance
//     .collection('Sellers')
// .where('FirstName', arrayContains: searchString)
// .snapshots(),
// builder: (context, snapshot) {
// if (snapshot.hasError) {
// return Text('we got error ${snapshot.error}');
// }
// switch (snapshot.connectionState) {
// case ConnectionState.waiting:
// return SizedBox(
// child: Center(child: Text('waiting')));
//
// case ConnectionState.none:
// return Text('no such a data');
//
// case ConnectionState.done:
// return Text('we are done');
//
// default:
// return new ListView(
// children: snapshot.data.docs
//     .map((DocumentSnapshot document) {
// return new ListTile(
// title: Text(document['Sellers']));
// }).toList(),
// );
// }
// })),
// ],
// ))
// ],
// ));
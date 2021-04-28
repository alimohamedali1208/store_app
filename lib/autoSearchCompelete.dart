import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:store_app/searchService.dart';

class autoSearchCompelete extends StatefulWidget {
  @override
  _autoSearchCompeleteState createState() => _autoSearchCompeleteState();
}

class _autoSearchCompeleteState extends State<autoSearchCompelete> {
  final database = FirebaseFirestore.instance;
  String searchString ='';
  final TextEditingController _addNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Search'),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Column(
        children: [
          Expanded(
                child: Column(
                  children: [
                    TextField(
                      onChanged: (val) {
                        setState(() {
                          searchString = val.toLowerCase().trim();
                        });
                      },
                      decoration: InputDecoration(
                          prefixIcon: IconButton(
                            color: Colors.black,
                            icon: Icon(Icons.arrow_back),
                            iconSize: 20.0,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          contentPadding: EdgeInsets.only(left: 25.0),
                          hintText: 'Search By Name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0))),
                    ),
                    Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                      stream:FirebaseFirestore.instance
                              .collectionGroup('Products')
                              .where('searchIndex', arrayContains: searchString)
                              .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError)
                          return Text('Error: ${snapshot.error}');
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Center(child: CircularProgressIndicator());
                          default:
                            return new ListView(
                              children: snapshot.data.docs
                                  .map((DocumentSnapshot document) {
                                return new ListTile(
                                  title: new Text(document['Product Name']),
                                );
                              }).toList(),
                            );
                        }
                      },
                    )),
                  ],
                ),
              ),
        ],
      ),
    );
  }

}

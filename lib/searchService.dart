import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  searchByName(String searchField) {
    print('searchbyname');
    return FirebaseFirestore.instance
        .collectionGroup('Products')
        .where('SearchKey',
            isEqualTo: searchField.substring(0, 1).toUpperCase())
        .get();
  }
}

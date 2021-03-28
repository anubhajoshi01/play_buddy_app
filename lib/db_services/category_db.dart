import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryDb{

  //handles categories saved

  static Set<String> categoryList = new Set();
  static Map<String, String> imageUrl = new Map();
  static Map<String, Set<int>> categoryMap = new Map();

  static final firestoreInstance = Firestore.instance;

  static Future<void> readDb() async{
    try {
      await firestoreInstance.collection("Categories").getDocuments().then((
          value) {
        value.documents.forEach((element) {
          var data = element.data;
          String name = data["name"];
          String url = data["url"];
          categoryList.add(name);
          imageUrl[name] = url;
          categoryMap[name] = new Set<int>();
        });
      });
    }catch(e){
      print(e.toString());
    }
  }
}
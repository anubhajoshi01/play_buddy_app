
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frc_challenge_app/db_services/email_db.dart';
import 'package:frc_challenge_app/models/user.dart';

class UserDb{

  static Map<int, User> userMap = new Map<int, User>();
  static Set<int> userIdList = new Set<int>();
  static final firestoreInstance = Firestore.instance;

  static Future<void> syncUserMap() async{
    print("syncing");
    try {
      await firestoreInstance.collection("Users").getDocuments().then((value) {
        value.documents.forEach((element) {
          var data = element.data;
          int id = int.parse(data["id"]);
          String email = data["email"];
          Set<int> friendsUserIdList = stringToSet(data["friendsUserIdList"]);
          Set<int> postIdList = stringToSet(data["postIdList"]);
          String name = data["name"];
          String bio = data["bio"];

          User u = new User(
              id, email, friendsUserIdList, postIdList, name, bio);
          print("data: $id , $email, $name $bio");
          userIdList.add(id);
          userMap[id] = u;
          EmailDb.emailMap[email] = id;
        });
      });
    }catch(e){
      print("error : ${e.toString()}");
    }
  }

  static Future<void> writeToDb(String email) async{
    await syncUserMap();
    int id = userIdList.length;
    print(id);
    await firestoreInstance.collection("Users").document("$id").setData({
      "id" : "$id",
      "email" : email,
      "friendsUserIdList": "",
      "postIdList": "",
      "name": "",
      "bio": ""
    });
    await syncUserMap();

  }

  static Future<void> updateData(int userId,  {Set<int> friendsUserIdList, Set<int> postIdList, String name, String bio}) async{
    if(friendsUserIdList != null){
      userMap[userId].friendsUserIdList = friendsUserIdList;
    }
    if(postIdList != null){
      userMap[userId].postIdList = postIdList;
    }
    if(name != null){
      userMap[userId].name = name;
    }
    if(bio != null){
      userMap[userId].bio = bio;
    }

    try{
     await firestoreInstance.collection("Users").document("$userId").updateData({
       "friendsUserIdList" : setToString(userMap[userId].friendsUserIdList),
       "postIdList" : setToString(userMap[userId].postIdList),
       "name" : userMap[userId].name,
       "bio" : userMap[userId].bio
     });
    }
    catch(e){
      print(e.toString());
    }
  }

  static String setToString(Set<int> set){
    String s = "";
    set.forEach((element) {
      s += "$element";
    });
    s.trim();
    return s;
  }

  static Set<int> stringToSet(String set){
    if(set.length == 0){
      return Set<int>();
    }
    List<String> list = set.split(" ");
    Set<int> intset = Set<int>();
    list.forEach((element) {
      intset.add(int.parse(element));
    });
    return intset;
  }

}
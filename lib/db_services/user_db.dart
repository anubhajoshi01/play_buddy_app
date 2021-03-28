import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frc_challenge_app/db_services/email_db.dart';
import 'package:frc_challenge_app/models/user.dart';

class UserDb {
  static Map<int, User> userMap = new Map<int, User>();
  static Set<int> userIdList = new Set<int>();
  static final firestoreInstance = Firestore.instance;
  static Map<String, int> emailMap = new Map<String, int>();

  //reads data from database and saves to local map
  static Future<void> syncUserMap() async {
    print("syncing");
    try {
      await firestoreInstance.collection("Users").getDocuments().then((value) {
        value.documents.forEach((element) {
          var data = element.data;
          int id = int.parse(data["id"]);
          String email = data["email"];
          Set<int> friendsUserIdList = stringToSet(data["friendsUserIdList"]);
          Set<int> postIdList = stringToSet(data["postIdList"]);
          Set<int> requestSentList = stringToSet(data["requestSentList"]);
          Set<int> requestReceivedList =
              stringToSet(data["requestReceivedList"]);
          Set<int> postsSignedUpFor = stringToSet(data["postsSignedUpFor"]);
          String name = data["name"];
          String bio = data["bio"];

          User u = new User(id, email, friendsUserIdList, postIdList,
              requestSentList, requestReceivedList, postsSignedUpFor, name, bio);
          print("data: $id , $email, $name $bio");
          userIdList.add(id);
          userMap[id] = u;
          emailMap[email] = id;

          print("email: $email id : $id");
        });
      });
    } catch (e) {
      print("Error sync map : ${e.toString()}");
    }
  }

  //creates a new user and writes info to database
  static Future<void> writeToDb(String email, String name) async {
    await syncUserMap();
    int id = userIdList.length;
    print(id);
    await firestoreInstance.collection("Users").document("$id").setData({
      "id": "$id",
      "email": email,
      "friendsUserIdList": "",
      "postIdList": "",
      "requestSentList": "",
      "requestReceivedList": "",
      "postsSignedUpFor" : "",
      "name": name,
      "bio": ""
    });
    await syncUserMap();
  }

  //updates fields in database
  static Future<void> updateData(int userId,
      {Set<int> friendsUserIdList,
      Set<int> postIdList,
      Set<int> requestSentList,
      Set<int> requestReceivedList,
        Set<int> postsSignedUpFor,
      String name,
      String bio}) async {
    if (friendsUserIdList != null) {
      userMap[userId].friendsUserIdList = friendsUserIdList;
    }
    if (postIdList != null) {
      userMap[userId].postIdList = postIdList;
    }
    if(requestSentList != null){
      userMap[userId].requestSentList = requestSentList;
    }
    if(requestReceivedList != null){
      userMap[userId].requestReceivedList = requestReceivedList;
    }
    if(postsSignedUpFor != null){
      userMap[userId].postsSignedUpFor = postsSignedUpFor;
    }
    if (name != null) {
      userMap[userId].name = name;
    }
    if (bio != null) {
      userMap[userId].bio = bio;
    }

    try {
      await firestoreInstance
          .collection("Users")
          .document("$userId")
          .updateData({
        "friendsUserIdList": setToString(userMap[userId].friendsUserIdList),
        "postIdList": setToString(userMap[userId].postIdList),
        "requestSentList": setToString(userMap[userId].requestSentList),
        "requestReceivedList": setToString(userMap[userId].requestReceivedList),
        "postsSignedUpFor": setToString(userMap[userId].postsSignedUpFor),
        "name": userMap[userId].name,
        "bio": userMap[userId].bio
      });
    } catch (e) {
      print(e.toString());
    }

    await syncUserMap();
  }

  static String setToString(Set<int> set) {
    String s = "";
    set.forEach((element) {
      s += "$element ";
    });
    s = s.trim();
    print("set to string s $s");
    return s;
  }

  static Set<int> stringToSet(String set) {

    bool empty = (set =="");
    print("asdfasdfasdfasdf" + "$empty"+ " $set");
    if (set == null || set.isEmpty|| set.length == 0 || set == "" || set == "null") {

      return Set<int>();
    }
    List<String> list = set.split(" ");
    print("length set: ${list.length}");
    Set<int> intset = Set<int>();
    list.forEach((element) {

      int parsed;
      try {
        parsed = int.parse(element);
      }catch(e){
        print("error string to set user db ${e.toString()}");
      }
      if(parsed != null){
        intset.add(parsed);
      }

      // print("asdfsadfsadf" + "$element");


    });
    return intset;
  }
}

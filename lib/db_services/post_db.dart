import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frc_challenge_app/db_services/category_db.dart';
import 'package:frc_challenge_app/db_services/email_db.dart';
import 'package:frc_challenge_app/db_services/user_db.dart';
import 'package:frc_challenge_app/models/post.dart';
import 'package:frc_challenge_app/models/user.dart';
import 'package:frc_challenge_app/services/geolocator.dart';

class PostDb {

  //handled the database for posts

  static Map<int, Post> localMap = new Map<int, Post>();
  static Set<int> postIdList = new Set<int>();

  static final firestoreInstance = Firestore.instance;


  //creates a new document in database from information in parameters
  static Future<Post> createPost(
      int ownerUserId,
      String type,
      DateTime time,
      double lat,
      double long,
      DateTime event,
      String des,
      String address,
      String sport,
      int cap,
      ) async {
    await readDb();
    int id = postIdList.length;

    String date = "${time.day} ${time.month} ${time.year}";
    String timestamp = "${event.hour} ${event.minute}";
    final firestoreInstance = Firestore.instance;
    Set<int> usersSignedUp = Set();
    usersSignedUp.add(ownerUserId);

    await firestoreInstance.collection("Posts").document("$id").setData({
      'id': "$id",
      'ownerUserId': "$ownerUserId",
      'eventDateTime': dateTimeToString(event),
      'timeStamp': dateTimeToString(time),
      'eventDescription': des,
      'latitude': "$lat",
      'longitude': "$long",
      'address': "$address",
      'usersSignedUp': setToString(usersSignedUp),
      'postType': type,
      'active': "true",
      'category': sport,
      "cap": "$cap",
    });

    Post post = new Post(id, ownerUserId, type, time, event, des, address, lat, long, usersSignedUp, true,sport,cap);
    Set<int> postsSignedUpFor = UserDb.userMap[UserDb.emailMap[EmailDb.thisEmail]].postsSignedUpFor;
    postsSignedUpFor.add(id);
    localMap[id] = post;

    CategoryDb.categoryMap[sport].add(id);

    await UserDb.updateData(UserDb.userMap[UserDb.emailMap[EmailDb.thisEmail]].id, postsSignedUpFor: postsSignedUpFor);
    await readDb();
    print("done post create");
    return post;
  }

  //reads database and updates map that stores each entry
  static Future<void> readDb() async {
    await CategoryDb.readDb();
    try {
      await firestoreInstance.collection("Posts").getDocuments().then((value) {
        value.documents.forEach((element) async {
          var data = element.data;
          String address = data["address"];
          DateTime event = toDateTime(data["eventDateTime"]);
          String des = data["eventDescription"];
          int id = int.parse(data["id"]);
          double lat = double.parse(data["latitude"]);
          double long = double.parse(data["longitude"]);
          String usersSignedUpString = data["usersSignedUp"];
          int ownerid = int.parse(data["ownerUserId"]);
          String postType = data["postType"];
          DateTime timestamp = toDateTime(data["timeStamp"]);
          bool active = data["active"] == "true";
          String category = data["category"];
          int cap = int.parse(data["cap"]);
          Post currentPost = new Post(id, ownerid, postType, timestamp, event,
              des, address, lat, long, stringToSet(usersSignedUpString), active,category,cap);
            postIdList.add(id);
          localMap[id] = currentPost;
          List<double> latlong = new List<double>();
          latlong.add(lat);
          latlong.add(long);
          print(">>>>>>>>>>>>>>>>>> categpry $category at id $id");
          CategoryDb.categoryMap[category].add(id);
          print(">>>>>>>>>>>>>>>>>>>>>>>>>>> category added");
          await Geolocate.getDistance(id,latlong);
        });
      });
    } catch (e) {
      print("error in post sync: ${e.toString()}");
    }
  }

  //converts string to DateTime object
  static DateTime toDateTime(String str) {
    List<String> split = str.split(" ");
    print("length to date time ${split.length}");
    DateTime result = new DateTime(int.parse(split[0]), int.parse(split[1]), int.parse(split[2]), int.parse(split[3]), int.parse(split[4]));

    return result;
  }

  //updates field of a Post document in database
  static Future<void> updatePost(int id,{
      String type,
      DateTime time,
      double lat,
      double long,
      DateTime event,
      String des,
      String address,
      String category,
      int cap,
      Set<int> usersSignedUp
  }) async {if (type != null) {
      localMap[id].postType = type;
    }
    if (time != null) {
      localMap[id].eventDateTime = time;
    }
    if(lat != null){
      localMap[id].latitude = lat;
    }
    if(long != null){
     localMap[id].longitude = long;
    }
    if (event != null) {
     localMap[id].eventDateTime = event;
    }
    if (des != null) {
      localMap[id].eventDescription = des;
    } 
    if (address != null) {
      localMap[id].address = address;
    } 
    if (usersSignedUp != null && checkCap(cap, usersSignedUp)=="") {
      localMap[id].usersSignedUp = usersSignedUp;
    }
    if(category != null){
      String prev = localMap[id].category;
      CategoryDb.categoryMap[prev].remove(id);

      CategoryDb.categoryMap[category].add(id);
      localMap[id].category = category;
    }
  if (cap != null) {
    localMap[id].cap = cap;
  }

    try {
      await firestoreInstance
          .collection("Posts")
          .document("$id")
          .updateData({
        "address": localMap[id].address,
        "usersSignedUp": setToString(localMap[id].usersSignedUp),
        "eventDateTime": dateTimeToString(localMap[id].eventDateTime),
        "eventDescription": localMap[id].eventDescription,
        "latitude": "${localMap[id].latitude}",
        "longitude": "${localMap[id].longitude}",
        "postType":localMap[id].postType,
        "timeStamp": dateTimeToString(localMap[id].timestamp),
        "category": "${localMap[id].category}",
        "cap": "${localMap[id].cap}",
      });
    } catch (e) {
      print(e.toString());
    }

    await readDb();
  }

  static Future<void> deletePostFromDb(int postId) async{
    localMap[postId].active = false;
    String prevCategory = localMap[postId].category;
    CategoryDb.categoryMap[prevCategory].remove(postId);
    await firestoreInstance.collection("Posts").document("$postId").updateData({"active":"false"});
    await readDb();
  }

  static String dateTimeToString(DateTime d){
    return "${d.year} ${d.month} ${d.day} ${d.hour} ${d.minute}";
  }
  // make read method(); save each id in a set;
  static String setToString(Set<int> set) {
    String s = "";
    set.forEach((element) {
      s += "$element ";
    });
    return s;
  }

  static Set<int> stringToSet(String set) {

    if (set == null || set.isEmpty || set.length == 0 || set == "null"|| set == "") {

      return Set<int>();
    }
    List<String> list = set.split(" ");
    print("length string to set ${list.length}");
    Set<int> intset = Set<int>();
    list.forEach((element) {

      int parsed;
      try {
         parsed = int.parse(element);
      }catch(e){
        print(e.toString());
      }
      if(parsed != null){
        intset.add(parsed);
      }

    });
    return intset;
  }

  //checks event limit set
  static String checkCap (int cap, Set<int> u){
    String str;
    if(u.length < cap){
      str = "";
    }else{
      str = "This event already has enough sign up";
    }
    return str;
  }

}

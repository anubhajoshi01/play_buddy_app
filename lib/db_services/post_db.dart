import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frc_challenge_app/models/post.dart';

class PostDb {
  static Map<int, Post> localMap = new Map<int, Post>();
  static Set<int> postIdList = new Set<int>();
  static final firestoreInstance = Firestore.instance;
  
  static Future<void> createPost(
      int id,
      int ownerUserId,
      String type,
      DateTime time,
      double lat,
      double long,
      DateTime event,
      String des,
      String address,
      int numsignedup) async {
    //Post currentPost = new Post(postIdList.length, ownerUserId, type, time,
        //event, des, address, lat, long, numsignedup);
    //ocalMap[id] = currentPost;

    String date = "${time.day} ${time.month} ${time.year}";
    String timestamp = "${event.hour} ${event.minute} ${event.second}";
    final firestoreInstance = Firestore.instance;

    await firestoreInstance.collection("Posts").document("$id").setData({
      'id': "$id",
      'ownerUserId': "$ownerUserId",
      'eventDateTime': date,
      'timeStamp': timestamp,
      'eventDescription': des,
      'latitude': "$lat",
      'longitude': "$long",
      'address': "address",
      'numSignedUp': "$numsignedup",
      'postType': type,
    });
  }

  static Future<void> readDb() async {
    try {
      await firestoreInstance.collection("Posts").getDocuments().then((value) {
        value.documents.forEach((element) {
          var data = element.data;
          String address = data["address"];
          DateTime event = data["eventDateTime"].toDateTime();
          String des = data["eventDescription"];
          int id = int.parse(data["id"]);
          double lat = data["latitude"];
          double long = data["longitude"];
          int numsignedup = data["numSignedUp"];
          int ownerid = data["ownerUserId"];
          String postType = data["postType"];
          DateTime timestamp = data["timestamp"].toDateTime();
          Post currentPost = new Post(id, ownerid, postType, timestamp, event,
              des, address, lat, long, numsignedup);
          postIdList.add(id);
          localMap[id] = currentPost;
        });
      });
    } catch (e) {}
  }

  static DateTime toDateTime(String str) {
    List<String> split = str.split(" ");
    DateTime result = new DateTime(
        int.parse(split[0]), int.parse(split[1]), int.parse(split[2]));

    return result;
  }

  static Future<void> updatePost(int id, int ownerId,{
      String type,
      DateTime time,
      double lat,
      double long,
      DateTime event,
      String des,
      String address,
      int numsignedup 
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
    if (numsignedup != null) {
      localMap[id].numSignedUp = numsignedup;
    }
    try {
      await firestoreInstance
          .collection("Posts")
          .document("$id")
          .updateData({
        "address": localMap[id].address,
        "numSignedUp": localMap[id].numSignedUp,
        "eventDateTime": localMap[id].eventDateTime,
        "eventDescription": localMap[id].eventDescription,
        "latitude": localMap[id].latitude,
        "longitude": localMap[id].longitude,
        "postType":localMap[id].postType,
        "timeStamp":localMap[id].timestamp,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // make read method(); save each id in a set;
}

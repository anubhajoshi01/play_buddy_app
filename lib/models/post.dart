import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frc_challenge_app/db_services/email_db.dart';
import 'package:frc_challenge_app/models/user.dart';

class PostType {
  final String PUBLIC = "public";
  final String PRIVATE = "private";
  final String RESTRICTED = "restricted";
}

class Post {
  int id;
  int ownerUserId;
  String postType;
  DateTime timestamp;
  DateTime eventDateTime;
  String eventDescription;
  String address;
  double latitude;
  double longitude;
  Set<int> usersSignedUp;
  bool active;
  String category;
  int cap;
  
  Post(
      this.id,
      this.ownerUserId,
      this.postType,
      this.timestamp,
      this.eventDateTime,
      this.eventDescription,
      this.address,
      this.latitude,
      this.longitude,
      this.usersSignedUp,




      this.active,
      this.category,
      this.cap,);
  }



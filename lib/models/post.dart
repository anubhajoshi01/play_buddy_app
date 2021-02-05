import 'package:frc_challenge_app/models/user.dart';

class PostType {
  final String PUBLIC = "anyone can view";
  final String PRIVATE = "users can view";
  final String RESTRICTED = "friends can view";
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
  int numSignedUp;

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
      this.numSignedUp);
}

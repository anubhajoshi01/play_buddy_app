
import 'package:frc_challenge_app/models/user.dart';

class PostType{
  final String PUBLIC = "anyone can view";
  final String PRIVATE = "users can view";
  final String RESTRICTED = "friends can view";
}

class Post{

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

}

import 'package:frc_challenge_app/models/user.dart';

class UserDb{

  static Map<int, User> userMap;
  static Set<int> userIdList;

  static Future<void> writeToDb({String bio, String email, String name}){
    //generate id
    //generate friends user id list
    //generate post id list

    //create user object from given info
    //add to userMap and userIdList;
  }

  static String setToString(Set<int> set){

  }

}
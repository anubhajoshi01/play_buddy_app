
import 'package:frc_challenge_app/db_services/email_db.dart';
import 'package:frc_challenge_app/db_services/post_db.dart';
import 'package:frc_challenge_app/db_services/user_db.dart';
import 'package:frc_challenge_app/models/post.dart';

class User {
  int id;
  String email;
  Set<int> friendsUserIdList;
  Set<int> postIdList;
  Set<int> requestSentList;
  Set<int> requestReceivedList;
  Set<int> postsSignedUpFor;
  String name;
  String bio;

  User(this.id, this.email, this.friendsUserIdList, this.postIdList,
      this.requestSentList, this.requestReceivedList, this.postsSignedUpFor, this.name, this.bio);

   Set<int> getUsableEvents(){

     Set<int> events = new Set<int>();

     for(int i = 0; i < this.postIdList.length; i++){
       Post p = PostDb.localMap[postIdList.elementAt(i)];
       User thisUser = UserDb.userMap[UserDb.emailMap[EmailDb.thisEmail]];
       if(p.active && p.eventDateTime.isAfter(DateTime.now()) && (p.postType == "public" || thisUser.friendsUserIdList.contains(this.id))){
         events.add(p.id);
       }
     }

     return events;
  }
}

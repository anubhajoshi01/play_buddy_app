
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frc_challenge_app/components/bottomNavBar.dart';
import 'package:frc_challenge_app/components/common_app_bar.dart';
import 'package:frc_challenge_app/components/common_drawers.dart';
import 'package:frc_challenge_app/components/event_card_regular.dart';
import 'package:frc_challenge_app/db_services/email_db.dart';
import 'package:frc_challenge_app/db_services/post_db.dart';
import 'package:frc_challenge_app/db_services/user_db.dart';
import 'package:frc_challenge_app/models/post.dart';
import 'package:frc_challenge_app/models/user.dart';
import 'package:frc_challenge_app/screens/post_pages/display_post_screen.dart';
import 'package:frc_challenge_app/screens/post_pages/post_map_screen.dart';
import 'package:intl/intl.dart';


class ViewMyEventsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ViewMyEventsScreen();
  }
}

class _ViewMyEventsScreen extends State<ViewMyEventsScreen> {
  List<Post> myPostsList = new List<Post>();

  @override
  void initState() {
    super.initState();
    User thisUser = UserDb.userMap[UserDb.emailMap[EmailDb.thisEmail]];
    DateTime now = DateTime.now();
    for (int i = 0; i < thisUser.postIdList.length; i++) {
      Post p = PostDb.localMap[thisUser.postIdList.elementAt(i)];
      if (p.active && p.eventDateTime.isAfter(now)) {
        myPostsList.add(p);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar.appBar("My Posts", context),
      drawer: CommonDrawers.profileDrawer(context, "My Posts"),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10),

            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.7,
                child: (myPostsList.length == 0)? Text("You have not created any posts yet", style: TextStyle(fontSize:20), textAlign: TextAlign.center,):ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: myPostsList.length,
                    itemBuilder: (context, index) {
                      Post postAt = PostDb.localMap[myPostsList.elementAt(index).id];
                      String time = DateFormat('kk:mm').format(postAt.eventDateTime);
                      return Dismissible(
                        key: Key("$index"),
                        onDismissed: (direction) {
                          User thisUser = UserDb
                              .userMap[UserDb.emailMap[EmailDb.thisEmail]];
                          Set<int> myPosts = thisUser.postIdList;
                          myPosts.remove(myPostsList[index].id);
                          UserDb.updateData(thisUser.id,
                              postsSignedUpFor: myPosts);

                          PostDb.deletePostFromDb(myPostsList[index].id);
                          setState(() {
                            myPostsList.removeAt(index);
                          });
                        },
                        child: EventCardRegular(postAt),
                        background: Container(
                          color: Colors.red,
                          child: Icon(Icons.delete)
                        ),
                      );
                    })),
      ),
      bottomNavigationBar: bottomNavBar(Divisions.PROFILE),
    );
  }

  static bool checkStat(Post p, DateTime now) {
    User u = UserDb.userMap[UserDb.emailMap[EmailDb.thisEmail]];
    if (p.postType == ("public") ||
        u.friendsUserIdList.contains(p.ownerUserId) ||
        p.ownerUserId == u.id) {
      if (p.eventDateTime.isAfter(now) && p.active) {
        return true;
      }
    }
    return false;
  }
}

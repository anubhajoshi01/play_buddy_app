import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frc_challenge_app/components/common_app_bar.dart';
import 'package:frc_challenge_app/components/common_drawers.dart';
import 'package:frc_challenge_app/db_services/email_db.dart';
import 'package:frc_challenge_app/db_services/post_db.dart';
import 'package:frc_challenge_app/db_services/user_db.dart';
import 'package:frc_challenge_app/models/post.dart';
import 'package:frc_challenge_app/models/user.dart';
import 'package:frc_challenge_app/screens/post_pages/display_post_screen.dart';

class ViewSignedUpEvents extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ViewSignedUpEvents();
  }
}

class _ViewSignedUpEvents extends State<ViewSignedUpEvents> {
  List<Post> signedUpEvents = new List<Post>();

  @override
  void initState() {
    super.initState();
    User thisUser = UserDb.userMap[UserDb.emailMap[EmailDb.thisEmail]];
    for (int i = 0; i < thisUser.postsSignedUpFor.length; i++) {
      Post p = PostDb.localMap[thisUser.postsSignedUpFor.elementAt(i)];
      if(p.active) {
        signedUpEvents.add(p);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: CommonAppBar.appBar("Events Signed-Up For", context),
      drawer: CommonDrawers.profileDrawer(context),
      body: Container(
        child: ListView.builder(
            itemCount: signedUpEvents.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key("$index"),
                child: Card(
                  child: ListTile(
                    title: Text("${signedUpEvents[index].address}"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DisplayPostScreen(signedUpEvents[index])));
                    },
                  ),
                ),
                onDismissed: (direction){
                  Set<int> usersSignedUpForPost = signedUpEvents[index].usersSignedUp;
                  User thisUser = UserDb.userMap[UserDb.emailMap[EmailDb.thisEmail]];
                  usersSignedUpForPost.remove(thisUser.id);
                  PostDb.updatePost(signedUpEvents[index].id, usersSignedUp: usersSignedUpForPost);

                  Set<int> postsSignedUp = thisUser.postsSignedUpFor;
                  postsSignedUp.remove(signedUpEvents[index].id);
                  UserDb.updateData(thisUser.id, postsSignedUpFor: postsSignedUp);

                  setState(() {
                    List<Post> newPostList = new List<Post>();
                    for(int i = 0; i < thisUser.postIdList.length; i++){
                      Post p = PostDb.localMap[thisUser.postIdList.elementAt(i)];
                      if(p.active){
                        newPostList.add(p);
                      }
                    }
                    signedUpEvents = newPostList;
                  });
                },
                background: Container(color: Colors.red),
              );
            }),
      ),
    );
  }
}
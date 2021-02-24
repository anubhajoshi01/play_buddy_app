// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frc_challenge_app/components/bottomNavBar.dart';
import 'package:frc_challenge_app/components/common_app_bar.dart';
import 'package:frc_challenge_app/components/common_drawers.dart';
import 'package:frc_challenge_app/db_services/email_db.dart';
import 'package:frc_challenge_app/db_services/post_db.dart';
import 'package:frc_challenge_app/db_services/user_db.dart';
import 'package:frc_challenge_app/models/post.dart';
import 'package:frc_challenge_app/models/user.dart';
import 'package:frc_challenge_app/screens/home_pages/edit_profile_screen.dart';
import 'package:frc_challenge_app/screens/post_pages/display_post_screen.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  ProfileScreen({this.user});

  @override
  _ProfileScreen createState() {
    return _ProfileScreen();
  }
}

class _ProfileScreen extends State<ProfileScreen> {
  String name;
  String bio;
  bool isFriend;
  bool requested;
  bool requestRecieved;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    User u = UserDb.userMap[UserDb.emailMap[EmailDb.thisEmail]];
    if (this.widget.user == null) {
      name = u.name;
      bio = u.bio;
      isFriend = false;
      requested = false;
      requestRecieved = false;
    } else {
      name = this.widget.user.name;
      bio = this.widget.user.bio;
      isFriend = u.friendsUserIdList.contains(this.widget.user.id);
      requested = u.requestSentList.contains(this.widget.user.id);
      requestRecieved = u.requestReceivedList.contains(this.widget.user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar.appBar("My Profile", context),
      drawer: (this.widget.user == null)
          ? CommonDrawers.profileDrawer(context)
          : null,
      body: Container(
        child: SingleChildScrollView(
          child: Column(

            children: <Widget>[

              Container(
              padding: EdgeInsets.symmetric(vertical: 10),
            ),
              Text("Name: $name",
                style: TextStyle(fontSize: 20),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5),
              ),
              Text("Bio: $bio",
                style: TextStyle(fontSize: 20),
              ),
              (this.widget.user == null)
                  ? FlatButton(
                      child: Text("Edit"),
                      onPressed: () async {
                        final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfileScreen()));
                        setState(() {
                          List<String> split = result.split(" ");
                          name = split[0];
                          bio = split[1];
                        });
                      },
                    )
                  : (isFriend)
                      ? Container(
                          child: Column(
                          children: <Widget>[
                            Text("Posted Events:"),
                            FlatButton(
                              child: Text("Remove Friend"),
                              color: Colors.red,
                              onPressed: () async {
                                User thisUser = UserDb.userMap[
                                    UserDb.emailMap[EmailDb.thisEmail]];
                                Set<int> friendIdList =
                                    thisUser.friendsUserIdList;
                                friendIdList.remove(this.widget.user.id);
                                await UserDb.updateData(thisUser.id,
                                    friendsUserIdList: friendIdList);

                                Set<int> friendIdList2 =
                                    this.widget.user.friendsUserIdList;
                                friendIdList2.remove(thisUser.id);
                                await UserDb.updateData(this.widget.user.id,
                                    friendsUserIdList: friendIdList2);

                                setState(() {
                                  isFriend = false;
                                });
                              },
                            ),
                            SingleChildScrollView(
                                child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.5,
                                    child: ListView.builder(
                                        itemCount:
                                            this.widget.user.postIdList.length,
                                        itemBuilder: (context, index) {
                                          Post postAt = PostDb.localMap[this
                                              .widget
                                              .user
                                              .postIdList
                                              .elementAt(index)];
                                          return Card(
                                            child: ListTile(
                                              title:
                                                  Text(postAt.eventDescription),
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            DisplayPostScreen(
                                                                postAt)));
                                              },
                                            ),
                                          );
                                        })))
                          ],
                        ))
                      : (requestRecieved)
                          ? Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  FlatButton(
                                    child: Text("Accept"),
                                    color: Colors.red,
                                    onPressed: () async {
                                      User thisUser = UserDb.userMap[
                                          UserDb.emailMap[EmailDb.thisEmail]];
                                      Set<int> newRequestRecievedList =
                                          thisUser.requestReceivedList;
                                      Set<int> newFriendList =
                                          thisUser.friendsUserIdList;
                                      newFriendList.add(this.widget.user.id);
                                      newRequestRecievedList
                                          .remove(this.widget.user.id);
                                      await UserDb.updateData(thisUser.id,
                                          requestReceivedList:
                                              newRequestRecievedList,
                                          friendsUserIdList: newFriendList);

                                      Set<int> newRequestSentList =
                                          this.widget.user.requestSentList;
                                      Set<int> newFriendList2 =
                                          this.widget.user.friendsUserIdList;
                                      newRequestSentList.remove(thisUser.id);
                                      newFriendList2.add(thisUser.id);
                                      await UserDb.updateData(
                                          this.widget.user.id,
                                          requestSentList: newRequestSentList,
                                          friendsUserIdList: newFriendList2);

                                      setState(() {
                                        isFriend = true;
                                      });
                                    },
                                  ),
                                  FlatButton(
                                    child: Text("Deny"),
                                    color: Colors.red,
                                    onPressed: () async {
                                      User thisUser = UserDb.userMap[
                                          UserDb.emailMap[EmailDb.thisEmail]];
                                      Set<int> newRequestRecievedList =
                                          thisUser.requestReceivedList;
                                      newRequestRecievedList
                                          .remove(this.widget.user.id);
                                      await UserDb.updateData(thisUser.id,
                                          requestReceivedList:
                                              newRequestRecievedList);

                                      Set<int> newRequestSentList =
                                          this.widget.user.requestSentList;
                                      newRequestSentList.remove(thisUser.id);
                                      await UserDb.updateData(
                                          this.widget.user.id,
                                          requestSentList: newRequestSentList);

                                      setState(() {
                                        requestRecieved = false;
                                      });
                                    },
                                  )
                                ],
                              ),
                            )
                          : (requested)
                              ? FlatButton(
                                  child: Text("Delete Request"),
                                  color: Colors.red,
                                  onPressed: () async {
                                    User thisUser = UserDb.userMap[
                                        UserDb.emailMap[EmailDb.thisEmail]];
                                    Set<int> thisRequestsSent =
                                        thisUser.requestSentList;
                                    thisRequestsSent
                                        .remove(this.widget.user.id);
                                    await UserDb.updateData(thisUser.id,
                                        requestSentList: thisRequestsSent);

                                    Set<int> requestRecievedList =
                                        this.widget.user.requestReceivedList;
                                    requestRecievedList.remove(thisUser.id);
                                    await UserDb.updateData(this.widget.user.id,
                                        requestReceivedList:
                                            requestRecievedList);

                                    setState(() {
                                      requested = false;
                                    });
                                  },
                                )
                              : FlatButton(
                                  child: Text("Request As Friend"),
                                  color: Colors.red,
                                  onPressed: () async {
                                    User thisUser = UserDb.userMap[
                                        UserDb.emailMap[EmailDb.thisEmail]];
                                    Set<int> thisRequestsSent =
                                        thisUser.requestSentList;
                                    thisRequestsSent.add(this.widget.user.id);
                                    await UserDb.updateData(thisUser.id,
                                        requestSentList: thisRequestsSent);

                                    Set<int> requestRecievedList =
                                        this.widget.user.requestReceivedList;
                                    requestRecievedList.add(thisUser.id);
                                    await UserDb.updateData(this.widget.user.id,
                                        requestReceivedList:
                                            requestRecievedList);

                                    setState(() {
                                      requested = true;
                                    });
                                  },
                                )
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomNavBar(),
    );
  }
}

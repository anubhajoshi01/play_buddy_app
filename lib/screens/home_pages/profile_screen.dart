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
import 'package:frc_challenge_app/services/geolocator.dart';
import 'package:intl/intl.dart';

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
  User thisUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    thisUser = UserDb.userMap[UserDb.emailMap[EmailDb.thisEmail]];
    if (this.widget.user == null) {
      name = thisUser.name;
      bio = thisUser.bio;
      isFriend = false;
      requested = false;
      requestRecieved = false;
    } else {
      name = this.widget.user.name;
      bio = this.widget.user.bio;
      isFriend = thisUser.friendsUserIdList.contains(this.widget.user.id);
      requested = thisUser.requestSentList.contains(this.widget.user.id);
      requestRecieved =
          thisUser.requestReceivedList.contains(this.widget.user.id);
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
              // align the content to the left
              // alignment: Alignment.centerLeft,

              Container(
                padding: EdgeInsets.symmetric(vertical: 80),
              ),

              Text(
                "$name",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),

              Container(
                padding: EdgeInsets.symmetric(vertical: 15),
              ),

              Container(
                margin: const EdgeInsets.all(15.0),
                child: Text(
                  "$bio",
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),

              Container(
                padding: EdgeInsets.symmetric(vertical: 30),
              ),

              // Text("Name: $name"),
              // Text("Bio: $bio"),
              (this.widget.user == null ||
                      this.widget.user.id == this.thisUser.id)
                  ? FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.lightBlue[100])),
                      color: Colors.lightBlue[100],
                      child: Text("Edit", style: TextStyle(fontSize: 20)),
                      onPressed: () async {
                        final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfileScreen()));
                        setState(() {
                          name = result[0];
                          bio = result[1];
                        });
                      },
                    )
                  : (isFriend)
                      ? Container(
                          child: Column(
                          children: <Widget>[
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
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                            ),
                            Text("Posted Events:",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                            ),
                            (this.widget.user.getUsableEvents().length == 0) ?
                                Center(
                                  child: Text("No posts yet"),
                                ) :
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
                                          String time = DateFormat('kk:mm')
                                              .format(postAt.eventDateTime);

                                          return (postAt.active &&
                                                  postAt.eventDateTime.isAfter(
                                                      DateTime.now()) &&
                                                  (postAt.postType ==
                                                          "public" ||
                                                      UserDb
                                                          .userMap[postAt
                                                              .ownerUserId]
                                                          .friendsUserIdList
                                                          .contains(
                                                              thisUser.id)))
                                              ? Card(
                                                  child: ListTile(
                                                    title: Row(
                                                      children: [
                                                        Text(
                                                          "${postAt.eventDescription}",
                                                          style: TextStyle(
                                                              fontSize: 20),
                                                        ),
                                                    Text(
                                                      "${postAt.eventDescription}",
                                                      style: TextStyle(fontSize: 20),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(right: 5, left: 20),
                                                      child: Icon(Icons.person_outline),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(right: 40),
                                                      child: Text("${postAt.usersSignedUp.length}/${postAt.cap}")),
                                                      ],
                                                    ),
                                                    subtitle: Text(
                                                        "\n $time" +
                                                            " \n Address: ${postAt.address}",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 15)),
                                                    onTap: () {
                                                      var result = Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  DisplayPostScreen(
                                                                      postAt)));
                                                    },
                                                  ),
                                                )
                                              : Container();
                                        })))
                          ],
                        ))
                      : (requestRecieved)
                          ? Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
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

                                      print(
                                          "line 249 profile screen : ${thisUser.requestReceivedList.length}");
                                      print(
                                          "line 250 profile screen : ${newRequestRecievedList.length}");

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
                              : (isFriend)
                                  ? Container(
                                      child: Column(
                                      children: <Widget>[
                                        FlatButton(
                                          child: Text("Remove Friend"),
                                          color: Colors.red,
                                          onPressed: () async {
                                            User thisUser = UserDb.userMap[
                                                UserDb.emailMap[
                                                    EmailDb.thisEmail]];
                                            Set<int> friendIdList =
                                                thisUser.friendsUserIdList;
                                            friendIdList
                                                .remove(this.widget.user.id);
                                            await UserDb.updateData(thisUser.id,
                                                friendsUserIdList:
                                                    friendIdList);

                                            Set<int> friendIdList2 = this
                                                .widget
                                                .user
                                                .friendsUserIdList;
                                            friendIdList2.remove(thisUser.id);
                                            await UserDb.updateData(
                                                this.widget.user.id,
                                                friendsUserIdList:
                                                    friendIdList2);

                                            setState(() {
                                              isFriend = false;
                                            });
                                          },
                                        ),
                                      ],
                                    ))
                                  : (requestRecieved)
                                      ? Container(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              FlatButton(
                                                child: Text("Accept"),
                                                color: Colors.red,
                                                onPressed: () async {
                                                  User thisUser = UserDb
                                                          .userMap[
                                                      UserDb.emailMap[
                                                          EmailDb.thisEmail]];
                                                  Set<int>
                                                      newRequestRecievedList =
                                                      thisUser
                                                          .requestReceivedList;
                                                  Set<int> newFriendList =
                                                      thisUser
                                                          .friendsUserIdList;
                                                  newFriendList
                                                      .add(this.widget.user.id);
                                                  newRequestRecievedList.remove(
                                                      this.widget.user.id);
                                                  await UserDb.updateData(
                                                      thisUser.id,
                                                      requestReceivedList:
                                                          newRequestRecievedList,
                                                      friendsUserIdList:
                                                          newFriendList);

                                                  Set<int> newRequestSentList =
                                                      this
                                                          .widget
                                                          .user
                                                          .requestSentList;
                                                  Set<int> newFriendList2 = this
                                                      .widget
                                                      .user
                                                      .friendsUserIdList;
                                                  newRequestSentList
                                                      .remove(thisUser.id);
                                                  newFriendList2
                                                      .add(thisUser.id);
                                                  await UserDb.updateData(
                                                      this.widget.user.id,
                                                      requestSentList:
                                                          newRequestSentList,
                                                      friendsUserIdList:
                                                          newFriendList2);

                                                  setState(() {
                                                    isFriend = true;
                                                  });
                                                },
                                              ),
                                              FlatButton(
                                                child: Text("Deny"),
                                                color: Colors.red,
                                                onPressed: () async {
                                                  User thisUser = UserDb
                                                          .userMap[
                                                      UserDb.emailMap[
                                                          EmailDb.thisEmail]];
                                                  Set<int>
                                                      newRequestRecievedList =
                                                      thisUser
                                                          .requestReceivedList;
                                                  newRequestRecievedList.remove(
                                                      this.widget.user.id);
                                                  await UserDb.updateData(
                                                      thisUser.id,
                                                      requestReceivedList:
                                                          newRequestRecievedList);

                                                  Set<int> newRequestSentList =
                                                      this
                                                          .widget
                                                          .user
                                                          .requestSentList;
                                                  newRequestSentList
                                                      .remove(thisUser.id);
                                                  await UserDb.updateData(
                                                      this.widget.user.id,
                                                      requestSentList:
                                                          newRequestSentList);

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
                                                    UserDb.emailMap[
                                                        EmailDb.thisEmail]];
                                                Set<int> thisRequestsSent =
                                                    thisUser.requestSentList;
                                                thisRequestsSent.remove(
                                                    this.widget.user.id);
                                                await UserDb.updateData(
                                                    thisUser.id,
                                                    requestSentList:
                                                        thisRequestsSent);

                                                Set<int> requestRecievedList =
                                                    this
                                                        .widget
                                                        .user
                                                        .requestReceivedList;
                                                requestRecievedList
                                                    .remove(thisUser.id);
                                                await UserDb.updateData(
                                                    this.widget.user.id,
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
                                                    UserDb.emailMap[
                                                        EmailDb.thisEmail]];
                                                Set<int> thisRequestsSent =
                                                    thisUser.requestSentList;
                                                thisRequestsSent
                                                    .add(this.widget.user.id);
                                                await UserDb.updateData(
                                                    thisUser.id,
                                                    requestSentList:
                                                        thisRequestsSent);

                                                Set<int> requestRecievedList =
                                                    this
                                                        .widget
                                                        .user
                                                        .requestReceivedList;
                                                requestRecievedList
                                                    .add(thisUser.id);
                                                await UserDb.updateData(
                                                    this.widget.user.id,
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

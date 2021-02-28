import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frc_challenge_app/components/common_app_bar.dart';
import 'package:frc_challenge_app/db_services/email_db.dart';
import 'package:frc_challenge_app/db_services/post_db.dart';
import 'package:frc_challenge_app/db_services/user_db.dart';
import 'package:frc_challenge_app/models/post.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class DisplayPostScreen extends StatefulWidget {
  final Post post;

  DisplayPostScreen(this.post);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DisplayPostScreen();
  }
}

class _DisplayPostScreen extends State<DisplayPostScreen> {
  Set<Marker> markers = new HashSet();
  int numSignedUp;
  bool signedUp;
  bool owned;
  DateTime t;
  String time;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    numSignedUp = this.widget.post.usersSignedUp.length;
    signedUp = UserDb
        .userMap[UserDb.emailMap[EmailDb.thisEmail]].postsSignedUpFor
        .contains(this.widget.post.id);
    try{
      print("asdfasdfasdfasdf" + "$UserDb.emailMap[EmailDb.thisEmail]");
    }

    catch (Exception){
      print("asdfasdfasdfasdfasdfasdfasdfasdfasdfasdf");
    }

    int thisUser = UserDb.userMap[UserDb.emailMap[EmailDb.thisEmail]].id;
    owned = this.widget.post.ownerUserId == thisUser;
    t = this.widget.post.eventDateTime;
    time = DateFormat('yyyy-MM-dd – kk:mm').format(t);

  }

  @override
  Widget build(BuildContext context) {
    markers.add(new Marker(
        markerId: MarkerId("${this.widget.post.id}"),
        position:
        LatLng(this.widget.post.latitude, this.widget.post.longitude)));
    return Scaffold(
      appBar: CommonAppBar.appBar("View Post", context),
      backgroundColor: Colors.grey[300],
      body: Container(
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
              SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.5,
                  child: GoogleMap(
                    markers: markers,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                          this.widget.post.latitude,
                          this.widget.post.longitude),
                      zoom: 12,
                    ),
                  )),

              // SingleChildScrollView(
              // child: Container(
              SingleChildScrollView(
                child: Column(
                  children: <Text>[
                    Text("${this.widget.post.eventDescription}",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text("${this.widget.post.ownerUserId}"),
                    Text("\n"),
                    Text("$time"),
                    Text("\n"),
                    Text("${this.widget.post.address}"),
                    Text("Sign up: ${this.widget.post.usersSignedUp.length}/${this.widget.post.cap}"),
                    Text("\n"),
                    Text("${this.widget.post.usersSignedUp.length} have signed up!"),
                  ],
                ),
              ),

              (!signedUp && PostDb.checkCap(this.widget.post.cap,this.widget.post.usersSignedUp)=="")?
              FlatButton(
                color: Colors.lightBlue[100],
                child: Text("Sign Up",
                  style: TextStyle(color: Colors.black),
                ),

                onPressed: () {
                  Set<int> postsSignedUpFor = UserDb
                      .userMap[UserDb.emailMap[EmailDb.thisEmail]]
                      .postsSignedUpFor;
                  postsSignedUpFor.add(this.widget.post.id);
                  UserDb.updateData(
                      UserDb.userMap[UserDb.emailMap[EmailDb.thisEmail]].id,
                      postsSignedUpFor: postsSignedUpFor);

                  Set<int> usersSignedUpForEvent = this.widget.post
                      .usersSignedUp;
                  usersSignedUpForEvent
                      .add(
                      UserDb.userMap[UserDb.emailMap[EmailDb.thisEmail]].id);
                  PostDb.updatePost(this.widget.post.id,
                      usersSignedUp: usersSignedUpForEvent);

                  setState(() {
                    numSignedUp = this.widget.post.usersSignedUp.length;
                    signedUp = true;
                  });
                },
              ) : (!owned && signedUp) ?
              FlatButton(
                color: Colors.lightBlue[100],
                child: Text("Withdraw",
                  style: TextStyle(color: Colors.black)
                ),
                onPressed: () {
                  Set<int> postsSignedUpFor = UserDb
                      .userMap[UserDb.emailMap[EmailDb.thisEmail]]
                      .postsSignedUpFor;
                  postsSignedUpFor.remove(this.widget.post.id);
                  UserDb.updateData(UserDb.userMap[UserDb.emailMap[EmailDb.thisEmail]].id,
                      postsSignedUpFor: postsSignedUpFor);

                  Set<int> usersSignedUpForEvent = this.widget.post
                      .usersSignedUp;
                  usersSignedUpForEvent
                      .remove(
                      UserDb.userMap[UserDb.emailMap[EmailDb.thisEmail]].id);
                  PostDb.updatePost(this.widget.post.id, usersSignedUp: usersSignedUpForEvent);

                  setState(() {
                    numSignedUp = this.widget.post.usersSignedUp.length;
                    signedUp = false;
                  });
                },
              ) : Container(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
              ),
              (owned) ? FlatButton(
                color: Colors.lightBlue[100],
                child: Text("Delete Post"),
                onPressed: () async{
                  await PostDb.deletePostFromDb(this.widget.post.id);
                  Navigator.pop(context);
                },
              ) :
                Container(),
              (PostDb.checkCap(this.widget.post.cap,this.widget.post.usersSignedUp)!="") ?
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(vertical: 35),
                child: Center(child: Text(
                  "Event Limit has been met",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )) : Container()
            ])),
      ),
    );
  }
}

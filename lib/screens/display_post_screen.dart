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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    numSignedUp = this.widget.post.usersSignedUp.length;
  }

  @override
  Widget build(BuildContext context) {
    markers.add(new Marker(
        markerId: MarkerId("${this.widget.post.id}"),
        position:
            LatLng(this.widget.post.latitude, this.widget.post.longitude)));
    return Scaffold(
      appBar: CommonAppBar.appBar("View Post", context),
      backgroundColor: Colors.greenAccent,
      body: Container(
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
          SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.5,
              child: GoogleMap(
                markers: markers,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      this.widget.post.latitude, this.widget.post.longitude),
                  zoom: 12,
                ),
              )),
              Text(
                "${this.widget.post.eventDescription}"
              ),
              Text(
                "${this.widget.post.eventDateTime.toString()}"
              ),
              Text(
                "${this.widget.post.usersSignedUp.length} have signed up!"
              ),
              FlatButton(
                  color: Colors.red,
                  child: Text("sign up"),
                  onPressed: () {
                    Set<int> postsSignedUpFor = UserDb.userMap[UserDb.emailMap[EmailDb.thisEmail]].postsSignedUpFor;
                    postsSignedUpFor.add(this.widget.post.id);
                    UserDb.updateData(UserDb.userMap[UserDb.emailMap[EmailDb.thisEmail]].id, postsSignedUpFor: postsSignedUpFor);

                    Set<int> usersSignedUpForEvent = this.widget.post.usersSignedUp;
                    usersSignedUpForEvent.add(UserDb.userMap[UserDb.emailMap[EmailDb.thisEmail]].id);
                    PostDb.updatePost(this.widget.post.id, usersSignedUp: usersSignedUpForEvent);

                    setState(() {
                      numSignedUp = this.widget.post.usersSignedUp.length;
                    });
                  },
              )
        ])),
      ),
    );
  }
}

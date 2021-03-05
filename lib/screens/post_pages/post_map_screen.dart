import 'dart:collection';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frc_challenge_app/components/bottomNavBar.dart';
import 'package:frc_challenge_app/components/common_app_bar.dart';
import 'package:frc_challenge_app/components/event_card_regular.dart';
import 'package:frc_challenge_app/db_services/auth_service.dart';
import 'package:frc_challenge_app/db_services/email_db.dart';
import 'package:frc_challenge_app/db_services/post_db.dart';
import 'package:frc_challenge_app/db_services/user_db.dart';
import 'package:frc_challenge_app/models/post.dart';
import 'package:frc_challenge_app/models/user.dart';
import 'package:frc_challenge_app/screens/auth_pages/log_in_screen.dart';
import 'package:frc_challenge_app/screens/post_search.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:frc_challenge_app/services/geolocator.dart';
import 'package:intl/intl.dart';
import 'create_post_screen.dart';

import 'display_post_screen.dart';

class PostMapScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PostMapScreen();
  }
}

class _PostMapScreen extends State<PostMapScreen> {
  Set<Marker> markers = new HashSet<Marker>();
  bool mapMode;
  List<String> toggle = ['Map', 'List'];
  static Position temp = Geolocate.currLocation;
  static LatLng _center = LatLng(temp.latitude, temp.longitude);
  static List<double> compareV = [temp.latitude, temp.longitude];
  static List<Post> sortedPos = new List<Post>();
  static List<List<double>> pos = new List<List<double>>();
  DateTime t;
  String time;
  int numSignedUp;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sortedPos.clear();
    mapMode = true;
    toggle = ['Map', 'List'];

    print("postidlength ${PostDb.postIdList.length}");
    for (int i = 0; i < PostDb.postIdList.length; i++) {
      Post p = PostDb.localMap[PostDb.postIdList.elementAt(i)];
      DateTime now = DateTime.now();
      if (checkStat(p, now)) {
        sortedPos.add(p);
        markers.add(Marker(
            markerId: MarkerId("$i"),
            position: LatLng(p.latitude, p.longitude),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DisplayPostScreen(p)));
            }));
      }
    }

    print("sortedposlength ${sortedPos.length}");
    sortedPos.sort((a, b) {
      double d1 = Geolocate.distancesM[a.id];
      double d2 = Geolocate.distancesM[b.id];
      int num = d1.compareTo(d2);
      if (num == 0) {
        bool isAfter = a.eventDateTime.isAfter(b.eventDateTime);
        if (isAfter) {
          return 1;
        }
        return -1;
      }
      return num;
    });
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

  @override
  Widget build(BuildContext context) {
    print(mapMode);

    return Scaffold(
      //add colour
      appBar: AppBar(
        title: Text("View Events"),
        backgroundColor: Colors.lightBlue[100],
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20),
              child: GestureDetector(
                child: Icon(Icons.search),
                onTap: () {
                  showSearch(context: context, delegate: PostSearch());
                },
              )),
          Padding(
              padding: EdgeInsets.only(right: 15),
              child: GestureDetector(
                child: Icon(Icons.input),
                onTap: () {
                  EmailDb.addBool(false);
                  AuthenticationService.signOutUser();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LogInScreen()));
                },
              ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.grey[400],
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CreatePostScreen()));
        },
      ),
      body: SingleChildScrollView(
          child: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: ToggleSwitch(
              activeBgColor: Colors.lightBlue[100],
              inactiveBgColor: Colors.grey[400],
              minWidth: 50.0,
              minHeight: 50.0,
              labels: toggle,
              onToggle: (index) {
                setState(() {
                  String temp = toggle[0];
                  toggle[0] = toggle[1];
                  toggle[1] = temp;
                  mapMode = toggle[0] == "Map";
                });
              },
            ),
          ),
          (mapMode)
              ? SingleChildScrollView(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: GoogleMap(
                        markers: markers,
                        initialCameraPosition: CameraPosition(
                          target: _center,
                          zoom: 12,
                        ),
                      )))
              :
              SizedBox(
                height: MediaQuery.of(context).size.height*0.8,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,

                      itemCount: sortedPos.length,

                      itemBuilder: (BuildContext context, int index) {
                        DateTime now = DateTime.now();
                        Post atIndex =
                            PostDb.localMap[sortedPos.elementAt(index).id];
                        print("$atIndex index");
                        print("length >>>>>>>>>>>>>>>>>>>>> ${sortedPos.length}");
                        t = sortedPos.elementAt(index).eventDateTime;
                        time = DateFormat('kk:mm').format(t);
                        numSignedUp =
                            sortedPos.elementAt(index).usersSignedUp.length;

                        return (atIndex.eventDateTime.isAfter(now))
                            ? EventCardRegular(atIndex, onTapFunction: () async{
                              await Navigator.push(context, MaterialPageRoute(builder: (context) => DisplayPostScreen(atIndex)));
                              setState(() {
                                sortedPos.clear();


                                print("postidlength ${PostDb.postIdList.length}");
                                for (int i = 0; i < PostDb.postIdList.length; i++) {
                                  Post p = PostDb.localMap[PostDb.postIdList.elementAt(i)];
                                  DateTime now = DateTime.now();
                                  if (checkStat(p, now)) {
                                    sortedPos.add(p);
                                  }
                                }

                                print("sortedposlength ${sortedPos.length}");
                                sortedPos.sort((a, b) {
                                  double d1 = Geolocate.distancesM[a.id];
                                  double d2 = Geolocate.distancesM[b.id];
                                  int num = d1.compareTo(d2);
                                  if (num == 0) {
                                    bool isAfter = a.eventDateTime.isAfter(b.eventDateTime);
                                    if (isAfter) {
                                      return 1;
                                    }
                                    return -1;
                                  }
                                  return num;
                                });
                              });
                        })
                            : Container();

                      }))
        ],
      )),
      bottomNavigationBar: bottomNavBar(Divisions.HOME),
    );
  }
}

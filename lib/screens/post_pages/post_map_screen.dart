import 'dart:collection';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frc_challenge_app/components/bottomNavBar.dart';
import 'package:frc_challenge_app/components/common_app_bar.dart';
import 'package:frc_challenge_app/db_services/post_db.dart';
import 'package:frc_challenge_app/models/post.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:frc_challenge_app/services/geolocator.dart';

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
  static  LatLng _center =  LatLng(temp.latitude, temp.longitude);
  static List<double> compareV =[temp.latitude,temp.longitude];
  static List<Post> sortedPos = new List<Post>();
  static List<List<double>> pos = new List<List<double>>();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mapMode = true;
    toggle = ['Map', 'List'];
  }

  @override
  Widget build(BuildContext context) {
    print(mapMode);
    for (int i = 0; i < PostDb.postIdList.length; i++) {
      Post p = PostDb.localMap[PostDb.postIdList.elementAt(i)];
      DateTime now = DateTime.now();
      if (p.eventDateTime.isAfter(now)) {
        List<double> temp = List<double>();
        temp.add(p.latitude);
        temp.add(p.longitude);
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

      sortedPos.sort((a, b) {
        double d1 = Geolocate.distancesM[a.id];
        double d2 =  Geolocate.distancesM[b.id];
        int num =  d1.compareTo(d2);
        if(num==0){
          bool isAfter=a.eventDateTime.isAfter(b.eventDateTime);
          if(isAfter){
            return 1;
          }return -1;
        }
        return num;
      });

    }


    Widget widget = Container();

    return Scaffold(
      appBar: CommonAppBar.appBar("View Posts", context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CreatePostScreen()));
        },
      ),
      body: Container(
          child: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: ToggleSwitch(
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
                      height: MediaQuery.of(context).size.height * 0.75,
                      child: GoogleMap(
                        markers: markers,
                        initialCameraPosition: CameraPosition(
                          target: _center,
                          zoom: 12,
                        ),
                      )))
              : SingleChildScrollView(
                  child: ListView.builder(
                      itemCount: sortedPos.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        DateTime now = DateTime.now();
                        Post atIndex = PostDb.localMap[sortedPos.elementAt(index)];
                        return (atIndex.eventDateTime.isAfter(now)) ? Container(
                          height: 50,
                          child: Card(
                            child: ListTile(
                              title: Text(
                                  "${PostDb.localMap[sortedPos.elementAt(index)].eventDescription}"),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DisplayPostScreen(
                                            PostDb.localMap[sortedPos
                                                .elementAt(index)])));
                              },
                            ),
                          ),
                        ) :
                        Container();
                      }))
        ],
      )),
      bottomNavigationBar: bottomNavBar(),
    );
  }
}

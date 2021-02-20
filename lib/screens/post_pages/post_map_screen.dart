import 'dart:collection';

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
                      itemCount: PostDb.postIdList.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        DateTime now = DateTime.now();
                        Post atIndex = PostDb.localMap[PostDb.postIdList.elementAt(index)];
                        return (atIndex.eventDateTime.isAfter(now)) ? Container(
                          height: 50,
                          child: Card(
                            child: ListTile(
                              title: Text(
                                  "${PostDb.localMap[PostDb.postIdList.elementAt(index)].eventDescription}"),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DisplayPostScreen(
                                            PostDb.localMap[PostDb.postIdList
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

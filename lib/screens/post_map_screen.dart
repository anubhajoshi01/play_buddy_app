import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frc_challenge_app/components/common_app_bar.dart';
import 'package:frc_challenge_app/db_services/post_db.dart';
import 'package:frc_challenge_app/models/post.dart';
import 'package:frc_challenge_app/screens/bottomNavBar.dart';
import 'package:frc_challenge_app/screens/create_post_screen.dart';
import 'package:frc_challenge_app/screens/display_post_screen.dart';
import 'package:frc_challenge_app/screens/log_in_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:frc_challenge_app/screens/sign_in_screen.dart';
import 'package:frc_challenge_app/screens/log_in_screen.dart';

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

  static const LatLng _center = const LatLng(45.521563, -122.677433);

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
      markers.add(Marker(
          markerId: MarkerId("$i"),
          position: LatLng(p.latitude, p.longitude),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          onTap: (){
            DisplayPostScreen(p);
          }));
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
                      height: MediaQuery.of(context).size.height * 0.8,
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
                        return Container(
                          height: 50,
                          child: Card(
                            child: ListTile(
                              title: Text(
                                  "${PostDb.localMap[PostDb.postIdList.elementAt(index)].eventDescription}"),
                              onTap: (){
                                DisplayPostScreen(PostDb.localMap[PostDb.postIdList.elementAt(index)]);
                              },
                            ),
                          ),
                        );
                      }))
        ],
      )),
      
      bottomNavigationBar: bottomNavBar(),
    );

  }
}

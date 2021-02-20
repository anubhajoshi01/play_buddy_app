
import 'package:flutter/material.dart';
import 'package:frc_challenge_app/screens/friends_pages/friends_screen.dart';
import 'package:frc_challenge_app/screens/friends_pages/requests_screen.dart';
import 'package:frc_challenge_app/screens/home_pages/profile_screen.dart';
import 'package:frc_challenge_app/screens/home_pages/view_my_events_screen.dart';
import 'package:frc_challenge_app/screens/home_pages/view_signedup_events_screen.dart';

class CommonDrawers{

  static Drawer profileDrawer(BuildContext context){
    return Drawer(
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
        children: <Widget>[
          DrawerHeader(
            child: Text("Navigate"),
            decoration: BoxDecoration(
              color: Colors.greenAccent
            ),
          ),
          ListTile(
            title: Text("My Profile"),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
          ),
          ListTile(
            title: Text("My Posts"),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ViewMyEventsScreen()));
            },
          ),
          ListTile(
            title: Text("Signed-Up Events"),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ViewSignedUpEvents()));
            },
          )
        ],
      )
    );
  }

  static Drawer friendDrawer(BuildContext context){
    return Drawer(
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 5),
        children: <Widget>[
          DrawerHeader(
            child: Text("Navigate"),
            decoration: BoxDecoration(
              color: Colors.greenAccent
            ),
          ),
          ListTile(
            title: Text("My Friends"),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => FriendsScreen()));
            },
          ),
          ListTile(
            title: Text("Requests"),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => RequestsScreen()));
            },
          )
        ],
      )
    );
  }
}
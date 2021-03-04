
import 'package:flutter/material.dart';
import 'package:frc_challenge_app/screens/friends_pages/friend_search_screen.dart';
import 'package:frc_challenge_app/screens/friends_pages/friends_screen.dart';
import 'package:frc_challenge_app/screens/friends_pages/requests_screen.dart';
import 'package:frc_challenge_app/screens/home_pages/profile_screen.dart';
import 'package:frc_challenge_app/screens/home_pages/view_my_events_screen.dart';
import 'package:frc_challenge_app/screens/home_pages/view_signedup_events_screen.dart';

class CommonDrawers{

  static Drawer profileDrawer(BuildContext context, String title){
    return Drawer(
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
        children: <Widget>[
          DrawerHeader(
            child: Text("Profile"),
            decoration: BoxDecoration(
              color: Colors.lightBlue[100]
            ),
          ),
          ListTile(
            title: Text("My Profile", style: TextStyle(color: (title == "My Profile") ? Colors.red : Colors.black),),
            onTap: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
          ),
          ListTile(
            title: Text("My Posts", style: TextStyle(color: (title == "My Posts") ? Colors.red : Colors.black)),
            onTap: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ViewMyEventsScreen()));
            },
          ),
          ListTile(
            title: Text("Signed-Up Events", style: TextStyle(color: (title == "Signed-Up Events") ? Colors.red : Colors.black)),
            onTap: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ViewSignedUpEvents()));
            },
          )
        ],
      )
    );
  }

  static Drawer friendDrawer(BuildContext context, String title){
    return Drawer(
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 5),
        children: <Widget>[
          DrawerHeader(
            child: Text("Friends"),
            decoration: BoxDecoration(
              color: Colors.lightBlue[100],
            ),
          ),
          ListTile(
            title:  Text("Search Users", style: TextStyle(color: (title == "Search Users") ? Colors.red : Colors.black)),
            onTap: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FriendSearchScreen()));
            },
          ),
          ListTile(
            title: Text("My Friends", style: TextStyle(color: (title == "My Friends") ? Colors.red : Colors.black)),
            onTap: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FriendsScreen()));
            },
          ),
          ListTile(
            title: Text("Requests", style: TextStyle(color: (title == "Requests") ? Colors.red : Colors.black)),
            onTap: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RequestsScreen()));
            },
          )
        ],
      )
    );
  }
}
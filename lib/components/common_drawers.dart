import 'package:flutter/material.dart';
import 'package:frc_challenge_app/screens/friends_pages/friend_search_screen.dart';
import 'package:frc_challenge_app/screens/friends_pages/friends_screen.dart';
import 'package:frc_challenge_app/screens/friends_pages/requests_screen.dart';
import 'package:frc_challenge_app/screens/home_pages/profile_screen.dart';
import 'package:frc_challenge_app/screens/home_pages/view_my_events_screen.dart';
import 'package:frc_challenge_app/screens/home_pages/view_signedup_events_screen.dart';

class CommonDrawers {
  static Drawer profileDrawer(BuildContext context, String title) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      children: <Widget>[
        DrawerHeader(
          child: Text("Profile"),
          decoration: BoxDecoration(color: Color.fromRGBO(163, 193, 227, 1)),
        ),
        Container(
            color: (title == "My Profile") ? Colors.grey[350] : Colors.white54,
            child: ListTile(
              title: Text("My Profile"),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
            )),
        Container(
            color: (title == "My Posts") ? Colors.grey[350] : Colors.white54,
            child: ListTile(
              title: Text("My Posts"),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewMyEventsScreen()));
              },
            )),
        Container(
            color: (title == "Signed-Up Events")
                ? Colors.grey[350]
                : Colors.white54,
            child: ListTile(
              title: Text("Signed-Up Events"),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewSignedUpEvents()));
              },
            ))
      ],
    ));
  }

  static Drawer friendDrawer(BuildContext context, String title) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.symmetric(vertical: 5),
      children: <Widget>[
        DrawerHeader(
          child: Text("Friends"),
          decoration: BoxDecoration(
            color: Color.fromRGBO(163, 193, 227, 1),
          ),
        ),
        Container(
            color: (title == "Search Users")
                ? Colors.grey[350]
                : Colors.white54,
        child: ListTile(
          title: Text("Search Users"),
          onTap: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => FriendSearchScreen()));
          },
        )),
        Container(
            color: (title == "My Friends")
                ? Colors.grey[350]
                : Colors.white54,
        child: ListTile(
          title: Text("My Friends"),
          onTap: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => FriendsScreen()));
          },
        )),
        Container(
            color: (title == "Requests")
                ? Colors.grey[350]
                : Colors.white54,
        child: ListTile(
          title: Text("Requests"),
          onTap: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => RequestsScreen()));
          },
        ))
      ],
    ));
  }
}

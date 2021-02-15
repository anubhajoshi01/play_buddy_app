import 'package:flutter/material.dart';
import 'package:frc_challenge_app/screens/friends_screen.dart';

import 'package:frc_challenge_app/screens/sign_in_screen.dart';
import 'package:frc_challenge_app/screens/log_in_screen.dart';
import 'package:frc_challenge_app/screens/post_map_screen.dart';
import 'package:frc_challenge_app/screens/profile_screen.dart';
import 'package:frc_challenge_app/screens/search_screen.dart';


class bottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      padding: EdgeInsets.only(top: 3, bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.home, size: 44.0),
            onPressed: () {
              Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
          ),
          IconButton(
            icon: Icon(Icons.search, size: 44.0),
            onPressed: () {
              Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => PostMapScreen()));
            },
          ),
          IconButton(
            icon: Icon(Icons.person, size: 44.0),
            onPressed: () {
              Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => FriendsScreen()));
            },
          ),
        ],
      ),
    );
    // //bottom Navigation Bar
    // bottomNavigationBar: BottomNavigationBar(
    //     currentIndex: _currentIndex,
    //
    //     type: BottomNavigationBarType.shifting,
    //     items: [
    //   BottomNavigationBarItem(
    //       icon: Icon(Icons.home),
    //       label: 'Home',
    //       backgroundColor: Colors.blue),
    //   BottomNavigationBarItem(
    //       icon: Icon(Icons.search),
    //       label: 'Search',
    //       backgroundColor: Colors.blue),
    //   BottomNavigationBarItem(
    //       icon: Icon(Icons.camera),
    //       label: 'Placeholder',
    //       backgroundColor: Colors.blue),
    //   BottomNavigationBarItem(
    //       icon: Icon(Icons.person),
    //       label: 'Profile',
    //       backgroundColor: Colors.blue),
    // ],
    //
    // onTap: (index){
    //    setState((){
    //      _currentIndex = index;
    //
    //    });
    //
    // },
    //
    // ),
  }
}

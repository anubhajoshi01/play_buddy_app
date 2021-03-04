import 'package:flutter/material.dart';
import 'package:frc_challenge_app/screens/category_screens/view_category_screen.dart';
import 'package:frc_challenge_app/screens/friends_pages/friends_screen.dart';

import 'package:frc_challenge_app/screens/auth_pages/sign_in_screen.dart';
import 'package:frc_challenge_app/screens/auth_pages/log_in_screen.dart';
import 'package:frc_challenge_app/screens/post_pages/post_map_screen.dart';
import 'package:frc_challenge_app/screens/home_pages/profile_screen.dart';
import 'package:frc_challenge_app/screens/search_screen.dart';

class Divisions{

 static final  HOME = "home";
  static final SEARCH = "search";
  static final FRIENDS = "friends";
  static final PROFILE = "profile";
}

class bottomNavBar extends StatelessWidget {

  final String division;

  bottomNavBar(this.division);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      color: Colors.lightBlue[100],
      padding: EdgeInsets.only(top: 3, bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[


          IconButton(
            icon: Icon(Icons.home, size: 44.0, color: (division == Divisions.HOME) ? Colors.red : Colors.black,),
            onPressed: () {
              Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => PostMapScreen()));
            },
          ),

          //category screen
          IconButton(
            icon: Icon(Icons.search, size: 44.0, color: (division == Divisions.SEARCH) ? Colors.red : Colors.black,),
            onPressed: () {
              Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => ViewCategoryScreen()));
            },
          ),

          IconButton(
            icon: Icon(Icons.people, size: 44.0, color: (division == Divisions.FRIENDS) ? Colors.red : Colors.black,),
            onPressed: () {
              Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => FriendsScreen()));
            },
          ),

          IconButton(
            icon: Icon(Icons.person, size: 44.0, color: (division == Divisions.PROFILE) ? Colors.red : Colors.black,),
            onPressed: () {
              Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) =>  ProfileScreen()));
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

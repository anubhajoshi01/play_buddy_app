// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frc_challenge_app/screens/bottomNavBar.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreen createState() {
    return _ProfileScreen();
  }
}
  class _ProfileScreen extends State<ProfileScreen>{
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Container(
            child: Text('asdfasdf'),

        ),


        bottomNavigationBar: bottomNavBar(),

      );
    }
  }




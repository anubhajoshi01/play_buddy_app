// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frc_challenge_app/screens/bottomNavBar.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreen createState() {
    return _SearchScreen();
  }
}
class _SearchScreen extends State<SearchScreen>{
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
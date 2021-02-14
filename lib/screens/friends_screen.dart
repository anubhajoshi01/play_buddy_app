
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frc_challenge_app/components/common_app_bar.dart';

class FriendsScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _FriendsScreen();
  }

}

class _FriendsScreen extends State<FriendsScreen>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: CommonAppBar.appBar("Friends", context),

    );
  }

}
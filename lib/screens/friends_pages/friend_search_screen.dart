
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frc_challenge_app/db_services/auth_service.dart';
import 'package:frc_challenge_app/db_services/email_db.dart';
import 'package:frc_challenge_app/screens/auth_pages/log_in_screen.dart';
import 'package:frc_challenge_app/screens/search_screen.dart';

class FriendSearchScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _FriendSearchScreen();
  }
}

class _FriendSearchScreen extends State<StatefulWidget>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search User"),
        backgroundColor: Colors.greenAccent,
        actions: <Widget>[
          GestureDetector(
            child: Icon(Icons.search),
            onTap: (){
              showSearch(context: context, delegate: FriendSearch());
            },
          ),
          GestureDetector(
            child: Icon(Icons.input),
            onTap: (){
              EmailDb.addBool(false);
              AuthenticationService.signOutUser();
              Navigator.push(context, MaterialPageRoute(builder: (context) => LogInScreen()));
            },
          )
        ],
      ),
    );
  }
}
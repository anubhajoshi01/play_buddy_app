import 'package:flutter/material.dart';
import 'package:frc_challenge_app/db_services/auth_service.dart';
import 'package:frc_challenge_app/db_services/email_db.dart';
import 'package:frc_challenge_app/screens/auth_pages/log_in_screen.dart';

class CommonAppBar {

  static AppBar appBar(String titleString, BuildContext context) {
    return AppBar(
      title: Text(titleString),
      backgroundColor: Colors.lightBlue[100],
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 10.0),
          child: GestureDetector(
            onTap: () {
              EmailDb.addBool(false);
              AuthenticationService.signOutUser();
              Navigator.push(context, MaterialPageRoute(builder: (context) => LogInScreen()));
            },
            child: Icon(
              Icons.input,
              size: 20.0,
            ),
          ),
        )
      ],
    );
  }

}




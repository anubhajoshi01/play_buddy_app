// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frc_challenge_app/components/bottomNavBar.dart';
import 'package:frc_challenge_app/components/common_app_bar.dart';
import 'package:frc_challenge_app/db_services/email_db.dart';
import 'package:frc_challenge_app/db_services/user_db.dart';
import 'package:frc_challenge_app/models/user.dart';
import 'package:frc_challenge_app/screens/home_pages/edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreen createState() {
    return _ProfileScreen();
  }
}

class _ProfileScreen extends State<ProfileScreen> {
  String name;
  String bio;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    User u = UserDb.userMap[UserDb.emailMap[EmailDb.thisEmail]];
    name = u.name;
    bio = u.bio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar.appBar("My Profile", context),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text("Your name: $name"),
              Text("Bio: $bio"),
              FlatButton(
                child: Text("Edit"),
                onPressed: () async{
                 final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfileScreen()));
                 setState(() {
                   List<String> split = result.split(" ");
                   name = split[0];
                   bio = split[1];
                 });
                },
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomNavBar(),
    );
  }
}

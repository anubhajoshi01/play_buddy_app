import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frc_challenge_app/components/common_app_bar.dart';
import 'package:frc_challenge_app/db_services/email_db.dart';
import 'package:frc_challenge_app/db_services/user_db.dart';
import 'package:frc_challenge_app/models/user.dart';
import 'package:frc_challenge_app/screens/home_pages/profile_screen.dart';

class EditProfileScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
   return _EditProfileScreen();
  }

}

class _EditProfileScreen extends State<EditProfileScreen>{

  String name;
  String bio;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar.appBar("My Profile", context),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
              ),
              Text(
                "Type your new name:",
                 style: TextStyle(fontSize: 15),

              ),
              TextField(
                onChanged: (input){
                  setState(() {
                    name = input;
                  });
                },
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
              ),
              Text(
                "Type your new Bio",
                style: TextStyle(fontSize: 15),
              ),
              TextField(
                onChanged: (input){
                  setState(() {
                    bio = input;
                  });
                },
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
              ),
              FlatButton(
                child: Text("Done",
                  style: TextStyle(fontSize: 15),
                ),
                onPressed: () async{
                  await updateDb();
                  Navigator.pop(context, "$name $bio");
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateDb() async{
    User u = UserDb.userMap[UserDb.emailMap[EmailDb.thisEmail]];
    await UserDb.updateData(u.id, bio: bio, name: name);
  }

}
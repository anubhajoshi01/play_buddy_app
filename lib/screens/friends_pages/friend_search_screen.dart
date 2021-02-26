import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frc_challenge_app/components/bottomNavBar.dart';
import 'package:frc_challenge_app/db_services/auth_service.dart';
import 'package:frc_challenge_app/db_services/email_db.dart';
import 'package:frc_challenge_app/db_services/user_db.dart';
import 'package:frc_challenge_app/screens/auth_pages/log_in_screen.dart';
import 'package:frc_challenge_app/screens/home_pages/profile_screen.dart';
import 'package:frc_challenge_app/screens/search_screen.dart';

class FriendSearchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _FriendSearchScreen();
  }
}

class _FriendSearchScreen extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search User"),
        backgroundColor: Colors.lightBlue[100],
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
         child: GestureDetector(
            child: Icon(Icons.search),
            onTap: () {
              showSearch(context: context, delegate: FriendSearch());
            },
          )),
          Padding(
            padding: EdgeInsets.only(right: 15.0),
          child: GestureDetector(
            child: Icon(Icons.input),
            onTap: () {
              EmailDb.addBool(false);
              AuthenticationService.signOutUser();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LogInScreen()));
            },
          ))
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.7,
              child: ListView.builder(
                  itemCount: UserDb.userIdList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(UserDb
                            .userMap[UserDb.userIdList.elementAt(index)].name),
                        subtitle: Text(UserDb
                            .userMap[UserDb.userIdList.elementAt(index)].bio),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileScreen(
                                      user: (UserDb.userMap[UserDb.userIdList
                                          .elementAt(index)]))));
                        },
                      ),
                    );
                  })),
        ),
      ),
      bottomNavigationBar: bottomNavBar(),
    );
  }
}

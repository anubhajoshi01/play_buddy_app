import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frc_challenge_app/components/bottomNavBar.dart';
import 'package:frc_challenge_app/db_services/auth_service.dart';
import 'package:frc_challenge_app/db_services/email_db.dart';
import 'package:frc_challenge_app/db_services/post_db.dart';
import 'package:frc_challenge_app/db_services/user_db.dart';
import 'package:frc_challenge_app/models/post.dart';
import 'package:frc_challenge_app/models/user.dart';
import 'package:frc_challenge_app/screens/auth_pages/log_in_screen.dart';
import 'package:frc_challenge_app/screens/post_pages/display_post_screen.dart';
import 'package:frc_challenge_app/screens/post_search.dart';
import 'package:frc_challenge_app/services/geolocator.dart';
import 'package:intl/intl.dart';

class ViewCategoryEventsScreen extends StatelessWidget {
  final String category;

  ViewCategoryEventsScreen(this.category);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Events In Category"),
        backgroundColor: Colors.lightBlue[100],
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                child: Icon(Icons.search),
                onTap: () {
                  showSearch(context: context, delegate: PostSearch());
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
      bottomNavigationBar: bottomNavBar(),
      body: Container(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.7,
          child: SingleChildScrollView(
            child: ListView.builder(
                itemCount: PostDb.categoryMap[category].length,
                itemBuilder: (context, index) {
                  Post at = PostDb
                      .localMap[PostDb.categoryMap[category].elementAt(index)];
                  User postOwner = UserDb.userMap[at.ownerUserId];
                  User thisUser =
                      UserDb.userMap[UserDb.emailMap[EmailDb.thisEmail]];
                  String time = DateFormat('kk:mm').format(at.eventDateTime);
                  return (at.active &&
                          at.eventDateTime.isAfter(DateTime.now()) &&
                          (at.postType == "public" ||
                              postOwner.friendsUserIdList
                                  .contains(thisUser.id)))
                      ? Card(
                          child: ListTile(
                            title: Text(
                              "${at.eventDescription}" + "\n",
                              style: TextStyle(fontSize: 20),
                            ),
                            subtitle: Text(
                                "$time" +
                                    " \n Signed Up: ${at.usersSignedUp.length}" +
                                    "\n distance: ${Geolocate.distancesM[at.id]}",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15)),
                            onTap: () {
                              var result = Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DisplayPostScreen(at)));
                            },
                          ),
                        )
                      : Container();
                }),
          ),
        ),
      ),
    );
  }
}

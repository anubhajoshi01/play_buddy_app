import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frc_challenge_app/components/bottomNavBar.dart';
import 'package:frc_challenge_app/components/common_app_bar.dart';
import 'package:frc_challenge_app/db_services/auth_service.dart';
import 'package:frc_challenge_app/db_services/category_db.dart';
import 'package:frc_challenge_app/db_services/email_db.dart';
import 'package:frc_challenge_app/db_services/post_db.dart';
import 'package:frc_challenge_app/db_services/user_db.dart';
import 'package:frc_challenge_app/models/post.dart';
import 'package:frc_challenge_app/models/user.dart';
import 'package:frc_challenge_app/screens/auth_pages/log_in_screen.dart';
import 'package:frc_challenge_app/screens/category_screens/view_category_events_screen.dart';

import '../post_search.dart';

class ViewCategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("view category : ${CategoryDb.categoryList.length}");
    return Scaffold(
      appBar: AppBar(
        title: Text("View Categories"),
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
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LogInScreen()));
                },
              ))
        ],
      ),
      bottomNavigationBar: bottomNavBar(Divisions.SEARCH),
      body: Container(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.95,
          child: ListView.builder(
              itemCount: CategoryDb.categoryList.length,
              itemBuilder: (context, index) {
                int itemCount = 0;

                String category = CategoryDb.categoryList.elementAt(index);

                User thisUser =
                    UserDb.userMap[UserDb.emailMap[EmailDb.thisEmail]];
                for (int i = 0;
                    i < CategoryDb.categoryMap[category].length;
                    i++) {
                  Post at = PostDb
                      .localMap[CategoryDb.categoryMap[category].elementAt(i)];
                  User postOwner = UserDb.userMap[at.ownerUserId];
                  if ((at.active &&
                      at.eventDateTime.isAfter(DateTime.now()) &&
                      (at.postType == "public" ||
                          postOwner.friendsUserIdList.contains(thisUser.id)))) {
                    itemCount += 1;
                  }
                }
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.29,
                  child: Card(
                      child: _getImage(CategoryDb.imageUrl[category], context,
                          category, itemCount)),
                );
              }),
        ),
      ),
    );
  }

  Widget _getImage(
      String url, BuildContext context, String category, int itemCount) {
    double height = (MediaQuery.of(context).size.height*0.3);
    return Stack(children: [
      Container(
        constraints: BoxConstraints.tightFor(
            height: height, width: MediaQuery.of(context).size.width),
        child: GestureDetector(
          child: Image.network(url, fit: BoxFit.fitWidth),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ViewCategoryEventsScreen(category)));
          },
        ),
      ),
      Column(children: [
        Text(
          category,
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        Text(
          "items: $itemCount",
          style: TextStyle(fontSize: 15),
        )
      ]),
    ]);
  }
}

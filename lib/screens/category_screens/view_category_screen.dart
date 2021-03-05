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
          child: _categoryColumn(context),
        ),
      ),
    );
  }

  int _getItemCount(String category) {
    int itemCount = 0;
    User thisUser = UserDb.userMap[UserDb.emailMap[EmailDb.thisEmail]];
    for (int i = 0; i < CategoryDb.categoryMap[category].length; i++) {
      Post at = PostDb.localMap[CategoryDb.categoryMap[category].elementAt(i)];
      User postOwner = UserDb.userMap[at.ownerUserId];
      if ((at.active &&
          at.eventDateTime.isAfter(DateTime.now()) &&
          (at.postType == "public" ||
              postOwner.friendsUserIdList.contains(thisUser.id)))) {
        itemCount += 1;
      }
    }
    return itemCount;
  }

  Widget _categoryColumn(BuildContext context) {
    List<Widget> forColumn = new List();
    for (int i = 0; i < CategoryDb.categoryList.length; i += 2) {
      String category1 = CategoryDb.categoryList.elementAt(i);
      String category2 = CategoryDb.categoryList.elementAt(i + 1);
      Widget row = _categoryDualRow(context, category1, category2);
      forColumn.add(row);
    }
    return SingleChildScrollView(
        child: Column(
      children: forColumn,
    ));
  }

  Widget _categoryDualRow(
      BuildContext context, String category1, String category2) {
    List<Widget> forRow = new List();
    forRow.add(_getImage(context, category1));
    forRow.add(_getImage(context, category2));
    return Row(
      children: forRow,
    );
  }

  Widget _getImage(BuildContext context, String category) {
    double height = (MediaQuery.of(context).size.height * 0.28);
    int itemCount = _getItemCount(category);
    String url = CategoryDb.imageUrl[category];

    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
        child: Card(
        borderOnForeground: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(35),
          side: BorderSide(width: 4, color: Colors.black)
        ),
        child: Stack(children: [
          Container(
            constraints: BoxConstraints.tightFor(
              height: height,
              width: MediaQuery.of(context).size.width * 0.48,
            ),
            child: GestureDetector(
              child: Image.network(url, fit: BoxFit.fill),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ViewCategoryEventsScreen(category)));
              },
            ),
          ),
          Column(children: [
            Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            Text(
              "  $category",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Text(
              "items: $itemCount",
              style: TextStyle(fontSize: 15),
            )
          ]),
        ])));
  }
}

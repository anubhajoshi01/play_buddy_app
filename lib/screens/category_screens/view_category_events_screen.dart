import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frc_challenge_app/components/bottomNavBar.dart';
import 'package:frc_challenge_app/db_services/auth_service.dart';
import 'package:frc_challenge_app/db_services/category_db.dart';
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

class ViewCategoryEventsScreen extends StatefulWidget{

  final String category;

  ViewCategoryEventsScreen(this.category);

  @override
  State<StatefulWidget> createState() {
    return _ViewCategoryEventsScreen();
  }
}

class _ViewCategoryEventsScreen extends State<ViewCategoryEventsScreen> {

  Set<int> postList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    postList = CategoryDb.categoryMap[this.widget.category];
  }

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
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LogInScreen()));
                },
              ))
        ],
      ),
      bottomNavigationBar: bottomNavBar(Divisions.SEARCH),
      body: Container(
        child: Column(children: [
          _getImage(context, this.widget.category),
          SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.6,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: this.postList.length,
                  itemBuilder: (context, index) {
                    Post at = PostDb.localMap[
                        postList.elementAt(index)];
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
                              title: Row(
                                children: [
                                  Text(
                                    "${at.eventDescription}",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(right: 5, left: 20),
                                    child: Icon(Icons.person_outline),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(right: 40),
                                      child: Text(
                                          "${at.usersSignedUp.length}/${at.cap}"))
                                ],
                              ),
                              subtitle: Text(
                                  " \n $time" + " \n Address:: ${at.address}",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15)),
                              onTap: () async{
                                var result = await Navigator.push(
                                    context,
                                     MaterialPageRoute(
                                        builder: (context) =>
                                            DisplayPostScreen(at)));
                                setState(() {
                                  postList = CategoryDb.categoryMap[this.widget.category];
                                });
                              },
                            ),
                          )
                        : Container();
                  }))
        ]),
      ),
    );
  }

  int _getItemCount() {
    int itemCount = 0;
    User thisUser = UserDb.userMap[UserDb.emailMap[EmailDb.thisEmail]];
    for (int i = 0; i < CategoryDb.categoryMap[this.widget.category].length; i++) {
      Post at = PostDb.localMap[CategoryDb.categoryMap[this.widget.category].elementAt(i)];
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

  Widget _getImage(BuildContext context, String category) {
    double height = (MediaQuery.of(context).size.height * 0.2);
    String url = CategoryDb.imageUrl[category];
    return ClipRRect(
        child: Card(
            borderOnForeground: true,
            child: Stack(children: [
              Container(
                constraints: BoxConstraints.tightFor(
                  height: height,
                  width: MediaQuery.of(context).size.width,
                ),
                child: Image.network(url, fit: BoxFit.fill),
              ),
              Column(children: [
                Text(
                  "   $category",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ]),
            ])));
  }
}

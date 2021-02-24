import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frc_challenge_app/components/bottomNavBar.dart';
import 'package:frc_challenge_app/components/common_app_bar.dart';
import 'package:frc_challenge_app/components/common_drawers.dart';
import 'package:frc_challenge_app/db_services/email_db.dart';
import 'package:frc_challenge_app/db_services/user_db.dart';
import 'package:frc_challenge_app/models/user.dart';
import 'package:frc_challenge_app/screens/home_pages/profile_screen.dart';

class FriendsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FriendsScreen();
  }
}

class _FriendsScreen extends State<FriendsScreen> {
  List<User> friendList = new List<User>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    User thisUser = UserDb.userMap[UserDb.emailMap[EmailDb.thisEmail]];
    for (int i = 0; i < thisUser.friendsUserIdList.length; i++) {
      User u = UserDb.userMap[thisUser.friendsUserIdList.elementAt(i)];
      friendList.add(u);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: CommonAppBar.appBar("My Friends", context),
      drawer: CommonDrawers.friendDrawer(context),
      body: Container(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height*0.6,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
                itemCount: friendList.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key("$index"),
                    child: Card(
                      child: ListTile(
                        title: Text("${friendList[index].name}"),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ProfileScreen(user: friendList[index])));
                          setState(() {
                            List<User> newFriendList = new List<User>();
                            User thisUser = UserDb.userMap[UserDb.emailMap[EmailDb.thisEmail]];
                            for (int i = 0; i < thisUser.friendsUserIdList.length; i++) {
                              User u = UserDb.userMap[thisUser.friendsUserIdList.elementAt(i)];
                              newFriendList.add(u);
                            }
                            friendList = newFriendList;
                          });
                        },
                      ),
                    ),
                    onDismissed: (direction) {
                      User thisUser =
                          UserDb.userMap[UserDb.emailMap[EmailDb.thisEmail]];
                      Set<int> newFriendList = thisUser.friendsUserIdList;
                      newFriendList.remove(friendList[index].id);

                      UserDb.updateData(thisUser.id,
                          friendsUserIdList: newFriendList);

                      Set<int> newFriendList2 =
                          friendList[index].friendsUserIdList;
                      newFriendList2.remove(thisUser.id);

                      UserDb.updateData(friendList[index].id,
                          friendsUserIdList: newFriendList2);

                      setState(() {
                        friendList.removeAt(index);
                      });
                    },
                    background:
                        Container(color: Colors.red, child: Icon(Icons.remove)),
                  );
                }))),
      ),
        bottomNavigationBar: bottomNavBar(),
    );
  }
}

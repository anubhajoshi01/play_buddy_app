import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frc_challenge_app/components/bottomNavBar.dart';
import 'package:frc_challenge_app/components/common_app_bar.dart';
import 'package:frc_challenge_app/components/common_drawers.dart';
import 'package:frc_challenge_app/models/user.dart';
import 'package:frc_challenge_app/db_services/email_db.dart';
import 'package:frc_challenge_app/db_services/user_db.dart';
import 'package:frc_challenge_app/screens/home_pages/profile_screen.dart';

class RequestsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _RequestsScreen();
  }
}

class _RequestsScreen extends State<RequestsScreen> {
  List<User> requestsSent = new List<User>();
  List<User> requestsReceived = new List<User>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    User thisUser = UserDb.userMap[UserDb.emailMap[EmailDb.thisEmail]];
    for (int i = 0; i < thisUser.requestSentList.length; i++) {
      User u = UserDb.userMap[thisUser.requestSentList.elementAt(i)];
      requestsSent.add(u);
    }

    for (int i = 0; i < thisUser.requestReceivedList.length; i++) {
      User u = UserDb.userMap[thisUser.requestReceivedList.elementAt(i)];
      requestsReceived.add(u);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: CommonAppBar.appBar("Requests", context),
      drawer: CommonDrawers.friendDrawer(context),
      body: Container(
          child: SizedBox(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.7,
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                    ),
                    Text("Your sent requests:",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.4,
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: requestsSent.length,
                            itemBuilder: (context, index) {
                              return Dismissible(
                                key: Key("$index"),
                                child: Card(
                                  child: ListTile(
                                    title: Text("${requestsSent[index].name}"),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProfileScreen(
                                                      user: requestsSent[index])));

                                      setState(() {
                                        User thisUser = UserDb.userMap[
                                        UserDb.emailMap[EmailDb.thisEmail]];
                                        List<User> newList = new List<User>();
                                        for (int i = 0;
                                        i < thisUser.requestSentList.length;
                                        i++) {
                                          User u = UserDb.userMap[
                                          thisUser.requestSentList.elementAt(
                                              i)];
                                          newList.add(u);
                                        }
                                        requestsSent = newList;
                                      });
                                    },
                                  ),
                                ),
                                onDismissed: (direction) {
                                  User thisUser = UserDb
                                      .userMap[UserDb.emailMap[EmailDb
                                      .thisEmail]];

                                  User thatUser = UserDb.userMap[thisUser.requestSentList.elementAt(index)];
                                  Set<int> newRequestSentList =
                                      thisUser.requestSentList;
                                  newRequestSentList.remove(
                                      requestsSent[index].id);

                                  UserDb.updateData(thisUser.id,
                                      requestSentList: newRequestSentList);

                                  Set<int> newRequestRecieved =
                                      thatUser.requestReceivedList;

                                  print("id: ............. ${thatUser.id}");

                                  print("old  .............");
                                  print(requestsReceived.toString());

                                  newRequestRecieved.remove(thisUser.id);

                                  print("new ......................");
                                  print(requestsReceived.toString());

                                  UserDb.updateData(thatUser.id,
                                      requestReceivedList: newRequestRecieved);

                                  setState(() {
                                    requestsSent.removeAt(index);
                                  });
                                },
                                background: Container(
                                  color: Colors.red,
                                  child: Icon(Icons.remove),
                                ),
                              );
                            })),
                    Text("Received Requests:",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.4,
                        width: MediaQuery.of(context).size.width,
                        child:
                        ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: requestsReceived.length,
                            itemBuilder: (context, index) {
                              return Dismissible(
                                key: Key("$index"),
                                child: Card(
                                  child: ListTile(
                                    title: Text(requestsReceived[index].name),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProfileScreen(
                                                    user: requestsReceived[index],
                                                  )));

                                      setState(() {
                                        User thisUser = UserDb
                                            .userMap[UserDb.emailMap[EmailDb
                                            .thisEmail]];
                                        List<User> newList = new List<User>();
                                        for (int i = 0;
                                        i < thisUser.requestReceivedList.length;
                                        i++) {
                                          User u = UserDb.userMap[
                                          thisUser.requestReceivedList
                                              .elementAt(i)];
                                          newList.add(u);
                                        }
                                        requestsReceived = newList;
                                      });
                                    },
                                  ),
                                ),
                                onDismissed: (direction) {
                                  if (direction ==
                                      DismissDirection.endToStart) {
                                    User thisUser =
                                    UserDb.userMap[UserDb.emailMap[EmailDb
                                        .thisEmail]];
                                    Set<int> newRequestRecievedList =
                                        thisUser.requestReceivedList;
                                    Set<int> newFriendList = thisUser
                                        .friendsUserIdList;
                                    newFriendList.add(
                                        requestsReceived[index].id);
                                    newRequestRecievedList
                                        .remove(requestsReceived[index].id);
                                    UserDb.updateData(thisUser.id,
                                        requestReceivedList: newRequestRecievedList,
                                        friendsUserIdList: newFriendList);

                                    Set<int> newRequestSentList =
                                        requestsReceived[index].requestSentList;
                                    Set<int> newFriendList2 =
                                        requestsReceived[index]
                                            .friendsUserIdList;
                                    newRequestSentList.remove(thisUser.id);
                                    newFriendList2.add(thisUser.id);
                                    UserDb.updateData(
                                        requestsReceived[index].id,
                                        requestSentList: newRequestSentList,
                                        friendsUserIdList: newFriendList2);

                                    setState(() {
                                      requestsReceived.removeAt(index);
                                    });
                                  } else if (direction ==
                                      DismissDirection.startToEnd) {
                                    User thisUser =
                                    UserDb.userMap[UserDb.emailMap[EmailDb
                                        .thisEmail]];
                                    Set<int> newRequestRecievedList =
                                        thisUser.requestReceivedList;
                                    newRequestRecievedList
                                        .remove(requestsReceived[index].id);
                                    UserDb.updateData(thisUser.id,
                                        requestReceivedList: newRequestRecievedList);

                                    Set<int> newRequestSentList =
                                        requestsReceived[index].requestSentList;
                                    newRequestSentList.remove(thisUser.id);
                                    UserDb.updateData(
                                        requestsReceived[index].id,
                                        requestSentList: newRequestSentList);

                                    setState(() {
                                      requestsReceived.removeAt(index);
                                    });
                                  }
                                },
                                background: Container(
                                  color: Colors.red,
                                  child: Icon(Icons.remove),
                                ),
                                secondaryBackground: Container(
                                  color: Colors.green,
                                  child: Icon(Icons.add),
                                ),
                              );
                            }))
                  ],
                )),
          )),
      bottomNavigationBar: bottomNavBar(),
    );
  }
}

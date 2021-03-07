import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frc_challenge_app/db_services/email_db.dart';
import 'package:frc_challenge_app/db_services/user_db.dart';
import 'package:frc_challenge_app/models/user.dart';
import 'package:frc_challenge_app/screens/home_pages/profile_screen.dart';

class UserCard extends StatelessWidget {
  final User user;
  Function() onTapFunction;

  UserCard(this.user, {this.onTapFunction});

  @override
  Widget build(BuildContext context) {
    User thisUser = UserDb.userMap[UserDb.emailMap[EmailDb.thisEmail]];
    return Container(
      width: MediaQuery.of(context).size.width,
        height: 60,
        child: Card(
        child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.person_pin,
                  size: 30,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                ),
                Container(
                  width: MediaQuery.of(context).size.width*0.8,
                    height: 60,
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${user.name}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    Text(
                      (user.bio.length > 60)
                          ? "${user.bio.substring(0, 60)}..."
                          : "${user.bio}",
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    )
                  ],
                )),
                (thisUser.friendsUserIdList.contains(user.id))
                    ? Align(
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.check_box),
                      )
                    : (thisUser.requestReceivedList.contains(user.id))
                        ? Align(
                            alignment: Alignment.centerRight,
                            child: Icon(Icons.check_box_outline_blank),
                          )
                        : (thisUser.requestSentList.contains(user.id))
                            ? Align(
                                alignment: Alignment.centerRight,
                                child: Icon(Icons.check),
                              )
                            : Container()
              ],
            ),
            onTap: (onTapFunction == null)
                ? () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                                  user: user,
                                )));
                  }
                : onTapFunction)));
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frc_challenge_app/db_services/category_db.dart';
import 'package:frc_challenge_app/db_services/post_db.dart';
import 'package:frc_challenge_app/models/post.dart';
import 'package:frc_challenge_app/screens/post_pages/display_post_screen.dart';
import 'package:intl/intl.dart';

class EventCardRegular extends StatelessWidget {
  final Post event;
  final Function() onTapFunction;

  EventCardRegular(this.event, {this.onTapFunction});

  @override
  Widget build(BuildContext context) {
    String time = DateFormat('kk:mm').format(event.eventDateTime);
    return Container(
        height: 250,
        margin: const EdgeInsets.all(15.0),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(width: 0.3)),
              child: ListTile(
                title: Column(children: [
                  Row(
                    children: [
                      Text(
                        "${event.eventDescription}",
                        style: TextStyle(fontSize: 20),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 5, left: 20),
                        child: Icon(Icons.person_outline),
                      ),
                      Padding(
                          padding: EdgeInsets.only(right: 40),
                          child: Text(
                              "${event.usersSignedUp.length}/${event.cap}"))
                    ],
                  ),
                  _getImage(context),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(" \n $time" + " \n Address: ${event.address}",
                          style: TextStyle(color: Colors.black, fontSize: 15))),
                ]),
                onTap: (onTapFunction == null ) ? () {
                  var result = Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DisplayPostScreen(event)));
                } : onTapFunction,
              ),
            )));
  }

  Widget _getImage(BuildContext context) {
    double height = 150;
    String url = CategoryDb.imageUrl[this.event.category];
    return Container(
      constraints: BoxConstraints.tightFor(height: height),
      width: MediaQuery.of(context).size.width,
      child: Image.network(
        url,
        fit: BoxFit.fill,
      ),
    );
  }
}

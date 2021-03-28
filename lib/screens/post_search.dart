import 'package:flutter/material.dart';
import 'package:frc_challenge_app/db_services/email_db.dart';
import 'package:frc_challenge_app/db_services/post_db.dart';
import 'package:frc_challenge_app/db_services/user_db.dart';
import 'package:frc_challenge_app/models/post.dart';
import 'package:frc_challenge_app/models/user.dart';
import 'package:frc_challenge_app/screens/post_pages/display_post_screen.dart';

//search bar for posts

class PostSearch extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListView.builder(
        itemCount: PostDb.postIdList.length,
        itemBuilder: (context, index) {
          Post atIndex = PostDb.localMap[PostDb.postIdList.elementAt(index)];
          return (atIndex.active) ? ListTile(
            title: Text(atIndex.eventDescription),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DisplayPostScreen(atIndex)));
            },
          ) : Container();
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Post> postList = new List<Post>();
    List<Post> show = new List<Post>();
    for (int i = 0; i < PostDb.postIdList.length; i++) {
      Post u = PostDb.localMap[PostDb.postIdList.elementAt(i)];
      if(checkStat(u, DateTime.now())){
        postList.add(u);
      }
    }

    show = (query.isEmpty)
        ? postList
        : postList
            .where((element) =>
    ( element.eventDescription.contains(query) ||
                element.address.contains(query) ||
                element.category.contains(query)) && checkStat(element, DateTime.now()))
            .toList();
    return ListView.builder(
        itemCount: show.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(show[index].eventDescription),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DisplayPostScreen(show[index])));
            },
          );
        });
  }
  static bool checkStat(Post p, DateTime now) {
    User u = UserDb.userMap[UserDb.emailMap[EmailDb.thisEmail]];
    if (p.postType == ("public") ||
        u.friendsUserIdList.contains(p.ownerUserId) ||
        p.ownerUserId == u.id) {
      if (p.eventDateTime.isAfter(now) && p.active) {
        return true;
      }
    }
    return false;
  }
}

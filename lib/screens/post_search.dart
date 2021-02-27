import 'package:flutter/material.dart';
import 'package:frc_challenge_app/db_services/post_db.dart';
import 'package:frc_challenge_app/models/post.dart';
import 'package:frc_challenge_app/screens/post_pages/display_post_screen.dart';

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
          return ListTile(
            title: Text(atIndex.eventDescription),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DisplayPostScreen(atIndex)));
            },
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Post> postList = new List<Post>();
    List<Post> show = new List<Post>();
    for (int i = 0; i < PostDb.postIdList.length; i++) {
      Post u = PostDb.localMap[PostDb.postIdList.elementAt(i)];
      postList.add(u);
    }

    show = (query.isEmpty)
        ? postList
        : postList
            .where((element) =>
                element.eventDescription.contains(query) ||
                element.address.contains(query) ||
                element.category.contains(query))
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
}

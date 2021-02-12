import 'package:flutter/material.dart';
import 'package:frc_challenge_app/screens/bottomNavBar.dart';

class SearchScreen extends StatefulWidget {
  //placeholders for the event posts
  final List<String> list = List.generate(10, (index) => "Event $index");

  @override
  _SearchScreen createState() => _SearchScreen();

}

class _SearchScreen extends State<SearchScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: Search(widget.list));
            },
            icon: Icon(Icons.search),
          )
        ],
        centerTitle: true,
        title: Text('Search Bar'),

      ),
      body: ListView.builder(
        itemCount: widget.list.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(
            widget.list[index],
          ),
        ),

      ),

      bottomNavigationBar: bottomNavBar(),
    );

  }
}

class Search extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  //event info here
  String testing = "";

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      // put in event info here
      child: Center(
        child: Text(testing),
      ),
    );
  }

  final List<String> listTest;

  Search(this.listTest);

  List<String> recentList = ["Event 5", "Event 7"];

    @override
    Widget buildSuggestions(BuildContext context) {
      List<String> suggestionList = [];
      query.isEmpty
          ? suggestionList = recentList //In the true case
          : suggestionList.addAll(listTest.where(
        // In the false case
            (element) => element.contains(query),
      ));

      return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              suggestionList[index],
            ),
            leading: query.isEmpty ? Icon(Icons.access_time) : SizedBox(),
            onTap: () {
              testing = suggestionList[index];
              showResults(context);
            },
          );
        },
      );
    }
  }

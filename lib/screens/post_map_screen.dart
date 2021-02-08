
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frc_challenge_app/screens/create_post_screen.dart';

class PostMapScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event Map"),
        backgroundColor: Colors.greenAccent,
      ),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => CreatePostScreen()));
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }

}
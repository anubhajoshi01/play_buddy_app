import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frc_challenge_app/components/common_app_bar.dart';

class CreatePostScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CreatePostScreen();
  }
}

class _CreatePostScreen extends State<CreatePostScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBar.appBar("Create Post"),
        body: Container()
    );
  }
}

import 'package:flutter/material.dart';

class CommonAppBar  {

  static AppBar appBar(String titleString) {
    return AppBar(
      title: Text(titleString),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 10.0),
          child: GestureDetector(
            onTap: () {},
            child: Icon(
              Icons.input,
              size: 20.0,
            ),
          ),
        )
      ],
    );
  }
}

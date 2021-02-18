
import 'package:flutter/material.dart';

class CommonDrawers{

  static Drawer profileDrawer(){
    return Drawer(
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
        children: <Widget>[
          DrawerHeader(
            child: Text("Navigate"),
            decoration: BoxDecoration(
              color: Colors.greenAccent
            ),
          ),
          ListTile(
            title: Text("My Profile"),
          ),
          ListTile(
            title: Text("My Posts"),
          ),
          ListTile(
            title: Text("Signed-Up Events"),
          )
        ],
      )
    );
  }
}
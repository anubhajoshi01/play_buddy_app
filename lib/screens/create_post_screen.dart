import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frc_challenge_app/components/common_app_bar.dart';
import 'package:frc_challenge_app/db_services/email_db.dart';
import 'package:frc_challenge_app/db_services/post_db.dart';
import 'package:frc_challenge_app/db_services/user_db.dart';
import 'package:frc_challenge_app/models/post.dart';
import 'package:frc_challenge_app/screens/post_map_screen.dart';
import 'package:frc_challenge_app/services/geolocator.dart';
import 'package:geolocator/geolocator.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CreatePostScreen();
  }
}

class _CreatePostScreen extends State<CreatePostScreen> {

  static final List status = ["private", "public", "restricted"];
  static Map<String, int> mapStatus = {
    "private": 0,
    "public": 1,
    "restricted": 2
  };

  String descriptionStr = "";
  String infoStr = "";
  String activity = "";
  String dropdownMonth = "";
  String dropdownYear = "";
  String dropdownDay = "";
  String address = '';

/*
  static final List hoursList = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12"
  ];

  static final List minu */

  static DateTime selectedDate = DateTime.now();
  static TimeOfDay selectedTime = TimeOfDay.now();
  static String selectedStatus = "private";


  TimeOfDay _time = TimeOfDay.now();

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<Null> selectTime(BuildContext context) async{
    _time = await showTimePicker(context: context, initialTime: _time);
    setState(() {
      selectedTime = _time;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create a Post"),
        centerTitle: true,
        backgroundColor: Colors.red[700],
      ),
      body: SingleChildScrollView(
          child: Container(
              child: Column(children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Text(
            "Enter the activity type: ",
            style: TextStyle(
              color: Colors.grey[900],
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(3),
          color: Colors.white,
          child: TextField(
            keyboardType: TextInputType.text,
            onChanged: (input) {
              setState(() {
                infoStr = input;
              });
            },
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Text(
            "Enter the descripton of the event:  ",
            style: TextStyle(
              color: Colors.grey[900],
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(3),
          color: Colors.white,
          child: TextField(
            keyboardType: TextInputType.text,
            onChanged: (input) {
              setState(() {
                descriptionStr = input;
              });
            },
          ),
        ),
        Container(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "${selectedDate.toLocal()}".split(' ')[0],
              style: TextStyle(fontSize: 55, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20.0,
            ),
            RaisedButton(
              onPressed: () => _selectDate(context),
              // Refer step 3
              child: Text(
                'Select date',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              color: Colors.greenAccent,
            ),
          ],
        )),
        Container(
          child: DropdownButton(
            hint: Text('Status'), // Not necessary for Option 1
            value: status[mapStatus[selectedStatus]],
            onChanged: (newValue) {
              setState(() {
                selectedStatus = newValue;
                int index = mapStatus[selectedStatus];
                print(index);
              });
            },
            items: status.map((st) {
              return DropdownMenuItem(
                child: new Text(st),
                value: st,
              );
            }).toList(),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Text(
            "Enter the address: ",
            style: TextStyle(
              color: Colors.grey[900],
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(3),
          color: Colors.white,
          child: TextField(
            keyboardType: TextInputType.text,
            onChanged: (input) {
              setState(() {
                address = input;
                print("address $address");
              });
            },
          ),
        ),
                IconButton(
                  icon: Icon(Icons.alarm),
                  onPressed: () async{
                   selectTime(context);

                  },
                ),
                Text(
                  "${selectedTime.hour} : ${selectedTime.minute}"
                ),
                FlatButton(
                  child: Text("Post"),
                  onPressed: () async{
                    await saveToDb();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PostMapScreen()));
                  }
                )
      ]))),
    );
  }

  Future<void> saveToDb() async{
    print("this email ${EmailDb.thisEmail}");
    print("this user ${UserDb.userMap[EmailDb.thisEmail]}");
    DateTime time = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.hour, selectedDate.minute);
    Position pos = await Geolocate.getLatLong(address);
    Post p = await PostDb.createPost(UserDb.emailMap[EmailDb.thisEmail], selectedStatus, DateTime.now(), pos.latitude, pos.longitude, time, descriptionStr, address);
    Set<int> posts = UserDb.userMap[UserDb.emailMap[EmailDb.thisEmail]].postIdList;
    posts.add(p.id);
    await UserDb.updateData(UserDb.emailMap[EmailDb.thisEmail], postIdList: posts);
  }

}

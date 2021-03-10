import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frc_challenge_app/components/common_app_bar.dart';
import 'package:frc_challenge_app/db_services/category_db.dart';
import 'package:frc_challenge_app/db_services/email_db.dart';
import 'package:frc_challenge_app/db_services/post_db.dart';
import 'package:frc_challenge_app/db_services/user_db.dart';
import 'package:frc_challenge_app/models/post.dart';
import 'package:frc_challenge_app/models/user.dart';
import 'package:frc_challenge_app/screens/post_pages/post_map_screen.dart';
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
  static final List status = ["private", "public"];
  static Map<String, int> mapStatus = {
    "private": 0,
    "public": 1,
    //"restricted": 2
  };

  static final List categories = CategoryDb.categoryList.toList();

  /*static Map<String, int> mapSports = {
    "ball games": 0,
    "track and field": 1,
    //"restricted": 2
  }; */

  String descriptionStr = "";
  String infoStr = "";
  String activity = "";
  String dropdownMonth = "";
  String dropdownYear = "";
  String dropdownDay = "";
  String address = '';
  bool invalidcaps = false;
  bool invalidDate = false;
  bool invalidAddress = false;

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

  static int cap;

  static String selectedCategory = "ball games";

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

  Future<Null> selectTime(BuildContext context) async {
    _time = await showTimePicker(context: context, initialTime: selectedTime);
    setState(() {
      if (_time != null) {
        selectedTime = _time;
      }
      // selectedTime = selectedTime;

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create a Post", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(163,193, 227, 1),
      ),
      body: SingleChildScrollView(
          child: Container(
              child: Column(children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(vertical: 35),
          child: Text(
            "  Enter the activity type: ",
            style: TextStyle(
              color: Colors.grey[900],
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Container(
        //   alignment: Alignment.centerLeft,
        //   padding: EdgeInsets.symmetric(vertical: 5),
        //   child: Text(
        //     "    Ex: Soccer, Basketball",
        //     style: TextStyle(
        //       color: Colors.grey[700],
        //       fontSize: 14,
        //
        //     ),
        //   ),
        //
        // ),

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
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Text(
            "  Enter a description of the event:  ",
            style: TextStyle(
              color: Colors.grey[900],
              fontSize: 22,
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
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Text(
            "  Enter max number of people:  ",
            style: TextStyle(
              color: Colors.grey[900],
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(3),
          color: Colors.white,
          child: TextField(
            keyboardType: TextInputType.number,
            onChanged: (input) {
              setState(() {
                cap = int.parse(input);
              });
            },
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 20),
        ),

        Container(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "${selectedDate.toLocal()}".split(' ')[0],
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
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
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              color: Colors.lightBlue[200],
            ),
          ],
        )),

        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Text(
            "  Select status: ",
            style: TextStyle(
              color: Colors.grey[900],
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

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
          child: DropdownButton(
            hint: Text('category'), // Not necessary for Option 1
            value: categories[categories.indexOf(selectedCategory)],
            onChanged: (newValue) {
              setState(() {
                selectedCategory = newValue;
                int index = categories.indexOf(selectedCategory);
                print(index);
              });
            },
            items: categories.map((st) {
              return DropdownMenuItem(
                child: new Text(st),
                value: st,
              );
            }).toList(),
          ),
        ),

        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Text(
            "  Enter the time: ",
            style: TextStyle(
              color: Colors.grey[900],
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.alarm),
          onPressed: () async {
            selectTime(context);
          },
        ),
        Text("${selectedTime.hour} : ${selectedTime.minute}"),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Text(
            "  Enter the address: ",
            style: TextStyle(
              color: Colors.grey[900],
              fontSize: 22,
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
        Container(
          padding: EdgeInsets.symmetric(vertical: 6),
        ),

        (invalidcaps)
            ? Container(
                child: Center(
                  child: Text(
                    "Max number of people allowed has to be greater than 1",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              )
            : Container(),
                (invalidDate)
                ? (Container(
                    child: Center(
                      child: Text(
                        "Set a date after the current date and time.",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ))
                : Container(),
                (invalidAddress) ? Container(
                  child: Center(
                    child: Text("Invalid Address", style: TextStyle(color: Colors.red),),
                  ),
                ) : Container(),

        FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
                side: BorderSide(
                  color: Colors.lightBlue[200],
                )),
            color: Colors.lightBlue[200],
            child: Text("Post",
                style: TextStyle(fontSize: 20, color: Colors.white)),
            onPressed: () async {
              DateTime time = DateTime(selectedDate.year, selectedDate.month,
                  selectedDate.day, selectedTime.hour, selectedDate.minute);
              bool error = false;

              try {
                Position p = await Geolocate.getLatLong(address);
              }

              catch(e){
                error = true;
                setState(() {
                  invalidAddress = true;
                });

              }
              if (cap < 2) {
                setState(() {
                  invalidcaps = true;
                });
                error = true;
              }
              if (!time.isAfter(DateTime.now())) {
                setState(() {
                  invalidDate = true;
                });
                error = true;
              }

                if(!error) {
                  print('asdfasdfadsfasdfasdfadsf 385');
                  await saveToDb();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => PostMapScreen()));
                }
            }),
      ]))),
    );
  }

  Future<void> saveToDb() async {
    print("this email ${EmailDb.thisEmail}");
    print("this user ${UserDb.userMap[EmailDb.thisEmail]}");
    DateTime time = DateTime(selectedDate.year, selectedDate.month,
        selectedDate.day, selectedTime.hour, selectedDate.minute);
    Position pos = await Geolocate.getLatLong(address);
    User thisUser = UserDb.userMap[UserDb.emailMap[EmailDb.thisEmail]];
    Post p = await PostDb.createPost(
      thisUser.id,
      selectedStatus,
      DateTime.now(),
      pos.latitude,
      pos.longitude,
      time,
      descriptionStr,
      address,
      selectedCategory,
      cap,
    );
    Set<int> posts = thisUser.postIdList;
    posts.add(p.id);
    await UserDb.updateData(thisUser.id, postIdList: posts);
  }
}

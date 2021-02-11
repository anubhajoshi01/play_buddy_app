import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frc_challenge_app/components/common_app_bar.dart';
import 'package:frc_challenge_app/services/geolocator.dart';

class CreatePostScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CreatePostScreen();
  }
}

class _CreatePostScreen extends State<CreatePostScreen> {

  String descriptionStr = "";
  String infoStr = "";
  String activity = "";
  String dropdownMonth = "";
  String dropdownYear = "";
  String dropdownDay = "";
  String address='';
  static final List status = ["private","public","restricted"];
  static Map <String, int> mapStatus =  { "private":0, "public":1, "restricted":2} ;


  static DateTime selectedDate;
  static String selectedStatus ="";


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
              child: Column(
        children: <Widget>[
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
            child:Column(
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
                  onPressed: () => _selectDate(context), // Refer step 3
                  child: Text(
                    'Select date',
                    style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  color: Colors.greenAccent,
                ),
              ],
            )
          ),
          Container(
            child:DropdownButton(
              hint: Text('Status'), // Not necessary for Option 1
              value: status[0],
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
                  var pos = Geolocate.getLatLong(address);
                });
              },
            ),
          )



           ] )
      )),
    );
  }
}

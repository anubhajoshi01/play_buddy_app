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
  String descriptionStr = "";
  String infoStr = "";
  String activity = "";
  String dropdownMonth = "";
  String dropdownYear = "";
  String dropdownDay = "";
  static final List years = [2021, 2022, 2023, 2024];
  static final List months = [01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12];

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

            child:Row(children:<Widget> [
                DropdownButton(
                  value: dropdownMonth,
                  hint:Text("Months"),
                  icon:Icon(Icons.arrow_drop_down),
                  onChanged: (newValue) {
                    setState:
                    (() {
                      dropdownMonth = newValue;
                    });
                  },
                  items:
                    months.map((valueItem) {
                      return DropdownMenuItem(
                        value: valueItem,
                        child: Text("$valueItem"),
                      );
                    }).toList()
              ),

              DropdownButton(
                  value: dropdownDay,
                  hint:Text("Months"),
                  icon:Icon(Icons.arrow_drop_down),
                  onChanged: (newValue) {
                    setState:
                    (() {
                      dropdownDay = newValue;
                    });
                  },
                  items:
                    months.map((valueItem) {
                      return DropdownMenuItem(
                        value: valueItem,
                        child: Text("$valueItem"),
                      );
                    }).toList()
              ),

              DropdownButton(
                  value: dropdownYear,
                  hint:Text("Years"),
                  icon:Icon(Icons.arrow_drop_down),
                  onChanged: (newValue) {
                    setState:
                    (() {
                      dropdownYear = newValue;
                    });
                  },
                  items:
                    months.map((valueItem) {
                      return DropdownMenuItem(
                        value: valueItem,
                        child: Text("$valueItem"),
                      );
                    }).toList()
              ),
          ]
          ),
          )
        
        ],
      ))

 
                  
           
                
      
      ),
    );
  }
}

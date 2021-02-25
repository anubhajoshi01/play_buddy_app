import 'package:async_loader/async_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frc_challenge_app/db_services/auth_service.dart';
import 'package:frc_challenge_app/screens/post_pages/post_map_screen.dart';
import 'package:frc_challenge_app/screens/auth_pages/log_in_screen.dart';


class SignInScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignInScreen();
  }
}

class _SignInScreen extends State<StatefulWidget> {
  String email;
  String password;
  bool authError = false;
  final GlobalKey<AsyncLoaderState> _asyncLoaderState = new GlobalKey<AsyncLoaderState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Workout Buddy",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.lightBlue[100],
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  // maybe add a logo here
                  padding: EdgeInsets.symmetric(vertical: 35),
                  child: Text("Sign Up",
                      style: TextStyle(
                        color: Colors.grey[900],
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      )
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left:15.0),
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text("Enter your email",
                      style: TextStyle(
                        color: Colors.grey[900],
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(3),
                  color: Colors.white,
                  child: TextField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: "   Email"
                    ),
                    onChanged: (input){
                      setState(() {
                        email = input;
                      });
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left:15.0),
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Text(
                    "Enter a password",
                    style: TextStyle(
                      color: Colors.grey[900],
                      fontSize:20,
                      fontWeight: FontWeight.bold,

                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(3),
                  color: Colors.white,
                  child: TextField(
                    keyboardType: TextInputType.text,

                    decoration: InputDecoration(
                        hintText: "   Password"
                    ),
                    obscureText: true,

                    onChanged: (input){
                      setState(() {
                        password = input;
                      });
                    },
                  ),
                ),

                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),

                FlatButton(

                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.lightBlueAccent)
                  ),
                  color: Colors.lightBlue[100],
                  child: Text("Sign Up",
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),

                  // color: Colors.red,
                  // child: Text("Sign up"),

                  onPressed: () async{
                    bool success = await AuthenticationService.signUpWithEmail(email, password);
                    print(success);
                    if(success != null && success){
                      print("Success");
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PostMapScreen()));
                    }
                    else{
                      setState(() {
                        print("auth failed. try again");
                        authError = true;
                      });
                    }
                  },
                ),

                Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                ),
            InkWell(
              child: Text("Have an account? Log in"),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => LogInScreen()
                ));
              }
              ),
                (authError) ? Text("${AuthenticationService.errMessage}") : Container()
              ],
            )
          ),
        ));
  }
}

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
          title: Text("Sign up"),
          backgroundColor: Colors.greenAccent,
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 40),
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
                    onChanged: (input){
                      setState(() {
                        email = input;
                      });
                    },
                  ),
                ),
                Container(
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
                    obscureText: true,
                    onChanged: (input){
                      setState(() {
                        password = input;
                      });
                    },
                  ),
                ),
                FlatButton(
                  color: Colors.red,
                  child: Text("sign up"),
                  onPressed: () async{
                    bool success = await AuthenticationService.signUpWithEmail(email, password);
                    print(success);
                    if(success != null && success){
                      print("success");
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PostMapScreen()));
                    }
                    else{
                      setState(() {
                        authError = true;
                      });
                    }
                  },
                ),
            InkWell(
              child: Text("have an account? log in"),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => LogInScreen()
                ));
              }
              ),
                (authError) ? Text("Auth failed. try again") : Container()
              ],
            )
          ),
        ));
  }
}

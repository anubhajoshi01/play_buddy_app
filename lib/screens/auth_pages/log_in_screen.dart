import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frc_challenge_app/db_services/auth_service.dart';
import 'package:frc_challenge_app/db_services/user_db.dart';
import 'package:frc_challenge_app/screens/post_pages/post_map_screen.dart';
import 'package:frc_challenge_app/screens/auth_pages/sign_in_screen.dart';

class LogInScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _LogInScreen();
  }
}

class _LogInScreen extends State<LogInScreen>{

  String email;
  String password;
  bool authError = false;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Log in"),
        backgroundColor: Colors.lightBlue,
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
                    color: Colors.lightBlueAccent,
                    child: Text("Log in"),
                    onPressed: () async{
                      bool success = await AuthenticationService.loginWithEmail(email, password);
                      if(success != null && success){
                        print(success);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PostMapScreen()));
                      }
                      else{
                        setState(() {
                          print("fail");
                          authError = true;
                        });
                      }
                    },
                  ),
                  InkWell(
                    child: Text("Don't have an account? Sign up!"),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                      builder: (context) => SignInScreen()
                      ));
                    }
                  ),
                  (authError) ? Text("Auth failed. try again") : Container()
                ],
              )
          ),
        )
    );
  }
}
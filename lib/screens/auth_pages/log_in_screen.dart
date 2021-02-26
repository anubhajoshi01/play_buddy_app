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
        title: Text("  Workout Buddy",
            style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.lightBlue[100],
      ),
        body: SingleChildScrollView(

          child: Container(

              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     image: AssetImage("play_buddy_app/playappbackground.png"),
              //     fit: BoxFit.cover,
              //   ),
              // ),

              child: Column(
                children: <Widget>[
                  Container(
                    // maybe add a logo here
                    padding: EdgeInsets.symmetric(vertical: 35),
                    child: Text("Login",
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
                    child: Text("Enter email",
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
                      // decoration: InputDecoration(
                      //   hintText: 'Enter your email here',
                      //   hintStyle: TextStyle(fontSize:16),
                      //   border: OutlineInputBorder(
                      //     borderRadius: BorderRadius.circular(8),
                      //     borderSide: BorderSide(
                      //       width: 100,
                      //       style: BorderStyle.none
                      //     ),
                      //   ),
                      //
                      // ),

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
                      "Enter password",
                      style: TextStyle(
                        color: Colors.grey[900],
                        fontSize:20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: TextField(
                      keyboardType: TextInputType.text,

                      decoration: InputDecoration(
                          hintText: "   Password"
                      ),
                      // decoration: InputDecoration(
                      //   hintText: 'Enter your email here',
                      //   hintStyle: TextStyle(fontSize:16),
                      //   border: OutlineInputBorder(
                      //     borderRadius: BorderRadius.circular(8),
                      //     borderSide: BorderSide(
                      //         width: 100,
                      //         style: BorderStyle.none
                      //     ),
                      //   ),
                      //
                      // ),

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
                        side: BorderSide(color: Colors.lightBlue[100])
                    ),
                    color: Colors.lightBlue[100],

                    child: Text("Log In",
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                    onPressed: () async{
                      bool success = await AuthenticationService.loginWithEmail(email, password);
                      if(success != null && success){
                        print(success);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PostMapScreen()));
                      }
                      else{
                        setState(() {
                          print("fail");
                          print("162 162");
                          authError = true;
                        });
                      }
                    },
                  ),

                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                  ),

                  InkWell(
                    child: Text("Don't have an account? Sign up!"),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                      builder: (context) => SignInScreen()
                      ));
                    }
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                  ),
                  (authError) ? Text("${AuthenticationService.errMessage}", style: TextStyle(color: Colors.red),) : Container()

                ],
              )
          ),
        )
    );
  }
}
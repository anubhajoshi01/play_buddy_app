
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:frc_challenge_app/db_services/user_db.dart';

import 'email_db.dart';

class AuthenticationService{

  static final firebaseAuth = FirebaseAuth.instance;
  static FirebaseUser user;

  static String errMessage = "";

  static Future<bool> loginWithEmail(String email, String password) async{
    EmailDb.addEmail(email);
    EmailDb.addBool(true);
    try{
      var user = await firebaseAuth.signInWithEmailAndPassword(email:email, password:password);
      return user != null;
    } catch(e){
      //print(e.code);
      errMessage =  await e.message;
      print(e.toString());
      return null;
    }
  }

  static Future<bool> signUpWithEmail(String email, String password) async{
    EmailDb.addBool(true);
    EmailDb.addEmail(email);
    try{
      var authResult = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      await UserDb.writeToDb(email);
      print("at ${authResult.user != null}");
      return authResult.user != null;
    }
    catch(e){
      errMessage = await e.message;
      print(e.toString());
      return null;
    }
  }

  static void signOutUser(){
    firebaseAuth.signOut().then((value) =>
    {
      EmailDb.addBool(false),
      print("sign out")
    });
  }

}
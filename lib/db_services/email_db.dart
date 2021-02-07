
import 'package:hive/hive.dart';

class EmailDb {

  static bool loggedIn;
  static String thisEmail;
  static Box box;

  static Future<bool> init() async{
    await initBox();
    loggedIn = await box.get("isLoggedIn");
    thisEmail = await box.get("email");
    print(loggedIn);
    print(thisEmail);
  }


  static Future<void> initBox() async {
    if (box == null) {
      box = await Hive.openBox("local db");
    }
  }

  static Future<void> addEmail(String email) async {
    thisEmail= email;
    await initBox();
    print("added email");
    return await box.put('email', email);
  }

  static Future<void> addBool(bool x) async {
    loggedIn = x;
    await initBox();
    print("added logged in");
    return await box.put('isLoggedIn', x);
  }

}
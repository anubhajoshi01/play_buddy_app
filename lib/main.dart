import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'db_services/email_db.dart';
import 'db_services/post_db.dart';
import 'db_services/user_db.dart';

void main() async {
  await Hive.initFlutter();
  await UserDb.syncUserMap();
  await EmailDb.addEmail("shgcw");
  await EmailDb.addBool(true);
  await EmailDb.init();
  await PostDb.readDb();
  runApp(MyApp());
}

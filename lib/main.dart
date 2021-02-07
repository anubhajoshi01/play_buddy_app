import 'package:flutter/material.dart';

import 'app.dart';
import 'db_services/user_db.dart';

void main() async {
  await UserDb.syncUserMap();
  runApp(MyApp());
}

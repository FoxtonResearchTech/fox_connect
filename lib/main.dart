import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fox_connect/presentation/authentication/account_creation.dart';
import 'package:fox_connect/presentation/leave/status.dart';
import 'package:fox_connect/presentation/task/task_registration.dart';
import 'package:fox_connect/widget/bottom_nav_bar.dart';
import 'package:fox_connect/widget/connectivity_checker.dart';

import 'firebase_options.dart';
import 'presentation/authentication/login_page.dart';
import 'presentation/leave/leave_registration.dart';
import 'presentation/profile/employee_profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ConnectivityChecker(child: EmployeeBottomNavBar()),
    );
  }
}

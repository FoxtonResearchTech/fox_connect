import 'package:flutter/material.dart';
import 'package:fox_connect/presentation/task/task_registration.dart';
import 'package:fox_connect/widget/connectivity_checker.dart';

import 'presentation/authentication/account_creation.dart';
import 'presentation/authentication/login_page.dart';
import 'presentation/leave/leave_registration.dart';
import 'presentation/profile/employee_profile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ConnectivityChecker(child: AdminAddEmployee()),
    );
  }
}

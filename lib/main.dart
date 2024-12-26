import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fox_connect/widget/admin_bottom_nav_bar.dart';
import 'package:fox_connect/widget/bottom_nav_bar.dart';
import 'package:fox_connect/widget/connectivity_checker.dart';

import 'firebase_options.dart';
import 'presentation/authentication/login_page.dart';
import 'presentation/leave/status.dart'; // For Flutter Developer role
import 'presentation/task/task_registration.dart'; // For Administrator role

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ConnectivityChecker(
        child: AuthChecker(),
      ),
    );
  }
}

class AuthChecker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          // User is signed in, fetch role
          return RoleBasedNavigator(userId: snapshot.data!.uid);
        } else {
          // User is not signed in
          return LoginScreen();
        }
      },
    );
  }
}

class RoleBasedNavigator extends StatelessWidget {
  final String userId;

  const RoleBasedNavigator({required this.userId});

  Future<String?> _getUserRole() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('employees')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        return userDoc['roles'] as String?;
      }
    } catch (e) {
      print('Error fetching user role: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getUserRole(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: SpinKitCubeGrid(
                color:Color(0xffFF0000),
                size: 50.0,
              ),
            ),
          );
        }

        if (snapshot.hasData) {
          String? role = snapshot.data;

          if (role != 'Administrator') {
            return EmployeeBottomNavBar(); // Navigate to the leave status screen
          } else if (role == 'Administrator') {
            return AdminBottomNavBar(); // Navigate to the task registration screen
          } else {
            return LoginScreen();
          }
        } else {
          return const Scaffold(
            body: Center(
              child: Text(
                'Error fetching user role. Please try again later.',
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
        }
      },
    );
  }
}

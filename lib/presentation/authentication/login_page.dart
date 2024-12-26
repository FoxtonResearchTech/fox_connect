import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:fox_connect/presentation/leave/status.dart';
import 'package:fox_connect/presentation/task/task_registration.dart';
import 'package:fox_connect/widget/admin_bottom_nav_bar.dart';
import 'package:fox_connect/widget/bottom_nav_bar.dart';
import 'package:fox_connect/widget/connectivity_checker.dart';
import 'package:fox_connect/widget/custom_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideInAnimation;

  bool _isLoading = false;
  String? _errorMessage;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _slideInAnimation =
        Tween<Offset>(begin: Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    final email = _emailController.text.trim() + '@gmail.com';
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = "Employee code and password are required.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Fetching user document from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('employees')
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists) {
        bool isActive =
            userDoc['isActive'] ?? false; // Check the `isActive` field
        String role = userDoc['roles'] ?? ''; // Fetch the role field

        if (!isActive) {
          setState(() {
            _errorMessage = "Your account is not active. Contact support.";
          });
          return;
        }

        // Navigate based on role
        if (role == 'Flutter Developer') {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EmployeeBottomNavBar()),
          );
        } else if (role == 'Administrator') {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminBottomNavBar()),
          );
        } else {
          setState(() {
            _errorMessage = "User role not recognized. Contact support.";
          });
        }
      } else {
        setState(() {
          _errorMessage = "User document not found. Contact support.";
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message; // Firebase error message
      });
    } catch (e) {
      setState(() {
        _errorMessage = "An unexpected error occurred. Please try again.";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return ConnectivityChecker(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Center(
                  child: FadeTransition(
                    opacity: _fadeInAnimation,
                    child: SlideTransition(
                      position: _slideInAnimation,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Logo and Title
                            SizedBox(
                              height: 120,
                            ),
                            Image.asset("assets/logo.jpg").animate().scale(
                                duration: const Duration(milliseconds: 1200),
                                curve: Curves.elasticOut),

                            if (_errorMessage != null) ...[
                              SizedBox(height: 10),
                              Text(
                                _errorMessage!,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],

                            SizedBox(height: 20),

                            // Username Field
                            TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person,
                                    color: Color(0xFF00008B)),
                                labelText: 'Employee Code',
                                labelStyle: TextStyle(
                                  color: Color(0xFF00008B),
                                  fontFamily: 'LeagueSpartan',
                                ),
                                filled: true,
                                fillColor: Color(0xFF00008B).withOpacity(0.1),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ).animate().fade(
                                duration: const Duration(milliseconds: 1000),
                                curve: Curves.easeInOut),

                            SizedBox(height: 20),

                            // Password Field
                            TextField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                prefixIcon:
                                    Icon(Icons.lock, color: Color(0xFF00008B)),
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                  color: Color(0xFF00008B),
                                  fontFamily: 'LeagueSpartan',
                                ),
                                filled: true,
                                fillColor: Color(0xFF00008B).withOpacity(0.1),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              obscureText: true,
                            ).animate().fade(
                                delay: const Duration(milliseconds: 200),
                                duration: const Duration(milliseconds: 1000),
                                curve: Curves.easeInOut),

                            SizedBox(height: 30),

                            // Login Button
                            CustomButton(
                                    text: "Login",
                                    onPressed: () {
                                      _login();
                                    })
                                .animate()
                                .move(
                                    delay: const Duration(milliseconds: 400),
                                    duration:
                                        const Duration(milliseconds: 1000),
                                    curve: Curves.easeInOut),

                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

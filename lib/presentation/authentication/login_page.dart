import 'package:flutter/material.dart';

import 'package:flutter_animate/flutter_animate.dart';
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

  void _login() {
    final email = _emailController.text.trim();
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

    // Simulating authentication
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });

      // Dummy roles for demonstration
      if (email == "organizer" && password == "1234") {
      } else {
        setState(() {
          _errorMessage = "Invalid credentials.";
        });
      }
    });
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
                                prefixIcon:
                                    Icon(Icons.person, color: Colors.black87),
                                labelText: 'Employee Code',
                                labelStyle: TextStyle(
                                  color: Colors.black87,
                                  fontFamily: 'LeagueSpartan',
                                ),
                                filled: true,
                                fillColor: Color(0xff606060).withOpacity(0.1),
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
                                    Icon(Icons.lock, color: Colors.black87),
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                  color: Colors.black87,
                                  fontFamily: 'LeagueSpartan',
                                ),
                                filled: true,
                                fillColor: Color(0xff606060).withOpacity(0.1),
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
                            CustomButton(text: "Login", onPressed: () {})
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

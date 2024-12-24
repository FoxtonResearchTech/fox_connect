import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:lottie/lottie.dart';

class ConnectivityChecker extends StatefulWidget {
  final Widget child;

  const ConnectivityChecker({super.key, required this.child});

  @override
  State<ConnectivityChecker> createState() => _ConnectivityCheckerState();
}

class _ConnectivityCheckerState extends State<ConnectivityChecker> {
  bool isConnected = true;

  @override
  void initState() {
    super.initState();

    // Check the initial connectivity status
    Connectivity().checkConnectivity().then((ConnectivityResult result) {
      setState(() {
        isConnected = result != ConnectivityResult.none;
      });
    });

    // Listen to connectivity changes
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        isConnected = result != ConnectivityResult.none;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // If connected, show the child widget; otherwise, show the Lottie animation
    return isConnected
        ? widget.child
        : Container(
      color: Colors.white,
      child: Center(
        child: Lottie.asset(
          'assets/no_internet.json', // Path to your Lottie file
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}

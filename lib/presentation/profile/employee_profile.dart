import 'package:flutter/material.dart';
import 'package:fox_connect/widget/connectivity_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../authentication/login_page.dart';

class EmployeeProfilePage extends StatefulWidget {
  @override
  _EmployeeProfilePage createState() => _EmployeeProfilePage();
}

class _EmployeeProfilePage extends State<EmployeeProfilePage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  Map<String, dynamic> employee = {};
  bool isLoading = true;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(-1.0, 0.0), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward(); // Start the animation
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Get the currently logged-in user
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Use the user's UID to fetch their profile data
        String uid = currentUser.uid;

        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('employees') // Replace with your collection name
            .doc(uid)
            .get();

        if (documentSnapshot.exists) {
          setState(() {
            employee = documentSnapshot.data() as Map<String, dynamic>;
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = 'Employee data not found';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'No user is currently logged in';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load data: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityChecker(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Profile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'LeagueSpartan',
            ),
          ),
          centerTitle: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF00008B),
                  const Color(0xFF00008B).withOpacity(1),
                  const Color(0xFF00008B).withOpacity(0.8)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(seconds: 1),
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF00008B),
                    const Color(0xFF00008B).withOpacity(1),
                    const Color(0xFF00008B).withOpacity(0.8)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
            ),
            AnimatedPadding(
              duration: const Duration(seconds: 1),
              padding: const EdgeInsets.only(top: 60),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : errorMessage.isNotEmpty
                      ? Center(
                          child: Text(
                            errorMessage,
                            style: const TextStyle(
                              fontFamily: 'LeagueSpartan',
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            const Center(
                              child: CircleAvatar(
                                backgroundImage: AssetImage("assets/logo.jpg"),
                                radius: 50,
                              ),
                            ),
                            const SizedBox(height: 15),
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 500),
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              child: Text(
                                '${employee['firstName']} ${employee['lastName']}',
                                style: const TextStyle(
                                  fontFamily: 'LeagueSpartan',
                                ),
                              ),
                            ),
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 500),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                              child: Text(
                                employee['roles'] ?? "N/A",
                                style: const TextStyle(
                                  fontFamily: 'LeagueSpartan',
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Expanded(
                              child: AnimatedContainer(
                                duration: const Duration(seconds: 1),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 30),
                                margin: const EdgeInsets.only(top: 20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 5,
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ProfileInfoTile(
                                        icon: Icons.person,
                                        title: 'DOB',
                                        subtitle: employee['dob'] ?? 'N/A',
                                        slideAnimation: _slideAnimation,
                                      ),
                                      ProfileInfoTile(
                                        icon: Icons.people,
                                        title: 'Gender',
                                        subtitle: employee['gender'] ?? 'N/A',
                                        slideAnimation: _slideAnimation,
                                      ),
                                      ProfileInfoTile(
                                        icon: Icons.place,
                                        title: 'Lane 1',
                                        subtitle: employee['lane1'] ?? 'N/A',
                                        slideAnimation: _slideAnimation,
                                      ),
                                      ProfileInfoTile(
                                        icon: Icons.place,
                                        title: 'Lane 2',
                                        subtitle: employee['lane2'] ?? 'N/A',
                                        slideAnimation: _slideAnimation,
                                      ),
                                      ProfileInfoTile(
                                        icon: Icons.location_city_outlined,
                                        title: 'State',
                                        subtitle: employee['state'] ?? 'N/A',
                                        slideAnimation: _slideAnimation,
                                      ),
                                      ProfileInfoTile(
                                        icon: Icons.my_location,
                                        title: 'Pincode',
                                        subtitle: employee['pincode'] ?? 'N/A',
                                        slideAnimation: _slideAnimation,
                                      ),
                                      ProfileInfoTile(
                                        icon: Icons.supervised_user_circle,
                                        title: 'Employee id',
                                        subtitle: employee['empCode'] ?? 'N/A',
                                        slideAnimation: _slideAnimation,
                                      ),
                                      ProfileInfoTile(
                                        icon: Icons.money,
                                        title: 'Bank Name',
                                        subtitle: employee['bankName'] ?? 'N/A',
                                        slideAnimation: _slideAnimation,
                                      ),
                                      ProfileInfoTile(
                                        icon: Icons.account_balance,
                                        title: 'Account Number',
                                        subtitle:
                                            employee['accountNo'] ?? 'N/A',
                                        slideAnimation: _slideAnimation,
                                      ),
                                      ProfileInfoTile(
                                        icon: Icons
                                            .account_balance_wallet_rounded,
                                        title: 'IFSC',
                                        subtitle: employee['IFSC'] ?? 'N/A',
                                        slideAnimation: _slideAnimation,
                                      ),
                                      ProfileInfoTile(
                                        icon: Icons.place_sharp,
                                        title: 'Branch',
                                        subtitle:
                                            employee['Branch Name'] ?? 'N/A',
                                        slideAnimation: _slideAnimation,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          bool? confirmLogout =
                                              await showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text(
                                                  'Logout',
                                                  style: TextStyle(
                                                    fontFamily: 'LeagueSpartan',
                                                  ),
                                                ),
                                                content: const Text(
                                                  'Are you sure you want to Logout?',
                                                  style: TextStyle(
                                                    fontFamily: 'LeagueSpartan',
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, false),
                                                    child: const Text(
                                                      'Cancel',
                                                      style: TextStyle(
                                                        color: Colors.blue,
                                                        fontFamily:
                                                            'LeagueSpartan',
                                                      ),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context, true);
                                                    },
                                                    child: const Text(
                                                      'Logout',
                                                      style: TextStyle(
                                                        color: Colors.blue,
                                                        fontFamily:
                                                            'LeagueSpartan',
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                          if (confirmLogout == true) {
                                            await FirebaseAuth.instance
                                                .signOut();
                                            // Navigate to LoginScreen
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginScreen()),
                                            );
                                          }
                                        },
                                        child: ProfileInfoTile(
                                          icon: Icons.login,
                                          title: 'Logout',
                                          subtitle: 'logout',
                                          slideAnimation: _slideAnimation,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Animation<Offset> slideAnimation;

  ProfileInfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.slideAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slideAnimation,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xffFF0000).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xffFF0000)),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'LeagueSpartan',
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontFamily: 'LeagueSpartan',
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fox_connect/widget/connectivity_checker.dart';

class EmployeeProfilePage extends StatefulWidget {
  @override
  _EmployeeProfilePage createState() => _EmployeeProfilePage();
}

class _EmployeeProfilePage extends State<EmployeeProfilePage> with TickerProviderStateMixin {
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
    _slideAnimation = Tween<Offset>(begin: const Offset(-1.0, 0.0), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward(); // Start the animation
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        employee = {
          'firstName': 'John',
          'lastName': 'Doe',
          'role': 'Camp Incharge',
          'dob': '1990-01-01',
          'gender': 'Male',
          'bloodGroup': 'O+',
          'lane1': 'Lane 1',
          'lane2': 'Lane 2',
          'state': 'California',
          'pincode': '123456',
          'empCode': 'EMP001',
        };
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Failed to load data";
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
                  Color(0xFF0097b2),
                  Color(0xFF0097b2).withOpacity(1),
                  Color(0xFF0097b2).withOpacity(0.8)
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
                    Color(0xFF0097b2),
                    Color(0xFF0097b2).withOpacity(1),
                    Color(0xFF0097b2).withOpacity(0.8)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
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
                  style: TextStyle(
                    fontFamily: 'LeagueSpartan',
                  ),
                ),
              )
                  : Column(
                children: [
                  Center(
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
                      style: TextStyle(
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
                      employee['role'],
                      style: TextStyle(
                        fontFamily: 'LeagueSpartan',
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                              icon: Icons.bloodtype,
                              title: 'Blood Group',
                              subtitle: employee['bloodGroup'] ?? 'N/A',
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
                            GestureDetector(
                              onTap: () async {
                                bool? confirmLogout = await showDialog(
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
                                              Navigator.pop(context, false),
                                          child: const Text('Cancel',
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontFamily: 'LeagueSpartan',
                                              )),
                                        ),
                                        TextButton(
                                          onPressed: () {},
                                          child: const Text('Logout',
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontFamily: 'LeagueSpartan',
                                              )),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                if (confirmLogout == true) {}
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
            color: Color(0xFF0097b2).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Color(0xFF0097b2)),
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
          style: TextStyle(
            fontFamily: 'LeagueSpartan',
          ),
        ),
      ),
    );
  }
}

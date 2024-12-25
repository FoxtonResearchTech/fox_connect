
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fox_connect/presentation/admin/employee_task/view_employee_task.dart';
import 'package:fox_connect/presentation/admin/leave_approvel/leave_approval.dart';
import 'package:fox_connect/presentation/leave/leave_registration.dart';
import 'package:fox_connect/presentation/leave/status.dart';
import 'package:fox_connect/presentation/profile/employee_profile.dart';
import 'package:fox_connect/presentation/task/task_registration.dart';
import 'package:fox_connect/widget/connectivity_checker.dart';



class AdminBottomNavBar extends StatefulWidget {
  @override
  _AdminBottomNavBarState createState() =>
      _AdminBottomNavBarState();
}

class _AdminBottomNavBarState extends State<AdminBottomNavBar> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    ViewEmployeeTask(),
    LeaveApprovel(),
    RegisterLeave(),
    LeaveStatus(),


  ];

  @override
  Widget build(BuildContext context) {
    return ConnectivityChecker(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: _pages[_currentIndex],
          bottomNavigationBar: CurvedNavigationBar(
            index: _currentIndex,
            height: 60.0,
            items: <Widget>[
              FaIcon(FontAwesomeIcons.tasks,
                  size: 30,
                  color: _currentIndex == 0 ? Color(0xffFF0000) : Colors.white),
              FaIcon(FontAwesomeIcons.houseLaptop,
                  size: 30,
                  color: _currentIndex == 1 ? Color(0xffFF0000) : Colors.white),
              FaIcon(FontAwesomeIcons.chartLine,
                  size: 30,
                  color: _currentIndex == 2 ? Color(0xffFF0000) : Colors.white),
              Icon(Icons.person,
                  size: 30,
                  color: _currentIndex == 3 ? Color(0xffFF0000) : Colors.white),

            ],
            color:Color(0xFF00008B),
            buttonBackgroundColor: Color(0xffFF0000).withOpacity(0.2),
            backgroundColor: Colors.transparent,
            animationCurve: Curves.easeInOut,
            animationDuration: Duration(milliseconds: 300),
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ));
  }
}

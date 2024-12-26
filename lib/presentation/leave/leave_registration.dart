import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fox_connect/widget/connectivity_checker.dart';
import 'package:fox_connect/widget/custom_dropdown.dart';
import 'package:fox_connect/widget/custom_text_form_field.dart';

import '../../widget/custom_button.dart';

class RegisterLeave extends StatefulWidget {
  const RegisterLeave({super.key});

  @override
  State<RegisterLeave> createState() => _RegisterLeaveState();
}

class _RegisterLeaveState extends State<RegisterLeave>
    with SingleTickerProviderStateMixin {
  late TextEditingController _dateController;
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  final List<String> dropdownItems = ['Morning', 'Afternoon'];
  final List<String> leaveType = ['Morning', 'Afternoon', 'Full Day'];
  final List<String> lastLeaveTaken = [
    '1 day ago',
    '2 day ago',
    '3 day ago',
    '4 day ago',
    '5 day ago',
    '6 day ago',
    'Previous week',
    'Previous Month',
    'Other',
  ];

  String? selectedValue;
  String? leaveTypeValue;
  String? lastLeaveTakenvalue;
  final List<String> reasonForLeave = [
    'Marriage',
    'Sick Leave',
    'Travel',
    'Vacation',
    'Family Events',
    "other"
  ];
  final List<String> workFromHome = ["Yes", "No"];
  String? workFromHomeValue;
  String? reasonForLeaveValue;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _opacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _slideAnimation = Tween<Offset>(
            begin: const Offset(0.0, 0.1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward();
  }

  // Method to show the date picker
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
      });
    }
  }

  void _registerLeave() async {
    if (_dateController.text.isEmpty ||
        timeController.text.isEmpty ||
        leaveTypeValue == null ||
        lastLeaveTakenvalue == null ||
        workFromHomeValue == null ||
        reasonForLeaveValue == null) {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white, size: 24),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Please fill out all required fields.',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.orangeAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: Duration(seconds: 3),
        ),
      );

      return;
    }

    try {
      // Get the current logged-in user
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User is not logged in.')),
        );
        return;
      }
      String employeeDocId = currentUser.uid;

      // Prepare the leave data
      Map<String, dynamic> leaveData = {
        'employeeId': employeeDocId, // Add the employee document ID
        'date': _dateController.text,
        'time': timeController.text,
        'leaveType': leaveTypeValue,
        'lastLeaveTaken': lastLeaveTakenvalue,
        'workFromHome': workFromHomeValue,
        'reason': reasonForLeaveValue,
        'otherReason': otherReasonController.text.isNotEmpty
            ? otherReasonController.text
            : null, // Add only if it's filled
        'leaveStatus': 'Waiting',
        'createdAt': FieldValue.serverTimestamp(),
      };

      // Save the data to Firestore under the current user's UID
      DocumentReference leaveDocRef = await FirebaseFirestore.instance
          .collection('employees')
          .doc(currentUser.uid) // Use the logged-in user's UID
          .collection('leave')
          .add(leaveData);

      await leaveDocRef.update({'leaveId': leaveDocRef.id});
      // Success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.white, size: 24),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Leave registered successfully!',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: Duration(seconds: 3),
        ),
      );


      // Clear the form
      _dateController.clear();
      timeController.clear();
      setState(() {});
    } catch (e) {
      // Error handling
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white, size: 24),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Failed to register leave: $e',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: Duration(seconds: 3),
        ),
      );

    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _controller.dispose();
    super.dispose();
  }

  TextEditingController timeController = TextEditingController();
  final TextEditingController leaveTypeController = TextEditingController();
  final TextEditingController otherReasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ConnectivityChecker(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Register Leave',
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
                  Color(0xFF00008B),
                  Color(0xFF00008B).withOpacity(1),
                  Color(0xFF00008B).withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        body: FadeTransition(
          opacity: _opacityAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Leave Details",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 22,
                          fontFamily: 'LeagueSpartan',
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            child: CustomTextFormField(
                              controller: _dateController,
                              onTap: () => _selectDate(context),
                              labelText: 'Date',
                              icon: Icons.date_range,
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            child: CustomTextFormField(
                              controller: timeController,
                              onTap: () async {
                                // Open the time picker when the TextField is tapped
                                TimeOfDay? pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay
                                      .now(), // Set the initial time to the current time
                                );

                                if (pickedTime != null) {
                                  // Format and set the selected time in the TextField
                                  timeController.text =
                                      pickedTime.format(context);
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a time';
                                }
                                return null;
                              },
                              labelText: 'Time',
                              icon: Icons.watch_later,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    ..._buildFormFields(),
                    SizedBox(height: 30),
                    // Submit Button
                    Center(
                        child: CustomButton(
                      text: 'Register',
                      onPressed: () {
                        _registerLeave();
                      },
                    )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFormFields() {
    List<Widget> fields = [
      SizedBox(height: 20),
      CustomDropdownFormField(
        labelText: 'Leave Type',
        value: leaveTypeValue,
        items: leaveType,
        onChanged: (value) {
          setState(() {
            leaveTypeValue = value;
          });
        },
      ),
      SizedBox(height: 20),
      CustomDropdownFormField(
        labelText: 'Last Leave Taken',
        value: lastLeaveTakenvalue,
        items: lastLeaveTaken,
        onChanged: (value) {
          setState(() {
            lastLeaveTakenvalue = value;
          });
        },
      ),
      SizedBox(height: 20),
      CustomDropdownFormField(
        labelText: 'Can you able to work from home',
        value: workFromHomeValue,
        items: workFromHome,
        onChanged: (value) {
          setState(() {
            workFromHomeValue = value;
          });
        },
      ),
      SizedBox(height: 20),
      CustomDropdownFormField(
        labelText: 'Reason for your leave',
        value: reasonForLeaveValue,
        items: reasonForLeave,
        onChanged: (value) {
          setState(() {
            reasonForLeaveValue = value;
          });
        },
      ),
      SizedBox(height: 20),
      _buildCustomTextFormField(
          'Other Reason', Icons.note_alt_outlined, otherReasonController),
    ];
    return fields;
  }

  Widget _buildCustomTextFormField(
      String label, IconData icon, TextEditingController controller) {
    return CustomTextFormField(
      controller: controller,
      labelText: label,
      icon: icon,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please fill out this field';
        }
        return null;
      },
    );
  }
}

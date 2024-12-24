import 'package:flutter/material.dart';
import 'package:fox_connect/widget/connectivity_checker.dart';
import 'package:fox_connect/widget/custom_button.dart';
import 'package:fox_connect/widget/custom_dropdown.dart';
import 'package:fox_connect/widget/custom_text_form_field.dart';
import 'package:intl/intl.dart';

class AdminAddEmployee extends StatefulWidget {
  const AdminAddEmployee({super.key});

  @override
  State<AdminAddEmployee> createState() => _AdminAddEmployeeState();
}

class _AdminAddEmployeeState extends State<AdminAddEmployee> {
  // Controllers for each input field
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController empCodeController = TextEditingController();
  final TextEditingController lane1Controller = TextEditingController();
  final TextEditingController lane2Controller = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController reEnterPasswordController = TextEditingController();

  final List<String> gender = ['Male', 'Female'];
  String? selectedValue;
  final List<String> role = [
    'Flutter Developer',
    'Human Resource',
    'Digital Marketing',
    'Graphics Designer',
    'Administrator',

  ];
  String? selectedRole;

  // Date selection method
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        dobController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
      });
    }
  }

  // Dispose controllers
  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    dobController.dispose();
    positionController.dispose();
    empCodeController.dispose();
    lane1Controller.dispose();
    lane2Controller.dispose();
    stateController.dispose();
    pinCodeController.dispose();
    passwordController.dispose();
    reEnterPasswordController.dispose();
    super.dispose();
  }

  // Function to handle form submission
  void _registerEmployee() {
    if (passwordController.text != reEnterPasswordController.text) {
      _showSnackBar("Passwords do not match");
      return;
    }

    // Log the employee data
    print({
      'firstName': firstNameController.text.trim(),
      'lastName': lastNameController.text.trim(),
      'dob': dobController.text,
      'gender': selectedValue,
      'notification': positionController.text.trim(),
      'empCode': empCodeController.text.trim(),
      'lane1': lane1Controller.text.trim(),
      'lane2': lane2Controller.text.trim(),
      'role': selectedRole,
      'state': stateController.text.trim(),
      'pinCode': pinCodeController.text.trim(),
      'password': passwordController.text.trim(),
    });

    _showSnackBar("Employee Registered Successfully!");
  }

  // Function to show snackbar messages
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'LeagueSpartan',
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityChecker(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          title: const Text(
            'Employee Registration',
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
                  Color(0xFF0097b2).withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Create Accounts',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'LeagueSpartan',
                  ),
                ),
                SizedBox(height: 30),
                Center(
                  child: CircleAvatar(radius: 60,),
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        labelText: 'First Name',
                        controller: firstNameController,
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: CustomTextFormField(
                        labelText: 'Last Name',
                        controller: lastNameController,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: dobController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'D.O.B',
                          border: OutlineInputBorder(  borderSide:
                          BorderSide(color:Color(0xffFF0000), width: 2),),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () => _selectDate(context),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                            BorderSide(color:Color(0xffFF0000), width: 2), // Focus color
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: CustomDropdownFormField(
                        labelText: "Gender",
                        items: gender,
                        value: selectedValue,
                        onChanged: (newValue) {
                          setState(() {
                            selectedValue = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select an option';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                CustomDropdownFormField(
                  labelText: "Role",
                  items: role,
                  value: selectedRole,
                  onChanged: (newValue) {
                    setState(() {
                      selectedRole = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select an option';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),

                CustomTextFormField(
                  labelText: 'Employee Code',
                  controller: empCodeController,
                ),
                SizedBox(height: 30),

                CustomTextFormField(
                  labelText: 'Primary Email',
                  controller: empCodeController,
                ),
                SizedBox(height: 20),
                Text(
                  'Communication Address',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
                CustomTextFormField(
                  labelText: 'Lane 1',
                  controller: lane1Controller,
                ),
                SizedBox(height: 30),
                CustomTextFormField(
                  labelText: 'Lane 2',
                  controller: lane2Controller,
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        labelText: 'State',
                        controller: stateController,
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: CustomTextFormField(
                        labelText: 'PIN Code',
                        controller: pinCodeController,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Password',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
                CustomTextFormField(
                  labelText: 'Enter New Password',
                  controller: passwordController,
                ),
                SizedBox(height: 30),
                CustomTextFormField(
                  labelText: 'Re Enter Password',
                  controller: reEnterPasswordController,
                ),
                SizedBox(height: 30),
                CustomButton(
                  text: 'Create',
                  onPressed: _registerEmployee,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fox_connect/widget/connectivity_checker.dart';
import 'package:fox_connect/widget/custom_button.dart';
import 'package:fox_connect/widget/custom_dropdown.dart';
import 'package:fox_connect/widget/custom_text_form_field.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AdminAddEmployee extends StatefulWidget {
  const AdminAddEmployee({super.key});

  @override
  State<AdminAddEmployee> createState() => _AdminAddEmployeeState();
}

class _AdminAddEmployeeState extends State<AdminAddEmployee> {
  File? _image;

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
  final TextEditingController reEnterPasswordController =
      TextEditingController();
  final TextEditingController BankNameController = TextEditingController();
  final TextEditingController AccountNoController = TextEditingController();
  final TextEditingController IFSCController = TextEditingController();
  final TextEditingController BankBranchController = TextEditingController();

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

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

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
    BankBranchController.dispose();
    AccountNoController.dispose();
    IFSCController.dispose();
    BankBranchController.dispose();
    super.dispose();
  }

  // Function to handle form submission
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> _registerEmployee() async {
    if (passwordController.text != reEnterPasswordController.text) {
      _showSnackBar("Passwords do not match");
      return;
    }

    // Construct email from empCode
    String email = '${empCodeController.text}@gmail.com';

    try {
      // Register with Firebase Authentication using constructed email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: passwordController.text,
      );

      // If image is selected, upload it to Firebase Storage
      String? imageUrl;
      if (_image != null) {
        final fileName = '${userCredential.user?.uid}_profile_pic';
        final ref = _storage.ref().child('profile_images/$fileName');
        await ref.putFile(_image!); // Upload the file to Firebase Storage
        imageUrl =
            await ref.getDownloadURL(); // Get the URL of the uploaded image
      }

      // Save employee data to Firestore
      await _firestore
          .collection('employees')
          .doc(userCredential.user?.uid)
          .set({
        'firstName': firstNameController.text.toLowerCase().trim(),
        'lastName': lastNameController.text.toLowerCase().trim(),
        'dob': dobController.text,
        'gender': selectedValue,
        'notification': positionController.text,
        'empCode': empCodeController.text.toLowerCase().trim(),
        'email': email.toLowerCase().trim(), // Use the constructed email
        'lane1': lane1Controller.text,
        'lane2': lane2Controller.text,
        'state': stateController.text,
        'pinCode': pinCodeController.text,
        'password': passwordController.text,
        'isActive': true, // Add the isActive field and set to true
        'imageUrl': imageUrl, // Add the image URL if available
      });

      // Show success snackbar
      _showSnackBar("Employee Registered Successfully!");
    } catch (e) {
      // Catch and display errors
      _showSnackBar("Error: ${e.toString()}");
    }
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
                  child: GestureDetector(
                    onTap: () {
                      print("Avatar tapped");
                      _pickImage();
                    },
                    child: CircleAvatar(
                      backgroundImage: _image == null
                          ? AssetImage('assets/logo.jpg')
                          : FileImage(_image!) as ImageProvider,
                      radius: 60,
                    ),
                  ),
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
                        onTap: () => _selectDate(context),
                        controller: dobController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'D.O.B',
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Color(0xffFF0000), width: 2),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () => _selectDate(context),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                                color: Color(0xffFF0000),
                                width: 2), // Focus color
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
                  'Bank Details',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
                CustomTextFormField(
                  labelText: 'Bank Name ',
                  controller: BankNameController,
                ),
                SizedBox(height: 30),
                CustomTextFormField(
                  labelText: 'Account Number',
                  controller: AccountNoController,
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        labelText: 'IFSC',
                        controller: IFSCController,
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: CustomTextFormField(
                        labelText: 'Branch',
                        controller: BankBranchController,
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

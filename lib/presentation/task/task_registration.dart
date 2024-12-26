import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:fox_connect/widget/connectivity_checker.dart';
import 'package:fox_connect/widget/custom_dropdown.dart';
import 'package:fox_connect/widget/custom_text_form_field.dart';

import '../../widget/custom_button.dart';

class TaskRegistration extends StatefulWidget {
  const TaskRegistration({super.key});

  @override
  State<TaskRegistration> createState() => _TaskRegistrationState();
}

class _TaskRegistrationState extends State<TaskRegistration>
    with SingleTickerProviderStateMixin {
  late TextEditingController _dateController;
  late TextEditingController _assignDateController;
  late TextEditingController _assignTimeController;
  late TextEditingController _deadlineDateController;
  late TextEditingController _deadlineTimeController;

  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  final List<String> dropdownItems = ['Morning', 'Afternoon'];
  final List<String> campPlanType = [
    'Main Event With Co-organized',
    'Individual Campevent'
  ];
  final List<String> lastCampDone = [
    'None',
    'below 1 month',
    '1 month above',
    '2 month above',
    '3 month above',
    '6 month above',
    '12 month above',
    '2 years above',
    '5 years above'
  ];

  String? selectedValue;
  String? campPlanselectedValue;
  String? lastselectedValue;
  final List<String> _options = ['Yes', 'No'];
  String? _selectedValue;
  String? _selectedValue2;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
    _assignDateController = TextEditingController();
    _assignTimeController = TextEditingController();
    _deadlineDateController = TextEditingController();
    _deadlineTimeController = TextEditingController();
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
  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        controller.text = DateFormat('dd-MM-yyyy').format(pickedDate);
      });
    }
  }

  void _submitTask() async {
    // Validate required fields
    if (_assignDateController.text.isEmpty ||
        _assignTimeController.text.isEmpty) {
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
          const SnackBar(content: Text('User is not logged in.')),
        );
        return;
      }

      // Prepare the task data
      Map<String, dynamic> taskData = {
        'taskAssignDate': _assignDateController.text,
        'taskAssignTime': _assignTimeController.text,
        'projectName': projectName.text,
        'todaysReport': todayReport.text,
        'taskDeadlineDate': _deadlineDateController.text,
        'taskDeadlineTime': _deadlineTimeController.text,
        'issue': _selectedValue,
        'issueDetails': _selectedValue == "Yes"
            ? tellUsAboutTheIssue.text.isNotEmpty
                ? tellUsAboutTheIssue.text
                : 'No details provided'
            : null, // Add only if the user reported an issue
        'createdAt': FieldValue.serverTimestamp(),
      };

      // Save the data to Firestore under the current user's UID
      await FirebaseFirestore.instance
          .collection('employees') // Top-level collection
          .doc(currentUser.uid) // Use the logged-in user's UID
          .collection('tasks') // Sub-collection for tasks
          .add(taskData);

      // Success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 24),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Task registered successfully!',
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
      _assignDateController.clear();
      _assignTimeController.clear();
      _deadlineDateController.clear();
      _deadlineTimeController.clear();

      setState(() {
        _selectedValue = null;
        _selectedValue2 = null;
      });
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
                  'Failed to register task: $e',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: Duration(seconds: 4),
          action: SnackBarAction(
            label: 'Retry',
            textColor: Colors.white,
            onPressed: () {
              _submitTask();
              // Add your retry logic here
              print('Retry task registration');
            },
          ),
        ),
      );

    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _assignDateController.dispose();
    _assignTimeController.dispose();
    _deadlineDateController.dispose();
    _deadlineTimeController.dispose();
    _controller.dispose();
    super.dispose();
  }

  final TextEditingController projectName = TextEditingController();
  final TextEditingController todayReport = TextEditingController();
  final TextEditingController tellUsAboutTheIssue = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ConnectivityChecker(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Task Registration',
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
                        "Task Details",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 22,
                          fontFamily: 'LeagueSpartan',
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Task Assign Date",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        fontFamily: 'LeagueSpartan',
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
                              controller: _assignDateController,
                              onTap: () =>
                                  _selectDate(context, _assignDateController),
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
                              controller: _assignTimeController,
                              onTap: () async {
                                TimeOfDay? pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );

                                if (pickedTime != null) {
                                  _assignTimeController.text =
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
                    _buildRadioOption('Deadline:', _options, _selectedValue2,
                        (value) {
                      setState(() {
                        _selectedValue2 = value;
                      });
                    }),
                    SizedBox(height: 20),
                    _selectedValue2 == "Yes"
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: AnimatedSize(
                                  duration: const Duration(milliseconds: 300),
                                  child: CustomTextFormField(
                                    controller: _deadlineDateController,
                                    onTap: () => _selectDate(
                                        context, _deadlineDateController),
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
                                    controller: _deadlineTimeController,
                                    onTap: () async {
                                      TimeOfDay? pickedTime =
                                          await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      );

                                      if (pickedTime != null) {
                                        _deadlineTimeController.text =
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
                          )
                        : SizedBox(),
                    SizedBox(
                      height: 20,
                    ),
                    ..._buildFormFields(),
                    SizedBox(height: 30),
                    // Submit Button
                    Center(
                        child: CustomButton(
                      text: 'Submit',
                      onPressed: () {
                        _submitTask();
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
      _buildCustomTextFormField(
          'Project Name', FontAwesomeIcons.projectDiagram, projectName,context),
      SizedBox(height: 20),
      _buildTaskRegTextFormField(
          "Today's Report", FontAwesomeIcons.clipboard, todayReport,context),
      SizedBox(height: 20),
      _buildRadioOption('Are You facing any issue:', _options, _selectedValue,
          (value) {
        setState(() {
          _selectedValue = value;
        });
      }),
      SizedBox(height: 20),
      _selectedValue == "Yes"
          ? _buildTaskRegTextFormField('Tell us about the issue',
              Icons.support_agent, tellUsAboutTheIssue,context)
          : SizedBox()
    ];
    return fields;
  }

  Widget _buildCustomTextFormField(
      String label, IconData icon, TextEditingController controller, BuildContext context) {
    return CustomTextFormField(
      controller: controller,
      labelText: label,
      icon: icon,
      onSaved: (value) {
        if (value == null || value.isEmpty) {
          _showAwesomeSnackbar(context, 'Please fill out this field');
        }
      },
    );
  }

  Widget _buildTaskRegTextFormField(
      String label, IconData icon, TextEditingController controller, BuildContext context) {
    return TaskRegTextFormField(
      controller: controller,
      labelText: label,
      icon: icon,
      onSaved: (value) {
        if (value == null || value.isEmpty) {
          _showAwesomeSnackbar(context, 'Please fill out this field');
        }
      },
    );
  }


  Widget _buildRadioOption(String label, List<String> options,
      String? selectedValue, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
              fontFamily: 'LeagueSpartan',
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: options.map((option) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio<String>(
                  value: option,
                  groupValue: selectedValue,
                  onChanged: onChanged,
                ),
                Text(
                  option,
                  style: TextStyle(
                    fontFamily: 'LeagueSpartan',
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
  void _showAwesomeSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

}

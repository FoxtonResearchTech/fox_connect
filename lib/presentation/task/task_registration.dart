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

class _TaskRegistrationState extends State<TaskRegistration> with SingleTickerProviderStateMixin {
  late TextEditingController _dateController;
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
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: const Offset(0.0, 0.1), end: Offset.zero)
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

  @override
  void dispose() {
    _dateController.dispose();
    _controller.dispose();
    super.dispose();
  }

  TextEditingController timeController = TextEditingController();
  final TextEditingController campNameController = TextEditingController();
  final TextEditingController organizationController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumber1Controller = TextEditingController();
  final TextEditingController phoneNumber2Controller = TextEditingController();
  final TextEditingController name2Controller = TextEditingController();
  final TextEditingController phoneNumber1_2Controller = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController position2Controller = TextEditingController();
  final TextEditingController phoneNumber2_2Controller = TextEditingController();
  final TextEditingController totalSquareFeetController = TextEditingController();
  final TextEditingController noOfPatientExpectedController = TextEditingController();

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
                                  initialTime: TimeOfDay.now(), // Set the initial time to the current time
                                );

                                if (pickedTime != null) {
                                  // Format and set the selected time in the TextField
                                  timeController.text = pickedTime.format(context);
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
                    _selectedValue2 == "Yes" ?      Row(
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
                                  initialTime: TimeOfDay.now(), // Set the initial time to the current time
                                );

                                if (pickedTime != null) {
                                  // Format and set the selected time in the TextField
                                  timeController.text = pickedTime.format(context);
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
                    SizedBox(height: 20,),
                    ..._buildFormFields(),
                    SizedBox(height: 30),
                    // Submit Button
                    Center(
                        child: CustomButton(text: 'Submit', onPressed: () {  },)
                    ),
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
          'Project Name', FontAwesomeIcons.projectDiagram, phoneNumber2Controller),
      SizedBox(height: 20),
      _buildCustomTextFormField(
          "Today's Report", FontAwesomeIcons.clipboard, phoneNumber2Controller),




      SizedBox(height: 20),
      _buildRadioOption('Are You facing any issue:', _options, _selectedValue2,
              (value) {
            setState(() {
              _selectedValue2 = value;
            });
          }),
      SizedBox(height: 20),
      _selectedValue2 == "Yes" ?   _buildCustomTextFormField(
    'Tell us about the issue', Icons.support_agent, phoneNumber2Controller)
  : SizedBox()
    ];
    return fields;
  }

  Widget _buildCustomTextFormField(String label, IconData icon, TextEditingController controller) {
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
}

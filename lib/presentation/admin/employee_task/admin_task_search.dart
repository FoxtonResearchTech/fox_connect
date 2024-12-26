import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fox_connect/presentation/admin/employee_task/task_view.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class AdminTaskSearch extends StatefulWidget {
  const AdminTaskSearch({Key? key}) : super(key: key);

  @override
  State<AdminTaskSearch> createState() => _AdminTaskSearchState();
}

class _AdminTaskSearchState extends State<AdminTaskSearch> {
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  late TextEditingController _nameSearchController; // For name search

  List<Map<String, dynamic>> _allTasks = [];
  List<Map<String, dynamic>> _filteredTasks = [];
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _startDateController = TextEditingController();
    _endDateController = TextEditingController();
    _nameSearchController =
        TextEditingController(); // Initialize name search controller
    _fetchTasks(); // Load tasks from Firestore
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    _nameSearchController.dispose(); // Dispose name search controller
    super.dispose();
  }

  /// Fetch tasks from Firestore
  Future<void> _fetchTasks() async {
    try {
      final QuerySnapshot employeeSnapshot =
          await FirebaseFirestore.instance.collection('employees').get();

      List<Map<String, dynamic>> tasks = [];
      for (var employeeDoc in employeeSnapshot.docs) {
        final String firstName = employeeDoc['firstName'];
        final String lastName = employeeDoc['lastName'];
        final String role = employeeDoc['roles'];

        final QuerySnapshot taskSnapshot =
            await employeeDoc.reference.collection('tasks').get();

        for (var taskDoc in taskSnapshot.docs) {
          // Include firstName and role with each task
          Map<String, dynamic> taskData =
              taskDoc.data() as Map<String, dynamic>;
          taskData['name'] = firstName + " " + lastName;
          taskData['firstName'] = lastName;
          taskData['lastName'] = lastName;
          taskData['roles'] = role;

          tasks.add(taskData);
        }
      }

      setState(() {
        _allTasks = tasks;
        _filteredTasks = _allTasks;
      });
    } catch (e) {
      debugPrint('Error fetching tasks: $e');
    }
  }

  void _filterTasks() {
    setState(() {
      _filteredTasks = _allTasks.where((task) {
        bool matchesDate = true;
        if (_startDate != null && _endDate != null) {
          DateTime taskDate =
              DateFormat('dd-MM-yyyy').parse(task['taskAssignDate']);
          matchesDate =
              taskDate.isAfter(_startDate!.subtract(const Duration(days: 1))) &&
                  taskDate.isBefore(_endDate!.add(const Duration(days: 1)));
        }

        bool matchesName = true;
        if (_nameSearchController.text.isNotEmpty) {
          matchesName = task['name']
              .toLowerCase()
              .contains(_nameSearchController.text.toLowerCase());
        }

        return matchesDate && matchesName;
      }).toList();
    });
  }

  Future<void> _selectDateRange(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(picked);
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          _startDateController.text = formattedDate;
        } else {
          _endDate = picked;
          _endDateController.text = formattedDate;
        }
      });
      _filterTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tasks Reports",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'LeagueSpartan',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF00008B),
                const Color(0xFF00008B).withOpacity(1),
                const Color(0xFF00008B).withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Name Search Field
                TextField(
                  controller: _nameSearchController,
                  onChanged: (value) => _filterTasks(),
                  decoration: InputDecoration(
                    labelText: "Search by Name",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Date Range Fields
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Start Date Field
                    Flexible(
                      child: GestureDetector(
                        onTap: () => _selectDateRange(context, true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _startDateController.text.isNotEmpty
                                    ? _startDateController.text
                                    : "Start Date",
                                style: TextStyle(
                                  color: _startDateController.text.isNotEmpty
                                      ? Colors.black
                                      : Colors.grey[600],
                                  fontSize: 16,
                                  fontFamily: 'LeagueSpartan',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Icon(Icons.calendar_today,
                                  color: Colors.orangeAccent),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // End Date Field
                    Flexible(
                      child: GestureDetector(
                        onTap: () => _selectDateRange(context, false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _endDateController.text.isNotEmpty
                                    ? _endDateController.text
                                    : "End Date",
                                style: TextStyle(
                                  color: _endDateController.text.isNotEmpty
                                      ? Colors.black
                                      : Colors.grey[600],
                                  fontSize: 16,
                                  fontFamily: 'LeagueSpartan',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Icon(Icons.calendar_today,
                                  color: Colors.orangeAccent),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _buildCampList(screenWidth, screenHeight),
          ),
        ],
      ),
    );
  }

  Widget _buildCampList(double screenWidth, double screenHeight) {
    if (_filteredTasks.isEmpty) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          padding: EdgeInsets.only(top: screenHeight / 6),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/no_records.json',
                  width: screenWidth * 0.6,
                  height: screenHeight * 0.4,
                ),
                const SizedBox(height: 10),
                const Text(
                  "No matching record found",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'LeagueSpartan',
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _filteredTasks.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {},
          child: _buildCampCard(index, screenWidth, screenHeight),
        );
      },
    );
  }

  Widget _buildCampCard(int index, double screenWidth, double screenHeight) {
    return Column(
      children: [
        Container(
          height: screenHeight / 4.8,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage('assets/logo.jpg'),
                          backgroundColor: Colors.blue,
                          radius: 20,
                          child: Text(
                            _filteredTasks[index]['name']
                                .substring(0, 1)
                                .toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _filteredTasks[index]['name'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'LeagueSpartan',
                              ),
                            ),
                            Text(
                              _filteredTasks[index]['roles'],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontFamily: 'LeagueSpartan',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TaskViewPage(employee: _filteredTasks[index]),
                          ),
                        );
                      },
                      icon: const Icon(
                        CupertinoIcons.arrow_right,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                const Divider(
                  height: 20,
                  color: Colors.black12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Task Assigned Date",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontFamily: 'LeagueSpartan',
                      ),
                    ),
                    Text(
                      _filteredTasks[index]['taskAssignDate'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'LeagueSpartan',
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Task DeadLine Date",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontFamily: 'LeagueSpartan',
                      ),
                    ),
                    Text(
                      _filteredTasks[index]['taskDeadlineDate'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'LeagueSpartan',
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Project name",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontFamily: 'LeagueSpartan',
                      ),
                    ),
                    Text(
                      _filteredTasks[index]['projectName'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'LeagueSpartan',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Assigned To",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontFamily: 'LeagueSpartan',
                      ),
                    ),
                    Text(
                      _filteredTasks[index]['name'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'LeagueSpartan',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}

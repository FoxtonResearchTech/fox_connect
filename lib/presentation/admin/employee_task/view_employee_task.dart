import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:fox_connect/presentation/admin/employee_task/task_view.dart';

class ViewEmployeeTask extends StatefulWidget {
  const ViewEmployeeTask({super.key});

  @override
  _ViewEmployeeTaskState createState() => _ViewEmployeeTaskState();
}

class _ViewEmployeeTaskState extends State<ViewEmployeeTask> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController and Animation
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    // Define the animation (for example, a fade-in animation)
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    // Dispose of the controller when no longer needed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Get current date formatted as 'yyyy-MM-dd' (without time)
    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'View Tasks',
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
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('employees').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No tasks found.'));
            }

            final employees = snapshot.data!.docs;

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: screenWidth > 800 ? 4 : 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: employees.length,
              itemBuilder: (context, index) {
                final employee = employees[index].data() as Map<String, dynamic>;
                final employeeId = employees[index].id; // Employee document ID

                return FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('employees')
                      .doc(employeeId)
                      .collection('tasks') // Fetch tasks subcollection
                      .get(),
                  builder: (context, taskSnapshot) {
                    if (taskSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (taskSnapshot.hasError) {
                      return Center(child: Text('Error: ${taskSnapshot.error}'));
                    }

                    final tasks = taskSnapshot.data?.docs ?? [];

                    // Default values if no tasks are present
                    String date = 'N/A';
                    String time = 'N/A';
                    String projectName = 'N/A';
                    String taskAssignDate = 'N/A';
                    String taskAssignTime = 'N/A';
                    String taskDeadDate = 'N/A';
                    String taskDeadTime = 'N/A';
                    String todayReport = 'N/A';
                    String Issues = 'N/A';
                    String createdAt = 'N/A'; // Default value

                    // Find tasks with createdAt matching the current date
                    List<Widget> taskWidgets = [];

                    for (var task in tasks) {
                      final taskData = task.data() as Map<String, dynamic>;
                      date = taskData['taskAssignDate'] ?? 'N/A';
                      time = taskData['taskAssignTime'] ?? 'N/A';
                      projectName = taskData['projectName'] ?? 'N/A';
                      taskAssignDate = taskData['taskAssignDate'] ?? 'N/A';
                      taskAssignTime = taskData['taskAssignTime'] ?? 'N/A';
                      taskDeadTime = taskData['taskDeadlineTime'] ?? 'N/A';
                      taskDeadDate = taskData['taskDeadlineDate'] ?? 'N/A';
                      todayReport = taskData['todaysReport'] ?? 'N/A';
                      Issues = taskData['issueDetails'] ?? 'N/A';
                      createdAt = taskData['createdAt'] != null
                          ? (taskData['createdAt'] as Timestamp).toDate()
                          .toString().substring(0, 10) // Only date portion
                          : 'N/A';

                      // Compare task createdAt with currentDate
                      if (createdAt == currentDate) {
                        taskWidgets.add(GestureDetector(
                          onTap: () {
                            final employeeData = {
                              ...employee,
                              'date': date,
                              'time': time,
                              'createdAt': createdAt,
                              'projectName':projectName,
                              'taskAssignDate':taskAssignDate,
                              'taskAssignTime':taskAssignTime,
                              'taskDeadlineDate':taskDeadDate,
                              'taskDeadlineTime':taskDeadTime,
                              'todaysReport':todayReport,
                              "issueDetails":Issues,
                            }.map((key, value) => MapEntry(key, value.toString()));

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TaskViewPage(employee: employeeData),
                              ),
                            );
                          },
                          child: FadeTransition(
                            opacity: _animation, // Apply the fade animation
                            child: Card(
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.teal,
                                      child: Text(
                                        employee['firstName'][0], // First letter of the name
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      employee['firstName'],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Role: ${employee['roles']}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.date_range,
                                              size: screenWidth * 0.04,
                                              color: Color(0xffFF0000),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              date,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'LeagueSpartan',
                                                color: Colors.black54,
                                                fontSize: screenWidth * 0.04,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.watch_later,
                                              size: screenWidth * 0.04,
                                              color: Color(0xffFF0000),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              time,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'LeagueSpartan',
                                                color: Colors.black54,
                                                fontSize: screenWidth * 0.04,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ));
                      }
                    }

                    // If no tasks match the current date, show a message
                    if (taskWidgets.isEmpty) {
                      return const Center(child: Text('No tasks found for today.'));
                    }

                    // Return the list of tasks matching the current date
                    return Column(children: taskWidgets);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

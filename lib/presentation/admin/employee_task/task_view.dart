import 'package:flutter/material.dart';
import 'package:fox_connect/presentation/admin/employee_task/download_report.dart';

class TaskViewPage extends StatefulWidget {
  final Map<String, String> employee;

  TaskViewPage({required this.employee});

  @override
  _TaskViewPageState createState() => _TaskViewPageState();
}

class _TaskViewPageState extends State<TaskViewPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.5), end: Offset(0, 0)).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _fadeInAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: const Text(
          'Tasks Details',
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF00008B),
                        Color(0xFF00008B).withOpacity(1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(40),
                    ),
                  ),
                ),
                Positioned(
                  top: 120,
                  left: MediaQuery.of(context).size.width / 2 - 60,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 55,
                        backgroundColor: Color(0xFF00008B),
                        child: Text(
                          widget.employee['name']![0], // First letter of the name
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 80),
            FadeTransition(
              opacity: _fadeInAnimation,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        widget.employee['name']!,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        widget.employee['role']!,
                        style: TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Divider(
                      thickness: 1,
                      color: Colors.grey[300],
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Project Name",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Hospital Management System", // Example project name
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Task Assign Date",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                fontFamily: 'LeagueSpartan',
                              ),
                            ),
                            Text(
                              "Task Deadline Date",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                fontFamily: 'LeagueSpartan',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.date_range,
                                  size: screenWidth * 0.07,
                                  color: Color(0xffFF0000),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "12-1-2024",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'LeagueSpartan',
                                    color: Colors.black54,
                                    fontSize: screenWidth * 0.05,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.date_range,
                                  size: screenWidth * 0.07,
                                  color: Color(0xffFF0000),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "12-1-2024",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'LeagueSpartan',
                                    color: Colors.black54,
                                    fontSize: screenWidth * 0.05,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.watch_later,
                                  size: screenWidth * 0.07,
                                  color: Color(0xffFF0000),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '10:15 AM',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'LeagueSpartan',
                                    color: Colors.black54,
                                    fontSize: screenWidth * 0.05,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.watch_later,
                                  size: screenWidth * 0.07,
                                  color: Color(0xffFF0000),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '10:15 AM',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'LeagueSpartan',
                                    color: Colors.black54,
                                    fontSize: screenWidth * 0.05,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Today's Report",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "Enter today's progress...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Are you facing any issue?",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Describe any issue...",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Center(
                      child: SizedBox(
                        width: 200,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Handle download action
                            Navigator.push(context,MaterialPageRoute(builder: (context)=>DownloadTaskreport(employee:widget. employee)));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: Icon(Icons.download, size: 24),
                          label: Text(
                            'Download',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

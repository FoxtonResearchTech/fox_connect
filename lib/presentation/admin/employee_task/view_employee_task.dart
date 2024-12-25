import 'package:flutter/material.dart';
import 'package:fox_connect/presentation/admin/employee_task/task_view.dart';

class ViewEmployeeTask extends StatefulWidget {
  ViewEmployeeTask({super.key});

  @override
  _ViewEmployeeTaskState createState() => _ViewEmployeeTaskState();
}

class _ViewEmployeeTaskState extends State<ViewEmployeeTask>
    with TickerProviderStateMixin {
  final List<Map<String, String>> employees = [
    {
      'name': 'John Doe',
      'role': 'Developer',
      'date': '2024-12-25',
      'time': '10:00 AM'
    },
    {
      'name': 'Jane Smith',
      'role': 'Designer',
      'date': '2024-12-26',
      'time': '11:00 AM'
    },
    {
      'name': 'Mike Brown',
      'role': 'Manager',
      'date': '2024-12-27',
      'time': '09:30 AM'
    },
    {
      'name': 'Emily White',
      'role': 'Tester',
      'date': '2024-12-28',
      'time': '02:00 PM'
    },
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

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
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width > 800 ? 4 : 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8, // Makes the cards taller
          ),
          itemCount: employees.length,
          itemBuilder: (context, index) {
            final employee = employees[index];

            // Create an animation controller for scale effect with a slower duration
            final _scaleController = AnimationController(
              vsync: this,
              duration: Duration(milliseconds: 400), // Slow down the scale animation
            );
            final _scaleAnimation =
            CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut);

            // Add a listener to start the animation
            _scaleController.forward();

            return GestureDetector(
              onTap: () {
                Navigator.push(context,MaterialPageRoute(builder: (context)=>TaskViewPage(employee: employee)));
              },
              child: ScaleTransition(
                scale: _scaleAnimation,
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
                            employee['name']![0], // First letter of the name
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          employee['name']!,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Role: ${employee['role']}',
                          style: TextStyle(
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
                                  size: screenWidth * 0.05,
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
                                  Icons.watch_later,
                                  size: screenWidth * 0.05,
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
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

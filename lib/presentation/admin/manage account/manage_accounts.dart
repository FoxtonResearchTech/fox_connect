import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageEmployeeAccountPage extends StatefulWidget {
  @override
  _ManageEmployeeAccountPageState createState() =>
      _ManageEmployeeAccountPageState();
}

class _ManageEmployeeAccountPageState
    extends State<ManageEmployeeAccountPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference _employeesRef;

  @override
  void initState() {
    super.initState();
    _employeesRef = _firestore.collection('employees');
  }

  // Function to toggle account status
  Future<void> toggleAccountStatus(String employeeId, bool currentStatus) async {
    try {
      await _employeesRef.doc(employeeId).update({
        'isActive': !currentStatus, // Toggle the status
      });
    } catch (e) {
      print('Error updating account status: $e');
    }
  }

  // Fetch the list of employees
  Stream<QuerySnapshot> getEmployees() {
    return _employeesRef.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Employee Accounts'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getEmployees(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No employees found.'));
          }

          final employees = snapshot.data!.docs;

          return ListView.builder(
            itemCount: employees.length,
            itemBuilder: (context, index) {
              final employee = employees[index];
              final String employeeId = employee.id;
              final String name = employee['firstName'];
          //    final String role = employee['role'] ?? 'N/A';
            //  final String yearOfJoining = employee['yearOfJoining'] ?? 'N/A';
              final bool isActive = employee['isActive'];

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left side - Employee details
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Role: ',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            'Year of Joining: ',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            isActive ? 'Active' : 'Inactive',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isActive ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                      // Right side - Toggle button
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Switch(
                            value: isActive,
                            onChanged: (bool newValue) {
                              toggleAccountStatus(employeeId, isActive);
                            },
                            activeColor: Colors.green,
                            inactiveThumbColor: Colors.red,
                          ),
                          Text(
                            isActive ? 'Deactivate' : 'Activate',
                            style: TextStyle(
                              fontSize: 16,
                              color: isActive ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

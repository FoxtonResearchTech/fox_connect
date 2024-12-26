import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fox_connect/widget/connectivity_checker.dart';

class LeaveApprovel extends StatefulWidget {
  @override
  State<LeaveApprovel> createState() => _LeaveApprovelState();
}

class _LeaveApprovelState extends State<LeaveApprovel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  String? _paymentOption = 'Pay Off'; // Default value for the payment option
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Stream to fetch leave data from Firestore
  Stream<List<Map<String, dynamic>>> _fetchLeaveDataStream() {
    return FirebaseFirestore.instance
        .collection('employees')
        .snapshots()
        .asyncMap((employeesSnapshot) async {
      List<Map<String, dynamic>> leaveList = [];
      for (var doc in employeesSnapshot.docs) {
        String employeeName = doc['firstName'] ?? 'Unknown';
        String employeeRole = doc['roles'] ?? 'Unknown';
        QuerySnapshot leaveSnapshot =
            await doc.reference.collection('leave').get();
        for (var leaveDoc in leaveSnapshot.docs) {
          Map<String, dynamic> leaveData =
              leaveDoc.data() as Map<String, dynamic>;
          leaveData['firstName'] =
              employeeName; // Add employee name to leave data
          leaveData['roles'] = employeeRole;
          leaveList.add(leaveData);
        }
      }
      return leaveList;
    });
  }

  // Show payment options dialog
  Future<String?> _showPaymentOptionsDialog() async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String? tempOption = _paymentOption; // Temporary selection
        return AlertDialog(
          title: const Text("Select Payment Option"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setDialogState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<String>(
                    value: 'Pay Off',
                    groupValue: tempOption,
                    title: const Text('Pay Off'),
                    onChanged: (value) {
                      setDialogState(() {
                        tempOption = value; // Update the local selection
                      });
                    },
                  ),
                  RadioListTile<String>(
                    value: 'Pay Half',
                    groupValue: tempOption,
                    title: const Text('Pay Half'),
                    onChanged: (value) {
                      setDialogState(() {
                        tempOption = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    value: 'Pay',
                    groupValue: tempOption,
                    title: const Text('Pay'),
                    onChanged: (value) {
                      setDialogState(() {
                        tempOption = value;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context, tempOption), // Return the selection
              child: const Text("OK"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, null), // Cancel
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return ConnectivityChecker(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Leave Approval',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontFamily: 'LeagueSpartan',
              fontWeight: FontWeight.bold,
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
        body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: _fetchLeaveDataStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No leave data available.'));
            } else {
              List<Map<String, dynamic>> leaveData = snapshot.data!;

              return ListView.builder(
                itemCount: leaveData.length,
                itemBuilder: (BuildContext context, int index) {
                  var leaveItem = leaveData[index];
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      height: screenHeight / 1.8,
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
                                    Icon(
                                      Icons.date_range,
                                      size: screenWidth * 0.07,
                                      color: Color(0xffFF0000),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      leaveItem['date'] ?? "N/A",
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
                                      leaveItem['time'] ?? "N/A",
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
                            const SizedBox(height: 5),
                            ..._buildInfoText(
                              screenWidth,
                              leaveItem['firstName'] ?? "Pending",
                            ),
                            ..._buildInfoText(
                              screenWidth,
                              leaveItem['roles'] ?? "Pending",
                            ),
                            ..._buildInfoText(
                              screenWidth,
                              leaveItem['leaveType'] ?? "Unknown",
                            ),
                            ..._buildInfoText(
                              screenWidth,
                              leaveItem['lastLeaveTaken'] ?? "Pending",
                            ),
                            ..._buildInfoText(
                              screenWidth,
                              leaveItem['workFromHome'] ?? "Pending",
                            ),
                            ..._buildInfoText(
                              screenWidth,
                              leaveItem['workFromHome'] ?? "Pending",
                            ),
                            ..._buildInfoText(
                              screenWidth,
                              leaveItem['reason'] ?? "N/A",
                            ),
                            ..._buildInfoText(
                              screenWidth,
                              leaveItem['otherReason'] ?? "N/A",
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: isLoading
                                      ? null
                                      : () async {
                                          String? selectedOption =
                                              await _showPaymentOptionsDialog();

                                          if (selectedOption == null) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      'Please select a payment option.')),
                                            );
                                            return;
                                          }

                                          setState(() {
                                            _paymentOption = selectedOption;
                                            isLoading = true;
                                          });

                                          try {
                                            String employeeId =
                                                leaveItem['employeeId'];
                                            String leaveId =
                                                leaveItem['leaveId'];

                                            await FirebaseFirestore.instance
                                                .collection('employees')
                                                .doc(employeeId)
                                                .collection('leave')
                                                .doc(leaveId)
                                                .update({
                                              'leaveStatus':
                                                  'Accepted - $_paymentOption',
                                            });

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Leave accepted with status: $_paymentOption.'),
                                              ),
                                            );
                                          } catch (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      'Failed to accept leave: $e')),
                                            );
                                          } finally {
                                            setState(() {
                                              isLoading = false;
                                            });
                                          }
                                        },
                                  icon: const Icon(Icons.check,
                                      color: Colors.white, size: 28),
                                  label: const Text(
                                    'Accept',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 16),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: isLoading
                                      ? null
                                      : () async {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          try {
                                            // Assuming leaveItem contains employeeDocId and leaveDocId
                                            String employeeId =
                                                leaveItem['employeeId'];
                                            String leaveId =
                                                leaveItem['leaveId'];

                                            await FirebaseFirestore.instance
                                                .collection('employees')
                                                .doc(employeeId)
                                                .collection('leave')
                                                .doc(leaveId)
                                                .update({
                                              'leaveStatus': 'Rejected'
                                            });

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      'Leave rejected successfully.')),
                                            );
                                          } catch (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      'Failed to reject leave: $e')),
                                            );
                                          } finally {
                                            setState(() {
                                              isLoading = false;
                                            });
                                          }
                                        },
                                  icon: const Icon(Icons.close,
                                      color: Colors.white, size: 28),
                                  label: const Text('Reject',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 16),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  List<Widget> _buildInfoText(double screenWidth, String data) {
    return [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              data,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontFamily: 'LeagueSpartan',
                color: Colors.black54,
                fontSize: screenWidth * 0.05,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
    ];
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fox_connect/widget/connectivity_checker.dart';
import 'package:timeline_tile/timeline_tile.dart';

class LeaveStatus extends StatefulWidget {
  @override
  State<LeaveStatus> createState() => _LeaveStatusState();
}

class _LeaveStatusState extends State<LeaveStatus>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

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

  @override
  Widget build(BuildContext context) {
    // Mock userId, replace with your method to fetch current user's ID
    final FirebaseAuth _auth = FirebaseAuth.instance;

// Get the current user's UID
    String? userId = _auth.currentUser?.uid;

// Optional: Get other user details

    return ConnectivityChecker(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Leave Status',
            style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontFamily: 'LeagueSpartan',
                fontWeight: FontWeight.bold),
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
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('employees')
              .doc(userId)
              .collection('leave')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No leave records found.'));
            }

            final leaveDocs = snapshot.data!.docs;

            return ListView.builder(
              itemCount: leaveDocs.length,
              itemBuilder: (BuildContext context, int index) {
                final leaveData =
                    leaveDocs[index].data() as Map<String, dynamic>;

                Animation<double> animation = CurvedAnimation(
                  parent: _controller,
                  curve: Interval(
                    (1 / leaveDocs.length) * index,
                    1.0,
                    curve: Curves.easeOut,
                  ),
                );
                _controller.forward();

                return GestureDetector(
                  onTap: () async {},
                  child: FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.2),
                        end: Offset.zero,
                      ).animate(animation),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              height: MediaQuery.of(context).size.height / 2.5,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.date_range,
                                              size: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.07,
                                              color: Color(0xffFF0000),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              leaveData['date'] ?? 'N/A',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'LeagueSpartan',
                                                color: Colors.black54,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.05,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.watch_later,
                                              size: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.07,
                                              color: Color(0xffFF0000),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              leaveData['time'] ?? 'N/A',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'LeagueSpartan',
                                                color: Colors.black54,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.05,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    ..._buildInfoText(
                                      MediaQuery.of(context).size.width,
                                      leaveData['leaveType'] ?? 'N/A',
                                    ),
                                    ..._buildInfoText(
                                      MediaQuery.of(context).size.width,
                                      leaveData['lastLeaveTaken'] ?? 'N/A',
                                    ),
                                    ..._buildInfoText(
                                      MediaQuery.of(context).size.width,
                                      leaveData['workFromHome'] ?? 'N/A',
                                    ),
                                    ..._buildInfoText(
                                      MediaQuery.of(context).size.width,
                                      leaveData['reason'] ?? 'N/A',
                                    ),
                                    ..._buildInfoText(
                                      MediaQuery.of(context).size.width,
                                      leaveData['otherReason'] ?? 'N/A',
                                    ),
                                    leaveData['leaveStatus'] == 'Accepted - Pay'
                                        ? Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.1,
                                            width: double.infinity,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: [
                                                  _buildTimelineTile(
                                                    isFirst: true,
                                                    color: Colors.purple,
                                                    icon: Icons.check,
                                                    text: 'Processing',
                                                    screenWidth:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    lineBeforeColor:
                                                        Colors.green,
                                                    lineAfterColor:
                                                        Colors.green,
                                                  ),
                                                  _buildTimelineTile(
                                                    color: Colors.blue[600]!,
                                                    icon: Icons.check,
                                                    text: 'Approved',
                                                    screenWidth:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    lineBeforeColor:
                                                        Colors.green,
                                                    lineAfterColor:
                                                        Colors.green,
                                                  ),
                                                  _buildTimelineTile(
                                                    isLast: true,
                                                    color: Colors.green,
                                                    icon: Icons.check,
                                                    text: 'Pay',
                                                    screenWidth:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    lineBeforeColor:
                                                        Colors.green,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : leaveData['leaveStatus'] == 'Waiting'
                                            ? Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.1,
                                                width: double.infinity,
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Row(
                                                    children: [
                                                      _buildTimelineTile(
                                                        isFirst: true,
                                                        color: Colors.purple,
                                                        icon: Icons.check,
                                                        text: 'Processing',
                                                        screenWidth:
                                                            MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width,
                                                        lineBeforeColor:
                                                            Colors.grey,
                                                        lineAfterColor:
                                                            Colors.grey,
                                                      ),
                                                      _buildTimelineTile(
                                                        color:
                                                            Colors.grey,
                                                        icon: Icons.check,
                                                        text: 'Approved',
                                                        screenWidth:
                                                            MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width,
                                                        lineBeforeColor:
                                                            Colors.grey,
                                                        lineAfterColor:
                                                            Colors.grey,
                                                      ),
                                                      _buildTimelineTile(
                                                        isLast: true,
                                                        color: Colors.grey,
                                                        icon: Icons.check,
                                                        text: 'Approved',
                                                        screenWidth:
                                                            MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width,
                                                        lineBeforeColor:
                                                            Colors.grey,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : leaveData["leaveStatus"] == 'Rejected'
                                                ? Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.1,
                                                    width: double.infinity,
                                                    child:
                                                        SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Row(
                                                        children: [
                                                          _buildTimelineTile(
                                                            isFirst: true,
                                                            color:
                                                                Colors.purple,
                                                            icon: Icons.check,
                                                            text: 'Processing',
                                                            screenWidth:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            lineBeforeColor:
                                                                Colors.green,
                                                            lineAfterColor:
                                                                Colors.green,
                                                          ),
                                                          _buildTimelineTile(

                                                            color:
                                                            Colors.blueAccent,
                                                            icon: Icons.check,
                                                            text: 'Viewed',
                                                            screenWidth:
                                                            MediaQuery.of(
                                                                context)
                                                                .size
                                                                .width,
                                                            lineBeforeColor:
                                                            Colors.green,
                                                            lineAfterColor:
                                                            Colors.green,
                                                          ),

                                                          _buildTimelineTile(
                                                            isLast: true,
                                                            color: Colors
                                                                .redAccent,
                                                            icon: Icons.cancel,

                                                            text: 'Rejected',
                                                            screenWidth:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            lineBeforeColor:
                                                                Colors.green,

                                                          ),

                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                : leaveData["leaveStatus"] == 'Accepted - Pay Off'
                                                    ? Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.1,
                                                        width: double.infinity,
                                                        child:
                                                            SingleChildScrollView(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          child: Row(
                                                            children: [
                                                              _buildTimelineTile(
                                                                isFirst: true,
                                                                color: Colors
                                                                    .purple,
                                                                icon:
                                                                    Icons.check,
                                                                text:
                                                                    'Processing',
                                                                screenWidth:
                                                                    MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                lineBeforeColor:
                                                                    Colors
                                                                        .green,
                                                                lineAfterColor:
                                                                    Colors
                                                                        .green,
                                                              ),
                                                              _buildTimelineTile(
                                                                color: Colors
                                                                    .blue[600]!,
                                                                icon:
                                                                    Icons.check,
                                                                text:
                                                                    'Approved',
                                                                screenWidth:
                                                                    MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                lineBeforeColor:
                                                                    Colors
                                                                        .green,
                                                                lineAfterColor:
                                                                    Colors
                                                                        .green,
                                                              ),
                                                              _buildTimelineTile(
                                                                isLast: true,
                                                                color: Colors
                                                                    .deepOrange,
                                                                icon:
                                                                    Icons.check,
                                                                text: 'Pay Off',
                                                                screenWidth:
                                                                    MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                lineBeforeColor:
                                                                    Colors
                                                                        .green,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    : leaveData['leaveStatus'] == 'Accepted - Pay Half'
                                                        ? Container(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.1,
                                                            width:
                                                                double.infinity,
                                                            child:
                                                                SingleChildScrollView(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              child: Row(
                                                                children: [
                                                                  _buildTimelineTile(
                                                                    isFirst:
                                                                        true,
                                                                    color: Colors
                                                                        .purple,
                                                                    icon: Icons
                                                                        .check,
                                                                    text:
                                                                        'Processing',
                                                                    screenWidth:
                                                                        MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                    lineBeforeColor:
                                                                        Colors
                                                                            .green,
                                                                    lineAfterColor:
                                                                        Colors
                                                                            .green,
                                                                  ),
                                                                  _buildTimelineTile(
                                                                    color: Colors
                                                                            .blue[
                                                                        600]!,
                                                                    icon: Icons
                                                                        .check,
                                                                    text:
                                                                        'Approved',
                                                                    screenWidth:
                                                                        MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                    lineBeforeColor:
                                                                        Colors
                                                                            .green,
                                                                    lineAfterColor:
                                                                        Colors
                                                                            .green,
                                                                  ),
                                                                  _buildTimelineTile(
                                                                    isLast:
                                                                        true,
                                                                    color: Colors
                                                                        .yellow,
                                                                    icon: Icons
                                                                        .check,
                                                                    text: 'Pay Half',
                                                                    screenWidth:
                                                                        MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                    lineBeforeColor:
                                                                        Colors
                                                                            .green,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        : Center(
                                                            child: Text(
                                                              "No Leave Data Found ",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 22),
                                                            ),
                                                          ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  // Helper method to build timeline tile with responsive styles
  Widget _buildTimelineTile({
    required Color color,
    required IconData icon,
    required String text,
    required double screenWidth,
    Color? lineBeforeColor,
    Color? lineAfterColor,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return TimelineTile(
      axis: TimelineAxis.horizontal,
      alignment: TimelineAlign.center,
      isFirst: isFirst,
      isLast: isLast,
      indicatorStyle: IndicatorStyle(
        width: screenWidth * 0.09,
        color: color,
        iconStyle: IconStyle(
          iconData: icon,
          color: Colors.white,
          fontSize: screenWidth * 0.05,
        ),
      ),
      endChild: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8.0),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black54,
            fontFamily: 'LeagueSpartan',
            fontSize: screenWidth * 0.05,
          ),
        ),
      ),
      beforeLineStyle:
          LineStyle(color: lineBeforeColor ?? Colors.grey, thickness: 3),
      afterLineStyle:
          LineStyle(color: lineAfterColor ?? Colors.grey, thickness: 3),
    );
  }

  // Helper method to build info text with responsive font size
  List<Widget> _buildInfoText(double screenWidth, String text) {
    return [
      Text(
        text,
        style: TextStyle(
          fontFamily: 'LeagueSpartan',
          fontWeight: FontWeight.w500,
          color: Colors.black54,
          fontSize: screenWidth * 0.05,
        ),
      ),
    ];
  }
}

import 'package:flutter/material.dart';
import 'package:fox_connect/widget/connectivity_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:timeline_tile/timeline_tile.dart';

class LeaveApprovel extends StatefulWidget {
  @override
  State<LeaveApprovel> createState() => _LeaveApprovelState();
}

class _LeaveApprovelState extends State<LeaveApprovel>
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
    // Screen size parameters
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
                  Color(0xFF00008B).withOpacity(0.8)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          actions: [],
        ),
        body: ListView.builder(
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) {
            Animation<double> animation = CurvedAnimation(
              parent: _controller,
              curve: Interval(
                (1 / 5) * index, // Animate each item sequentially
                1.0,
                curve: Curves.easeOut,
              ),
            );
            _controller.forward(); // Start the animation when building

            return GestureDetector(
                onTap: () async {},
                child: FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.2), // Start slightly below
                        end: Offset.zero, // End at original position
                      ).animate(animation),
                      child: Column(children: [
                        // Information Container
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            height: screenHeight / 3, // Responsive height
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
                                  const SizedBox(height: 5),
                                  ..._buildInfoText(
                                    screenWidth,
                                    "Full Day",
                                  ),
                                  ..._buildInfoText(
                                    screenWidth,
                                    '2 days ago',
                                  ),
                                  ..._buildInfoText(
                                    screenWidth,
                                    'Yes',
                                  ),
                                  ..._buildInfoText(
                                    screenWidth,
                                    'Sick Leave',
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  // Horizontal Timeline Container
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      // Accept Button
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          // Add your logic for accepting
                                          print("Accepted");
                                        },
                                        icon: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 28, // Increase icon size
                                        ),
                                        label: Text(
                                          'Accept',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18, // Increase text size
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 30, vertical: 16),
                                          // Increased padding
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          elevation:
                                              5, // Optional: Add shadow for more emphasis
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      // Add space between buttons
                                      // Reject Button
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          // Add your logic for rejecting
                                          print("Rejected");
                                        },
                                        icon: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 28, // Increase icon size
                                        ),
                                        label: Text(
                                          'Reject',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18, // Increase text size
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 30, vertical: 16),
                                          // Increased padding
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          elevation:
                                              5, // Optional: Add shadow for more emphasis
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ]),
                    )));
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
        width: screenWidth * 0.09, // Increased indicator size
        color: color,
        iconStyle: IconStyle(
          iconData: icon,
          color: Colors.white,
          fontSize: screenWidth * 0.05, // Increased icon size
        ),
      ),
      endChild: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8.0),
        // Adjusted padding
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black54,
            fontFamily: 'LeagueSpartan',
            fontSize:
                screenWidth * 0.05, // Increased font size for timeline text
          ),
        ),
      ),
      beforeLineStyle:
          LineStyle(color: lineBeforeColor ?? Colors.grey, thickness: 3),
      // Slightly thicker lines
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
          fontSize: screenWidth * 0.05, // Responsive font size
        ),
      ),
    ];
  }
}

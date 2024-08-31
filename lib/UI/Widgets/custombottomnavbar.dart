import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Pages/B-Jet Details UI/B-jetDetailsUI.dart';
import '../Pages/Dashboard UI/dashboardUI.dart';
import '../Pages/ITEE Details UI/iteedetailsui.dart';
import '../Pages/ITEE Training Program Details UI/trainingprogramdetails.dart';


/// A custom widget that displays a navigation bar at the bottom of the screen
/// with icons and labels for navigating to different parts of the app.
/// It also includes a contact button that opens a dialog to call phone numbers.
class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.08,
      color: const Color.fromRGBO(0, 162, 222, 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildNavItem(
            icon: Icon(
              Icons.home,
              size: 30,
              color: Colors.white,
            ),
            label: 'Home',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Dashboard(shouldRefresh: true),
                ),
              );
            },
            context: context,
          ),
          _buildNavItem(
            icon: Icon(
              Icons.info_outline,
              size: 30,
              color: Colors.white,
            ),
            label: 'ITEE',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ITEEDetails()),
              );
            },
            context: context,
          ),
          _buildNavItem(
            icon: Image.asset(
              'Assets/Images/Bjet-Small.png',
              height: 30,
              width: 50,
            ),
            label: 'B-Jet',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BJetDetails()),
              );
            },
            context: context,
          ),
          _buildNavItem(
            icon: Image.asset(
              'Assets/Images/ITEE-Small.png',
              height: 30,
              width: 60,
            ),
            label: 'Training',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ITEETrainingProgramDetails(),
                ),
              );
            },
            context: context,
          ),
          _buildNavItem(
            icon: Icon(
              Icons.phone,
              size: 30,
              color: Colors.white,
            ),
            label: 'Contact',
            onTap: () {
              showPhoneNumberDialog(context);
            },
            context: context,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required Widget icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width /
            5,
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon,
            const SizedBox(height: 5),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                fontFamily: 'default',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showPhoneNumberDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Select a Number to Call',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromRGBO(0, 162, 222, 1),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',
                    fontSize: 22,
                  ),
                ),
              ),
              Divider()
            ],
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                phoneNumberTile(context, '0255006847'),
                Divider(),
                phoneNumberTile(context, '028181032'),
                Divider(),
                phoneNumberTile(context, '028181033'),
                Divider(),
                phoneNumberTile(context, '+8801857321122'),
                Divider(),
              ],
            ),
          ),
          actions: [
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromRGBO(0, 162, 222, 1)),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default',
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget phoneNumberTile(BuildContext context, String phoneNumber) {
    return ListTile(
      title: Text(
        phoneNumber,
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'default',
        ),
      ),
      trailing: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(0, 162, 222, 1),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: IconButton(
          icon: Icon(
            Icons.call,
            color: Colors.white,
          ),
          onPressed: () async {
            try {
              await FlutterPhoneDirectCaller.callNumber(phoneNumber);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Calling $phoneNumber...')),
              );
            } catch (e) {
              print('Error: $e');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to make the call: $e')),
              );
            }
          },
        ),
      ),
    );
  }

  _callNumber() async {
    const number = '+8801857321122';
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
  }

  Future<void> _makePhoneCall(BuildContext context, String url) async {
    print('Attempting to launch: $url');

    if (await canLaunch(url)) {
      print('Launching: $url');
      await launch(url);
    } else {
      print('Could not launch $url');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not Call $url')),
      );
    }
  }
}


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Dashboard UI/dashboardUI.dart';
import '../Login UI/loginUI.dart';

class AdmitCardDownload extends StatefulWidget {
  const AdmitCardDownload({super.key});

  @override
  State<AdmitCardDownload> createState() => _AdmitCardDownloadState();
}

class _AdmitCardDownloadState extends State<AdmitCardDownload> with SingleTickerProviderStateMixin{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 162, 222, 1),
        titleSpacing: 5,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white,),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        title: const Text(
          'Admit Card',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'default',
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_rounded, color: Colors.white,),
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white,),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(0, 162, 222, 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    child: Icon(
                      Icons.person,
                      size: 35,
                    ),
                    radius: 30,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'User Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default',
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text('Home',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Dashboard())); // Close the drawer
              },
            ),
            Divider(),
            ListTile(
              title: Text('Information',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',)),
              onTap: () {
                /* Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Information()));*/
              },
            ),
            Divider(),
            ListTile(
              title: Text('Logout',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Login())); // Close the drawer
              },
            ),
            Divider(),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          height: screenHeight,
          color: Colors.grey[100],
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Congratulations, Your Registration Successfully Submitted',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromRGBO(143, 150, 158, 1),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',
                  ),
                ),
              ),
              SizedBox(
                height: 35,
              ),
              Container(
                width: screenWidth * 0.85,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Color.fromRGBO(143, 150, 158, 1),
                      width: 1,
                    )),
                child: Column(
                  children: [
                    Text('Admit Card',
                      style: TextStyle(
                        color: Color.fromRGBO(143, 150, 158, 1),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'default',
                      ),),
                    SizedBox(height: 20,),
                    Container(
                      decoration: BoxDecoration(
                        //color: Color.fromRGBO(143, 150, 158, 1),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Color.fromRGBO(143, 150, 158, 1),
                          width: 1,
                        ),
                      ),
                      child: Icon(Icons.person,
                        size: 80,),
                    ),
                    SizedBox(height: 20,),
                    Column(
                      children: [
                        Text('Information Details',
                          style: TextStyle(
                            color: Color.fromRGBO(0, 162, 222, 1),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'default',
                          ),),
                        Divider(height: 10,),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Center Name',
                                  style: TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),),
                                Text('Course Name',
                                  style: TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),),
                                Text('Batch No',
                                  style: TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),),
                                Text('Name',
                                  style: TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),),
                                Text('Mobile No',
                                  style: TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),),
                              ],
                            ),
                            Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('BKIICT - Dhaka',
                                  style: TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),),
                                Text('Web Development (Long)',
                                  style: TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),),
                                Text('87',
                                  style: TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),),
                                Text('Md. Samiul Islam',
                                  style: TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),),
                                Text('01234567890',
                                  style: TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 10,),
                    Text('Signature',
                      style: TextStyle(
                        color: Color.fromRGBO(143, 150, 158, 1),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'default',
                      ),),
                    SizedBox(height: 10,),
                    Container(
                      decoration: BoxDecoration(
                        //color: Color.fromRGBO(143, 150, 158, 1),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Color.fromRGBO(143, 150, 158, 1),
                          width: 1,
                        ),
                      ),
                      child: Icon(Icons.edit_document,
                        size: 60,),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 35,
              ),
              Center(
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(5),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(0, 162, 222, 1),
                      fixedSize: Size(MediaQuery.of(context).size.width* 0.85, MediaQuery.of(context).size.height * 0.08),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AdmitCardDownload()));
                    },
                    child: const Text('Download',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'default',
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: screenHeight * 0.08,
        color: const Color.fromRGBO(0, 162, 222, 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Dashboard()));
              },
              child: Container(
                width: screenWidth / 3,
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.home,
                      size: 30,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Home',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: 'default',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                /* Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchUser()));*/
              },
              behavior: HitTestBehavior.translucent,
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    )),
                width: screenWidth / 3,
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.search,
                      size: 30,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Search',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: 'default',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: (){
                /*  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Information()));*/
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    )),
                width: screenWidth / 3,
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.info,
                      size: 30,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Information',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: 'default',
                      ),
                    ),
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

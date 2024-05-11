import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:itee_exam_app/Registation%20UI/paymentconfirmation.dart';

import '../Dashboard UI/dashboardUI.dart';
import '../Login UI/loginUI.dart';
import 'downloadadmitcard.dart';

class RegistrationApplicationReview extends StatefulWidget {
  const RegistrationApplicationReview({super.key});

  @override
  State<RegistrationApplicationReview> createState() =>
      _RegistrationApplicationReviewState();
}

class _RegistrationApplicationReviewState
    extends State<RegistrationApplicationReview>
    with SingleTickerProviderStateMixin {
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
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.white,
            )),
        title: const Text(
          'Registration Form',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'default',
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              //height: screenHeight*1.35,
              color: Colors.grey[100],
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Please Review and Confirm Your Application',
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
                    height: 15,
                  ),
                  Center(
                    child: Container(
                      width: screenWidth * 0.3,
                      height: screenHeight * 0.17,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Color.fromRGBO(143, 150, 158, 1),
                            width: 1,
                          )),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    width: 0.5,
                                  )),
                              child: Icon(
                                Icons.person,
                                size: 100,
                              ),
                            ),
                          ),
                          SizedBox(height:10),
                          Text(
                            'Profile Picture',
                            style: TextStyle(
                              color: Color.fromRGBO(143, 150, 158, 1),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'default',
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 25,),
                  Center(
                      child: Container(
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
                            Text('Information Details',
                              style: TextStyle(
                                color: Color.fromRGBO(0, 162, 222, 1),
                                letterSpacing: 1.2,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'default',
                              ),),
                            SizedBox(height: 10,),
                            Divider(),
                            Container(
                              padding: EdgeInsets.all(5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Center Name',
                                        style: TextStyle(
                                          color: Color.fromRGBO(143, 150, 158, 1),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'default',
                                        ),),
                                      Text('Course Type',
                                        style: TextStyle(
                                          color: Color.fromRGBO(143, 150, 158, 1),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'default',
                                        ),),
                                      Text('Course Name',
                                        style: TextStyle(
                                          color: Color.fromRGBO(143, 150, 158, 1),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'default',
                                        ),),
                                      Text('Batch No',
                                        style: TextStyle(
                                          color: Color.fromRGBO(143, 150, 158, 1),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'default',
                                        ),), Text('Course Fee',
                                        style: TextStyle(
                                          color: Color.fromRGBO(143, 150, 158, 1),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'default',
                                        ),),
                                      Text('Full Name',
                                        style: TextStyle(
                                          color: Color.fromRGBO(143, 150, 158, 1),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'default',
                                        ),),
                                      Text('Email',
                                        style: TextStyle(
                                          color: Color.fromRGBO(143, 150, 158, 1),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'default',
                                        ),), Text('Mobile Number',
                                        style: TextStyle(
                                          color: Color.fromRGBO(143, 150, 158, 1),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'default',
                                        ),), Text('Date of Birth',
                                        style: TextStyle(
                                          color: Color.fromRGBO(143, 150, 158, 1),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'default',
                                        ),), Text('Gender',
                                        style: TextStyle(
                                          color: Color.fromRGBO(143, 150, 158, 1),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'default',
                                        ),),
                                    ],
                                  ),
                                  Spacer(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('BKIICT Dhaka',
                                        style: TextStyle(
                                          color: Color.fromRGBO(143, 150, 158, 1),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'default',
                                        ),),
                                      Text('Long',
                                        style: TextStyle(
                                          color: Color.fromRGBO(143, 150, 158, 1),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'default',
                                        ),),
                                      Text('Web Development',
                                        style: TextStyle(
                                          color: Color.fromRGBO(143, 150, 158, 1),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'default',
                                        ),),
                                      Text('78',
                                        style: TextStyle(
                                          color: Color.fromRGBO(143, 150, 158, 1),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'default',
                                        ),), Text('3000 TK',
                                        style: TextStyle(
                                          color: Color.fromRGBO(143, 150, 158, 1),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'default',
                                        ),),
                                      Text('Md. Abu Bakkar',
                                        style: TextStyle(
                                          color: Color.fromRGBO(143, 150, 158, 1),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'default',
                                        ),),
                                      Text('abcd@gmail.com',
                                        style: TextStyle(
                                          color: Color.fromRGBO(143, 150, 158, 1),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'default',
                                        ),), Text('01987654789',
                                        style: TextStyle(
                                          color: Color.fromRGBO(143, 150, 158, 1),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'default',
                                        ),), Text('23-05-1999',
                                        style: TextStyle(
                                          color: Color.fromRGBO(143, 150, 158, 1),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'default',
                                        ),), Text('Male',
                                        style: TextStyle(
                                          color: Color.fromRGBO(143, 150, 158, 1),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'default',
                                        ),),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                  SizedBox(height: 15,),
                  Center(
                      child: Container(
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
                            Text('Education Details',
                              style: TextStyle(
                                color: Color.fromRGBO(0, 162, 222, 1),
                                letterSpacing: 1.2,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'default',
                              ),),
                            SizedBox(height: 10,),
                            Divider(),
                            Container(
                              padding: EdgeInsets.all(5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Education Qualification',
                                        style: TextStyle(
                                          color: Color.fromRGBO(143, 150, 158, 1),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'default',
                                        ),),
                                      Text('Decipline',
                                        style: TextStyle(
                                          color: Color.fromRGBO(143, 150, 158, 1),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'default',
                                        ),),
                                      Text('Subject',
                                        style: TextStyle(
                                          color: Color.fromRGBO(143, 150, 158, 1),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'default',
                                        ),),
                                      Text('Passing Year',
                                        style: TextStyle(
                                          color: Color.fromRGBO(143, 150, 158, 1),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'default',
                                        ),), Text('Institute',
                                        style: TextStyle(
                                          color: Color.fromRGBO(143, 150, 158, 1),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'default',
                                        ),),
                                      Text('Result',
                                        style: TextStyle(
                                          color: Color.fromRGBO(143, 150, 158, 1),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'default',
                                        ),),
                                    ],
                                  ),
                                  Spacer(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('HSC or Equivalent',
                                        style: TextStyle(
                                          color: Color.fromRGBO(143, 150, 158, 1),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'default',
                                        ),),
                                      Text('Arts',
                                        style: TextStyle(
                                          color: Color.fromRGBO(143, 150, 158, 1),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'default',
                                        ),),
                                      Text('Law',
                                        style: TextStyle(
                                          color: Color.fromRGBO(143, 150, 158, 1),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'default',
                                        ),),
                                      Text('2022',
                                        style: TextStyle(
                                          color: Color.fromRGBO(143, 150, 158, 1),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'default',
                                        ),), Text('Dhaka College',
                                        style: TextStyle(
                                          color: Color.fromRGBO(143, 150, 158, 1),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'default',
                                        ),),
                                      Text('3.98',
                                        style: TextStyle(
                                          color: Color.fromRGBO(143, 150, 158, 1),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'default',
                                        ),),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),

                  SizedBox(height: 15,),
                  Center(
                      child: Container(
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
                            Text('Certificate',
                              style: TextStyle(
                                color: Color.fromRGBO(0, 162, 222, 1),
                                letterSpacing: 1.2,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'default',
                              ),),
                            SizedBox(height: 10,),
                            Divider(),
                            Container(
                              padding: EdgeInsets.all(5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: Color.fromRGBO(143, 150, 158, 1),
                                          width: 1,
                                        )),
                                    child: Icon(
                                      Icons.school,
                                      color: Color.fromRGBO(143, 150, 158, 1),
                                      size: 120,
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: Color.fromRGBO(143, 150, 158, 1),
                                          width: 1,
                                        )),
                                    child: Icon(
                                      Icons.school,
                                      color: Color.fromRGBO(143, 150, 158, 1),
                                      size: 120,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                  SizedBox(height: 25,),
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
                                  builder: (context) => const PaymentConfirmation()));
                        },
                        child: const Text('Procced',
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
          )),
    );
  }

  void showSliderAlert(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 600,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('Bkash Payment',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromRGBO(0, 162, 222, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontFamily: 'default',
                  ),),
                ),
              ),
              Divider(),
              SizedBox(height: 20,),
              Text('Trx ID',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Color.fromRGBO(0, 162, 222, 1),
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: 'default',
              ),),
              SizedBox(height: 10,),
              Center(
                child: Container(
                  width: 380,
                  height: 70,
                  child: TextFormField(
                    style: const TextStyle(
                      color: Color.fromRGBO(143, 150, 158, 1),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default',
                    ),
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      labelText: 'Trx ID',
                      labelStyle: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'default',
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 2,),
              Text('Enter the Transaction ID from Bkash Payment',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Color.fromRGBO(143, 150, 158, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  fontFamily: 'default',
                ),),
              SizedBox(height: 45),
              Center(
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(5),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(0, 162, 222, 1),
                      fixedSize: Size(MediaQuery.of(context).size.width* 0.9, MediaQuery.of(context).size.height * 0.08),
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
                    child: const Text('Confirm',
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
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

/// A widget that displays an application card with information about an exam
/// and buttons to trigger actions like [Payment], downloading [AdmitCard],
/// and viewing [Result].
class ApplicationCard extends StatelessWidget {
  final String examName;
  final String examineeID;
  final String examCatagories;
  final int Payment;
  final int AdmitCard;
  final int Result;
  final VoidCallback onPaymentPressed;
  final VoidCallback onAdmitCardPressed;
  final VoidCallback onResultPressed;

  ApplicationCard({
    required this.examName,
    required this.examineeID,
    required this.examCatagories,
    required this.Payment,
    required this.AdmitCard,
    required this.Result,
    required this.onPaymentPressed,
    required this.onAdmitCardPressed,
    required this.onResultPressed,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Card(
      borderOnForeground: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Examinee ID: $examineeID',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Exam Type: $examName',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Exam Catagories: $examCatagories',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.only(bottom: 5, left: 5, right: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Visibility(
                  visible: Result == 1,
                  child: Expanded(
                    child: GestureDetector(
                      onTap: onResultPressed,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(0, 162, 222, 1),
                          border: Border.all(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Result',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'default',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                Visibility(
                  visible: Payment == 0,
                  child: Expanded(
                    child: GestureDetector(
                      onTap: onPaymentPressed,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(0, 162, 222, 1),
                          border: Border.all(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Pay Now',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'default',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                Visibility(
                  visible: AdmitCard == 1,
                  child: Expanded(
                    child: GestureDetector(
                      onTap: onAdmitCardPressed,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(0, 162, 222, 1),
                          border: Border.all(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Admit Card',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'default',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

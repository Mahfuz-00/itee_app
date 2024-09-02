import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:http/http.dart' as http;
import '../../Data/Data Sources/API Service (Admit Card)/apiserviceAdmitCard.dart';

/// A widget that displays an admit card for an exam containing
/// examinee information and a button to download and print the admit card.
///
/// The [ExamineeID] represents the unique ID of the examinee.
/// [ExamType] indicates the type of exam being taken.
/// [ExamCatagory] specifies the category of the exam.
/// [Name] is the name of the examinee.
/// [URL] is the link to download the admit card.
class AdmitCardCard extends StatelessWidget {
  final String ExamineeID;
  final String ExamType;
  final String ExamCatagory;
  final String Name;
  final String URL;


  AdmitCardCard({
    Key? key,
    required this.ExamineeID,
    required this.ExamType,
    required this.ExamCatagory,
    required this.Name,
    required this.URL,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    return Material(
      elevation: 5,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white, // Sets the background color of the card.
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRow('Examinee ID', ExamineeID),
                _buildRow('Name', Name),
                _buildRow('Exam Type', ExamType),
                _buildRow('Exam Catagories', ExamCatagory),
                SizedBox(height: 15,),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      GetAdmitCardLinkandPrint(
                          context, ExamineeID);
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(
                          MediaQuery.of(context).size.width * 0.6,
                          MediaQuery.of(context).size.height * 0.06),
                      primary: Color.fromRGBO(0, 162, 222, 1), // Background color
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0), // Rounded corners
                      ),
                    ),
                    child: Text(
                      'Download Admit Card',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'default',
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool _isFetchedPrint = false;
  late String link = "";
  bool _isLoading = false;

  Future<void> GetAdmitCardLinkandPrint(BuildContext context, String examineeId) async {
    if (_isFetchedPrint) return;

    try {
      const snackBar = SnackBar(
        content: Text('Processing, Please wait'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      final apiService = await AdmitCardAPIService.create();

      // Fetch dashboard data
      final Map<String, dynamic> dashboardData =
      await apiService.fetchAdmitCardItems(examineeId);
      if (dashboardData == null || dashboardData.isEmpty) {
        // No data available or an error occurred
        print(
            'No data available or error occurred while fetching dashboard data');
        return;
      }

      link = dashboardData['download'].toString();

      if (link != null)
        generatePDF(context, link);
      else {
        const snackBar = SnackBar(
          content: Text('Error: You did not Registered in this Exam'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

      _isLoading = true;
      // Simulate fetching data for 5 seconds
      await Future.delayed(Duration(seconds: 1));
      _isFetchedPrint = true;
    } catch (e) {
      print('Error fetching connection requests: $e');
      _isFetchedPrint = true;
      // Handle error as needed
    }
  }

  Future<void> generatePDF(BuildContext context, String link) async {
    const snackBar = SnackBar(
      content: Text(
          'Preparing Printing, Please wait..., Please while printing change page orientation to horizontal'),
    );
    ScaffoldMessenger.of(context as BuildContext).showSnackBar(snackBar);
    print('Print Triggered!!');

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents the dialog from being dismissed
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      print('PDF generated successfully. Download URL: $link');
      final Uri url = Uri.parse(link);
      var data = await http.get(url);
      await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => data.bodyBytes);
    } catch (e) {
      // Handle any errors
      print('Error generating PDF: $e');
    } finally {
      // Remove the loading indicator
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}


Widget _buildRow(String label, String value) {
  return Container(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: label,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    height: 1.6,
                    letterSpacing: 1.3,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            ":",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    height: 1.6,
                    letterSpacing: 1.3,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}


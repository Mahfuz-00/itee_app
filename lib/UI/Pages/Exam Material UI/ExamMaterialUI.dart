import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:http/http.dart' as http;
import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Course Outline)/apiserviceCourseOutline.dart';
import '../../Widgets/custombottomnavbar.dart';

/// Represents the Exam Material screen that allows users to download exam materials.
///
/// This widget fetches and displays exam materials, providing options to download them as PDFs.
///
/// **Variables:**
/// - [shouldRefresh]: Indicates whether the page should refresh the exam materials.
/// - [_isLoading]: Indicates the loading state of the data.
/// - [name]: Holds the name of the exam material.
/// - [isloaded]: Indicates whether the data has been loaded.
/// - [_pageLoading]: Indicates if the page is in a loading state.
/// - [_isFetched]: Indicates whether the exam materials have been fetched.
/// - [records]: Stores the list of exam materials retrieved from the API.
///
/// **Actions:**
/// - `fetchConnectionRequests`: Fetches exam material items from the API.
/// - `initState`: Initializes the state and fetches data when the widget is created.
/// - `dispose`: Cleans up resources when the widget is removed.
/// - `build`: Builds the UI for the Exam Material screen.
/// - `_buildDotPointItem`: Creates a list item for each exam material with a download link.
/// - `generatePDF`: Generates a PDF from the download link.
class ExamMaterialUI extends StatefulWidget {
  final bool shouldRefresh;

  const ExamMaterialUI({Key? key, this.shouldRefresh = false}) : super(key: key);

  @override
  State<ExamMaterialUI> createState() => _ExamMaterialUIState();
}

class _ExamMaterialUIState extends State<ExamMaterialUI> {
  bool _isLoading = false;
  late final String name;
  bool isloaded = false;
  bool _pageLoading = true;
  bool _isFetched = false;
  List<Map<String, dynamic>> records = [];

  Future<void> fetchConnectionRequests() async {
    if (_isFetched) return;
    try {
      final apiService = await ExamMaterialAPIService.create();

      final Map<String, dynamic> dashboardData =
          await apiService.fetchExamMaterialItems();
      if (dashboardData == null || dashboardData.isEmpty) {
        print(
            'No data available or error occurred while fetching dashboard data');
        return;
      }

      records = List<Map<String, dynamic>>.from(dashboardData['records']);
      if (records == null || records.isEmpty) {
        print('No records available');
        return;
      }
      print(records);

      setState(() {
        _isLoading = true;
      });

      await Future.delayed(Duration(seconds: 1));

      setState(() {
        _isFetched = true;
      });
    } catch (e) {
      print('Error fetching connection requests: $e');
      _isFetched = true;
    }
  }

  @override
  void initState() {
    super.initState();
    print('initState called');
    if (!_isFetched) {
      fetchConnectionRequests();
    }
    Future.delayed(Duration(seconds: 4), () {
      setState(() {
        _pageLoading = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return  _pageLoading
        ? Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    )
        : InternetConnectionChecker(
      child: PopScope(
        canPop: true,
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            backgroundColor: const Color.fromRGBO(0, 162, 222, 1),
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: Colors.white,
                )),
            title: Text(
              'Exam Material',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'default',
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Download Exam Material',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'default',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: records.length,
                        itemBuilder: (context, index) {
                          final syllabusItem = records[index];
                          return _buildDotPointItem(syllabusItem['name'],
                              syllabusItem['download_link']);
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: CustomBottomNavBar(),
        ),
      ),
    );
  }

  Widget _buildDotPointItem(String name, String link) {
    return Container(
      padding: EdgeInsets.only(left: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 6),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () {
                generatePDF(context, link);
              },
              child: Text(
                name,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'default',
                  decoration:
                  TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> generatePDF(BuildContext context, String link) async {
    const snackBar = SnackBar(
      content: Text(
          'Preparing Printing, Please wait'),
    );
    ScaffoldMessenger.of(context as BuildContext).showSnackBar(snackBar);
    print('Print Triggered!!');

    try {
      print('PDF generated successfully. Download URL: ${link}');
      final Uri url = Uri.parse(link);
      var data = await http.get(url);
      await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => data.bodyBytes);
    } catch (e) {
      print('Error generating PDF: $e');
    }
  }
}

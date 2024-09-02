import 'dart:io';
import 'dart:async';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Syllabus)/apiserviceSyllabus.dart';
import '../../Widgets/custombottomnavbar.dart';

/// The Syllabus class represents the syllabus screen in the application.
/// It fetches syllabus items from the API and displays them in a list,
/// allowing users to download PDFs of the syllabus items.
///
/// **Variables:**
/// - [shouldRefresh]: Indicates if the screen should refresh when initialized.
/// - [_isLoading]: Indicates if data is currently being loaded.
/// - [name]: Holds the name of the syllabus item.
/// - [isloaded]: Indicates if the data has been loaded.
/// - [_pageLoading]: Indicates if the page is still loading.
/// - [_isFetched]: Indicates if the syllabus items have been fetched.
/// - [records]: A list of syllabus records fetched from the API.
///
/// **Actions:**
/// - 'fetchConnectionRequests': Fetches syllabus items from the API.
/// - 'generatePDF': Generates a PDF from a given download link.
class Syllabus extends StatefulWidget {
  final bool shouldRefresh;

  const Syllabus({Key? key, this.shouldRefresh = false}) : super(key: key);

  @override
  State<Syllabus> createState() => _SyllabusState();
}

class _SyllabusState extends State<Syllabus> {
  bool _isLoading = false;
  late final String name;
  bool isloaded = false;
  bool _pageLoading = true;
  bool _isFetched = false;
  List<Map<String, dynamic>> records = [];

  Future<void> fetchConnectionRequests() async {
    if (_isFetched) return;
    try {
      final apiService = await SyllabusAPIService.create();

      final Map<String, dynamic> dashboardData =
          await apiService.fetchSyllabusItems();
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
      // Handle error as needed
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
        : InternetChecker(
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
              'Syllabus',
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
                          'Download Syllabus',
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
          bottomNavigationBar: CustomBottomNavigationBar(),
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

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:http/http.dart' as http;
import '../../../Data/Data Sources/API Service (Admit Card)/apiserviceAdmitCard.dart';
import '../../../Data/Data Sources/API Service (Result)/apiserviceResult.dart';
import 'appilcationcard.dart';
import 'listTileDashboardApplication.dart';

class ApplicationCarousel extends StatefulWidget {
  final List<Widget> applicationWidgets;

  const ApplicationCarousel({Key? key, required this.applicationWidgets}) : super(key: key);

  @override
  _ApplicationCarouselState createState() => _ApplicationCarouselState();
}

class _ApplicationCarouselState extends State<ApplicationCarousel> {
  int _currentApplicationPage = 0;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: 220,
      width: screenWidth,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: widget.applicationWidgets.isEmpty
          ? Center(
        child: Text(
          'You haven\'t made any Application',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
            fontFamily: 'default',
            fontWeight: FontWeight.bold,
          ),
        ),
      )
          : Stack(
        children: [
          PageView.builder(
            controller: PageController(viewportFraction: 1),
            itemCount: widget.applicationWidgets.length,
            onPageChanged: (index) {
              setState(() {
                _currentApplicationPage = index;
              });
            },
            itemBuilder: (context, index) {
              ApplicationTemplate applicant = widget.applicationWidgets[index] as ApplicationTemplate;
              return ApplicationCard(
                examName: applicant.name,
                examineeID: applicant.ExamineeID,
                examCatagories: applicant.Categories,
                Payment: applicant.payment,
                AdmitCard: applicant.admitcard,
                Result: applicant.result,
                onPaymentPressed: () {},
                onAdmitCardPressed: () {
                  GetAdmitCardLinkandPrint(applicant.ExamineeID);
                },
                onResultPressed: () {
                  GetResult(applicant.ExamineeID);
                },
              );
            },
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.arrow_back_ios,
              color: _currentApplicationPage == 0 ? Colors.white : Colors.black,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.arrow_forward_ios,
              color: _currentApplicationPage == widget.applicationWidgets.length - 1
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  bool _isFetchedPrint = false;
  late String link = "";
  bool _isLoading = false;
  bool _isFetchedResult = false;

  Future<void> GetAdmitCardLinkandPrint(String examineeId) async {
    if (_isFetchedPrint) return;

    try {
      const snackBar = SnackBar(
        content: Text('Processing, Please wait'),
      );
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(snackBar);
      final apiService = await AdmitCardAPIService.create();
      final Map<String, dynamic> dashboardData =
      await apiService.fetchAdmitCardItems(examineeId);
      if (dashboardData == null || dashboardData.isEmpty) {
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
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(snackBar);
      }

      setState(() {
        _isLoading = true;
      });

      await Future.delayed(Duration(seconds: 1));

      setState(() {
        _isFetchedPrint = true;
      });
    } catch (e) {
      print('Error fetching connection requests: $e');
      _isFetchedPrint = true;
    }
  }

  Future<void> generatePDF(BuildContext context, String link) async {
    const snackBar = SnackBar(
      content: Text(
          'Preparing Printing, Please wait..., Please while printing change page orientation to horizontal'),
    );
    ScaffoldMessenger.of(context as BuildContext).showSnackBar(snackBar);
    print('Print Triggered!!');

    showDialog(
      context: context,
      barrierDismissible: false,
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
      print('Error generating PDF: $e');
    } finally {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  Future<void> GetResult(String examineeID) async {
    if (_isFetchedResult) return;

    try {
      const snackBar = SnackBar(
        content: Text('Processing, Please wait'),
      );
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(snackBar);
      final apiService = await ResultAPIService.create();

      final Map<String, dynamic>? ResultData =
      await apiService.getResult(examineeID);
      if (ResultData == null || ResultData.isEmpty) {
        print(
            'No data available or error occurred while fetching dashboard data');
        return;
      }

      final Map<String, dynamic> result = await ResultData['records'];
      print(result);
      final String name = result['name'];
      final String examName = result['exam_type'];
      final String session = result['passing_session'];
      final String passerID = result['passer_id'];
      final String morningPasser = result['morning_passer'];
      final String afternoonPasser = result['afternoon_passer'];
      final int passed = result['passed'];

      showResultDialog(context, name, examName, session, passerID,
          morningPasser, afternoonPasser, passed);

      setState(() {
        _isFetchedResult = true;
      });
      setState(() {
        _isFetchedResult = false;
      });
    } catch (e) {
      const snackBar = SnackBar(
        content: Text('Error fetching results: Failed to load result'),
      );
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(snackBar);
      print('Error fetching results: $e');
      setState(() {
        _isFetchedResult = true;
      });
      setState(() {
        _isFetchedResult = false;
      });
    }
  }

  void showResultDialog(
      BuildContext context,
      String name,
      String examName,
      String session,
      String passerID,
      String morningPasser,
      String afternoonPasser,
      int passed) {
    String result = '';
    if (examName == 'fe') {
      if (morningPasser == '1' && afternoonPasser == '1') {
        result = 'Passed';
      } else if (morningPasser == '1' && afternoonPasser == '0') {
        result = 'Morning Passed';
      } else if (morningPasser == '0' && afternoonPasser == '1') {
        result = 'Afternoon Passed';
      } else if (morningPasser == '0' && afternoonPasser == '0') {
        result = 'Failed';
      }
    } else {
      if (passed == 1) {
        result = 'Passed';
      } else {
        result = 'Failed';
      }
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Exam Result',
              style: TextStyle(
                color: Color.fromRGBO(0, 162, 222, 1),
                fontWeight: FontWeight.bold,
                fontSize: 25,
                fontFamily: 'default',
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (result == 'Passed' ||
                  result == 'Morning Passed' ||
                  result == 'Afternoon Passed') ...[
                Center(
                  child: Text(
                    'Congratulations',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontFamily: 'default',
                    ),
                  ),
                ),
                SizedBox(height: 15),
              ],
              _buildRow('Name', name),
              _buildRow('Exam Name', examName),
              _buildRow('Session', session),
              _buildRow('Result', result),
              if (result == 'Passed' ||
                  result == 'Morning Passed' ||
                  result == 'Afternoon Passed') ...[
                _buildRow('Passer ID', passerID),
              ],
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(0, 162, 222, 1),
                  fixedSize: Size(MediaQuery.of(context).size.width * 0.3,
                      MediaQuery.of(context).size.height * 0.05),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Close',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    fontFamily: 'default',
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }


  Widget _buildRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: label,
                  style: TextStyle(
                    color: Color.fromRGBO(143, 150, 158, 1),
                    fontSize: 18,
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
              color: Color.fromRGBO(143, 150, 158, 1),
              fontSize: 18,
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
                    color: Color.fromRGBO(143, 150, 158, 1),
                    fontSize: 18,
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
    );
  }

}

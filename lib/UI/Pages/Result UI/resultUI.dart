import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:itee_exam_app/UI/Widgets/CardWidget.dart';
import '../../../Data/Data Sources/API Service (Result)/apiserviceresultview.dart';
import '../../Widgets/custombottomnavbar.dart';
import '../../Widgets/resultcard.dart';

/// Represents the result screen that displays examination results.
///
/// This widget fetches and displays the results of the examinations taken by the user.
///
/// **Variables:**
/// - [shouldRefresh]: Indicates whether the screen should refresh.
/// - [_isLoading]: Indicates if the results are currently loading.
/// - [name]: Holds the name of the user.
/// - [isloaded]: Indicates whether the data has been loaded.
/// - [buttonClicked]: Indicates if the button has been clicked.
/// - [_isFetched]: Indicates if the data has been fetched from the API.
/// - [_resultWidgets]: Holds a list of result widgets to be displayed on the screen.
///
/// **Actions:**
/// - `fetchConnectionRequests`: Fetches the examination results from the API and updates the UI accordingly.
class Result extends StatefulWidget {
  final bool shouldRefresh;

  const Result({Key? key, this.shouldRefresh = false}) : super(key: key);

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  bool _isLoading = false;
  late final String name;
  bool isloaded = false;
  bool buttonClicked = false;
  bool _isFetched = false;
  List<Widget> _resultWidgets = [];

  Future<void> fetchConnectionRequests() async {
    if (_isFetched) return;
    try {
      final apiService = await ResultViewAPIService.create();

      final Map<String, dynamic>? dashboardData =
          await apiService.getallResult();
      if (dashboardData == null || dashboardData.isEmpty) {
        print(
            'No data available or error occurred while fetching dashboard data');
        return;
      }

      final List<dynamic> records = dashboardData['records'];
      if (records == null || records.isEmpty) {
        print('No records available');
        setState(() {
          _resultWidgets = [];
          _isFetched = true;
        });
        return;
      }

      for (var index = 0; index < records.length; index++) {
        print('Results at index $index: ${records[index]}\n');
      }

      setState(() {
        _isLoading = true;
      });

      final List<Widget> ResultWidgets;

      ResultWidgets = records.map((item) {
        return ResultCard(
          PasserID: item['passer_id'],
          Name: item['name'],
          ExamineeID: item['examine_id'],
          DateOfBirth: item['dob'],
          MorningPasser: item['morning_passer'],
          AfternoonPasser: item['afternoon_passer'],
          PassingSession: item['passing_session'],
          ExamType: item['exam_type'],
        );
      }).toList();

      setState(() {
        _resultWidgets = ResultWidgets;
      });

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
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return PopScope(
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
            'Result',
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
                padding: const EdgeInsets.only(top: 50.0, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Your Result(s)',
                        style: TextStyle(
                          color: Color.fromRGBO(0, 162, 222, 1),
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'default',
                        ),
                      )
                    ),
                    SizedBox(height: 20),
                    Column(
                      children: [
                        CardWidget(
                          loading: _isLoading,
                          fetch: _isFetched,
                          errorText: 'Your Result is not Published Yet.',
                          listWidget: _resultWidgets,
                          fetchData: fetchConnectionRequests(),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(),
      ),
    );
  }
}

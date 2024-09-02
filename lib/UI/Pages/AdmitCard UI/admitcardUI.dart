import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:itee_exam_app/UI/Widgets/CardWidget.dart';
import '../../../Data/Data Sources/API Service (Admit Card)/apiserviceadmitcardview.dart';
import '../../Widgets/admitcardCard.dart';
import '../../Widgets/custombottomnavbar.dart';

/// Represents the Admit Card screen where users can download their admit cards.
///
/// This widget fetches and displays the admit cards associated with the user.
///
/// **Variables:**
/// - [shouldRefresh]: Indicates whether the screen should refresh.
/// - [_isLoading]: Indicates if the admit card data is currently loading.
/// - [name]: Holds the name of the user.
/// - [isloaded]: Indicates whether the data has been loaded.
/// - [buttonClicked]: Indicates if the button has been clicked.
/// - [_isFetched]: Indicates if the data has been fetched from the API.
/// - [_admitcardWidgets]: Holds a list of admit card widgets to be displayed on the screen.
///
/// **Actions:**
/// - `fetchConnectionRequests()`: Fetches the admit cards from the API and updates the UI.
class AdmitCard extends StatefulWidget {
  final bool shouldRefresh;

  const AdmitCard({Key? key, this.shouldRefresh = false}) : super(key: key);

  @override
  State<AdmitCard> createState() => _AdmitCardState();
}

class _AdmitCardState extends State<AdmitCard> {
  bool _isLoading = false;
  late final String name;
  bool isloaded = false;
  bool buttonClicked = false;
  bool _isFetched = false;
  List<Widget> _admitcardWidgets = [];

  Future<void> fetchConnectionRequests() async {
    if (_isFetched) return;
    try {
      final apiService = await AdmitCardViewAPIService.create();

      final Map<String, dynamic>? dashboardData =
      await apiService.getallAdmitCard();
      if (dashboardData == null || dashboardData.isEmpty) {
        print(
            'No data available or error occurred while fetching dashboard data');
        return;
      }

      final List<dynamic> records = dashboardData['records'];
      if (records == null || records.isEmpty) {
        // No records available
        print('No records available');
        setState(() {
          _admitcardWidgets = [];
          _isFetched = true;
        });
        return;
      }

      for (var index = 0; index < records.length; index++) {
        print('Admit Card at index $index: ${records[index]}\n');
      }

      setState(() {
        _isLoading = true;
      });

      final List<Widget> AdmitCardWidgets = records.map((item) {
        int index = records.indexOf(item);
        print(records[index]);
        return AdmitCardCard(
          ExamineeID: item['examine_id'],
          ExamType: item['exam_type'],
          ExamCatagory: item['exam_category'],
          Name: item['examine_name'],
          URL: item['admit_download'],

        );
      }).toList();

      setState(() {
        _admitcardWidgets = AdmitCardWidgets;
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
        //resizeToAvoidBottomInset: false,
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
            'Download Admit Card',
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
                          'Your Admit Card(s)',
                          style: TextStyle(
                            color: Color.fromRGBO(0, 162, 222, 1),
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'default',
                          ),
                        )),
                    SizedBox(height: 20),
                    Column(
                      children: [
                        CardWidget(
                          loading: _isLoading,
                          fetch: _isFetched,
                          errorText: 'Please Register a Exam. If You did then Pay First',
                          listWidget: _admitcardWidgets,
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

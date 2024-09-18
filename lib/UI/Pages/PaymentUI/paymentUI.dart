import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:itee_exam_app/UI/Widgets/CardWidget.dart';
import 'package:itee_exam_app/UI/Widgets/paymentCard.dart';
import '../../../Data/Data Sources/API Service (Payment)/apiservicepaymentview.dart';
import '../../Widgets/custombottomnavbar.dart';

/// [PaymentUI] is a StatefulWidget that manages the display of payment information
/// for users. It fetches payment data from an API and presents it as a list
/// of payment cards, each containing details about a specific payment.
///
/// Properties:
/// - [shouldRefresh]: A boolean indicating whether the widget should refresh its content.
///
/// This widget allows users to view their payments and offers a user-friendly interface
/// for displaying payment-related information. It includes loading indicators to manage
/// the user experience while data is being fetched.
class PaymentUI extends StatefulWidget {
  final bool shouldRefresh;

  const PaymentUI({Key? key, this.shouldRefresh = false}) : super(key: key);

  @override
  State<PaymentUI> createState() => _PaymentUIState();
}

class _PaymentUIState extends State<PaymentUI> {
  bool _isLoading = false;
  late final String name;
  bool isloaded = false;
  bool buttonClicked = false;
  bool _isFetched = false;
  List<Widget> _paymentWidgets = [];

  Future<void> fetchConnectionRequests() async {
    if (_isFetched) return;
    try {
      final apiService = await PaymentViewAPIService.create();

      final Map<String, dynamic>? dashboardData =
          await apiService.getallPayment();
      if (dashboardData == null || dashboardData.isEmpty) {
        print(
            'No data available or error occurred while fetching dashboard data');
        return;
      }

      final List<dynamic> records = dashboardData['records'];
      if (records == null || records.isEmpty) {
        print('No records available');
        setState(() {
          _paymentWidgets = [];
          _isFetched = true;
        });
        return;
      }

      for (var index = 0; index < records.length; index++) {
        print('Payment at index $index: ${records[index]}\n');
      }

      setState(() {
        _isLoading = true;
      });

      final List<Widget> PaymentWidgets;

      PaymentWidgets = records.map((item) {
        List<Map<String, dynamic>> books =
            List<Map<String, dynamic>>.from(item['books']);
        print('Book:: $books');
        int index = records.indexOf(item);
        return PaymentCard(
          ExamineeID: item['examine_id'],
          ExamType: item['exam_type'],
          ExamCatagory: item['exam_category'],
          Books: books,
          ExamRegID: item['exam_registration_id'].toString(),
          ExamFee: item['exam_fee'],
        );
      }).toList();

      setState(() {
        _paymentWidgets = PaymentWidgets;
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
            'Payment',
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
                      'Your Payment(s)',
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
                          errorText: 'No Outstanding Dues',
                          listWidget: _paymentWidgets,
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
        bottomNavigationBar: CustomBottomNavBar(),
      ),
    );
  }
}

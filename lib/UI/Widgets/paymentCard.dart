import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_sslcommerz/model/SSLCCustomerInfoInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/model/sslproductinitilizer/General.dart';
import 'package:flutter_sslcommerz/model/sslproductinitilizer/NonPhysicalGoods.dart';
import 'package:flutter_sslcommerz/model/sslproductinitilizer/SSLCProductInitializer.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../../Data/Data Sources/API Service (Fetch Applicant Info)/apiServiceFetchApplicantinfo.dart';
import '../../Data/Data Sources/API Service (Payment)/apiServiceSubmitTransaction.dart';
import '../Pages/Dashboard UI/dashboardUI.dart';

/// A widget that displays a payment card with applicant information,
/// exam details, book fees, and a pay button.
///
/// **Parameters:**
/// - [ExamineeID]: The ID of the examinee.
/// - [ExamType]: The type of exam.
/// - [ExamCatagory]: The category of the exam.
/// - [Books]: A list of books associated with the exam, each containing details such as name and fees.
class PaymentCard extends StatefulWidget {
  final String ExamFee;
  final String ExamRegID;
  final String ExamineeID;
  final String ExamType;
  final String ExamCatagory;
  final List<Map<String, dynamic>> Books;
  final String city;

  const PaymentCard({
    Key? key,
    required this.ExamFee,
    required this.ExamRegID,
    required this.ExamineeID,
    required this.ExamType,
    required this.ExamCatagory,
    required this.Books,
    required this.city,
  }) : super(key: key);

  @override
  State<PaymentCard> createState() => _PaymentCardState();

  static const String storeId = "rajsh6554638e006b6";
  static const String storePassword = "rajsh6554638e006b6@ssl";
/*  static const String storeId = "alhadiexpresscombdlive";
  static const String storePassword = "65799DFDC086795715";*/
  static const String apiUrl =
      "https://sandbox.sslcommerz.com/gwprocess/v3/api.php";
  static const String requestedUrl =
      "https://sandbox.sslcommerz.com/validator/api/validationserverAPI.php?val_id=\$val_id&store_id=\$store_id&store_passwd=\$store_passwd&v=1&format=json";
}

class _PaymentCardState extends State<PaymentCard> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final bookNames = widget.Books.map((book) => book['book_name']).join(', ');
    final totalBookFees = widget.Books.fold(
        0.0, (sum, book) => sum + (double.parse(book['book_fees'].toString())));

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
                _buildRow('Examinee ID', widget.ExamineeID),
                _buildRow('Exam Type', widget.ExamType),
                _buildRow('Exam Catagories', widget.ExamCatagory),
                _buildRow('Book Names', bookNames),
                _buildRow('Total Book Fees', '${totalBookFees.toInt()} TK'),
                SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      fetchInfo();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(0, 162, 222, 1),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      side: BorderSide(color: Colors.white, width: 2.0),
                    ),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: MediaQuery.of(context).size.width * 0.6,
                      alignment: Alignment.center,
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
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool _isFetched = false;
  bool _isSubmit = false;
  bool _isLoading = false;

  Future<void> submitTransaction(String RegID, String TransID, String TransDate,
      String TransType, double Amount) async {
    _isSubmit = false;
    if (_isSubmit) return;
    try {
      final apiService = await SubmitTransactionAPIService.create();

      final Map<String, dynamic>? dashboardData =
          await apiService.submitTransaction(
              examRegistrationId: RegID,
              transactionId: TransID,
              transactionDate: TransDate,
              transactionType: TransType,
              transactionAmount: Amount.toString());
      if (dashboardData == null || dashboardData.isEmpty) {
        print(
            'No data available or error occurred while fetching dashboard data');
        return;
      }
      print(dashboardData);

      final String message = dashboardData['message'];
      if (message == 'Transaction data save successfully') {
        print('Transaction data save successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Transaction Completed'),
            duration: Duration(seconds: 3),
          ),
        );
        return;
      } else if (message == 'Transaction data save error') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Transaction is not Completed'),
            duration: Duration(seconds: 3),
          ),
        );
      } else if (message == 'Exam Registration not found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Exam Registration not found'),
            duration: Duration(seconds: 3),
          ),
        );
      }

      setState(() {
        _isSubmit = true;
      });
    } catch (e) {
      print('Error fetching connection requests: $e');
      _isSubmit = true;
    }
  }

  Future<void> fetchInfo() async {
    print(widget.ExamRegID);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Processing. Please Wait...'),
        duration: Duration(seconds: 3),
      ),
    );
    _isFetched = false;
    if (_isFetched) return;
    try {
      final apiService = await ApplicantInfoAPIService.create();

      final Map<String, dynamic>? dashboardData =
          await apiService.FetchApplicantInfo(widget.ExamRegID);
      if (dashboardData == null || dashboardData.isEmpty) {
        print(
            'No data available or error occurred while fetching dashboard data');
        return;
      }

      print(dashboardData);

      final Map<String, dynamic> records = dashboardData['records'];
      if (records == null || records.isEmpty) {
        print('No records available');
        return;
      }

      final Name = records['name'];
      final Email = records['email'];
      final Mobile = records['phone'];
      final Address = records['address'];
      final PostCode = records['post_code'];

      startPayment(context, Name, Email, Mobile, Address, PostCode);

      setState(() {
        _isLoading = true;
      });

      print(records);

      setState(() {
        _isFetched = true;
      });
    } catch (e) {
      print('Error fetching connection requests: $e');
      _isFetched = true;
    }
  }

  void startPayment(BuildContext context, String Name, String Email,
      String Mobile, String Address, String PostCode) async {
    String tranId = generateTransactionId();

    final totalBookFees = widget.Books.fold(
        0.0, (sum, book) => sum + (double.parse(book['book_fees'].toString())));
    final examfee = widget.ExamFee;
    print(widget.ExamFee);
    String examfeeString = examfee.replaceAll(RegExp(r'[^\d.]'), '');
    final totalAmount = totalBookFees + double.parse(examfeeString);

    Sslcommerz sslcommerz = Sslcommerz(
      initializer: SSLCommerzInitialization(
        multi_card_name: "visa,master,bkash,rocket,nagad",
        currency: SSLCurrencyType.BDT,
        product_category: "Exam Fee",
        sdkType: SSLCSdkType.LIVE,
        store_id: PaymentCard.storeId,
        store_passwd: PaymentCard.storePassword,
        total_amount: totalAmount,
        tran_id: tranId,
      ),
    )
      ..addCustomerInfoInitializer(
        customerInfoInitializer: SSLCCustomerInfoInitializer(
          customerState: widget.city,
          customerName: Name,
          customerEmail: Email,
          customerAddress1: Address,
          customerCity: widget.city,
          customerPostCode: PostCode,
          customerCountry: "Bangladesh",
          customerPhone: Mobile,
        ),
      )
      ..addProductInitializer(
        sslcProductInitializer: SSLCProductInitializer(
          productName: "Exam Registration and Book Fee",
          productCategory: "Education",
          general: General(
            productProfile: "Online Exam and Book Payment",
            general: "Exam Registration Fee, Book Purchase",
          ),
        ),
      )
      ..addProductInitializer(
        sslcProductInitializer:
            SSLCProductInitializer.WithNonPhysicalGoodsProfile(
          productName: "Exam Registration and Book Fee",
          productCategory: "Education",
          nonPhysicalGoods: NonPhysicalGoods(
            productProfile: "Online Exam and Book Payment",
            nonPhysicalGoods: "Exam Registration Fee, Book Purchase",
          ),
        ),
      );

    try {
      var result = await sslcommerz.payNow();
      print("result :: ${jsonEncode(result)}");
      print("result status :: ${result.status ?? ""}");
      print(
          "Transaction is ${result.status} and Amount is ${result.amount ?? 0}");

      var jsonData = result.toJson();
      String transactionId = jsonData['tran_id'] ?? 'N/A';
      String examRegistrationId = widget.ExamRegID;
      String transactionDate = jsonData['tran_date'] ?? 'N/A';
      String transactionType = jsonData['card_type'] ?? 'N/A';

      if (result.status!.toLowerCase() == "failed") {
        Fluttertoast.showToast(
          msg: "Transaction is Failed....",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else if (result.status!.toLowerCase() == "closed") {
        Fluttertoast.showToast(
          msg: "SDK Closed by User",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        await submitTransaction(examRegistrationId, transactionId,
                transactionDate, transactionType, totalAmount)
            .then((_) {
          Fluttertoast.showToast(
            msg:
                "Transaction is ${result.status} and Amount is ${result.amount ?? 0}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => DashboardUI(
                        shouldRefresh: true,
                      )),
              (route) => false);
        });

        if (result.status!.toLowerCase() == "valid") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Payment successful!'),
          ));
        }
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Payment error: $e'),
      ));
    }
  }

  String generateTransactionId() {
    const String chars = '0123456789';
    final Random random = Random();
    String randomId = '';

    for (int i = 0; i < 10; i++) {
      randomId += chars[random.nextInt(chars.length)];
    }

    String date = DateFormat('yyMMdd').format(DateTime.now());
    String transactionId = 'ITEE$date$randomId';

    print(transactionId);
    return transactionId;
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

import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_sslcommerz/model/SSLCCustomerInfoInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/model/sslproductinitilizer/NonPhysicalGoods.dart';
import 'package:flutter_sslcommerz/model/sslproductinitilizer/SSLCProductInitializer.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../../Data/Data Sources/API Service (Fetch Applicant Info)/apiServiceFetchApplicantinfo.dart';
import '../../Data/Data Sources/API Service (Payment)/apiServiceSubmitBookTransaction.dart';
import '../Pages/Dashboard UI/dashboardUI.dart';

/// A widget that displays a card representing a book with its name and price,
/// and a button to buy the book.
///
/// This widget contains the following parameters:
///
/// * [bookName]: The name of the book.
/// * [bookPrice]: The price of the book.
class BookCard extends StatefulWidget {
  final int bookId;
  final String bookName;
  final String bookPrice;

  BookCard({
    required this.bookId,
    required this.bookName,
    required this.bookPrice,
  });

  @override
  State<BookCard> createState() => _BookCardState();

  static const String storeId = "mrtou66baeda11df08";
  static const String storePassword = "mrtou66baeda11df08@ssl";
  static const String apiUrl =
      "https://sandbox.sslcommerz.com/gwprocess/v3/api.php";
  static const String requestedUrl =
      "https://sandbox.sslcommerz.com/validator/api/validationserverAPI.php?val_id=\$val_id&store_id=\$store_id&store_passwd=\$store_passwd&v=1&format=json";
}

class _BookCardState extends State<BookCard> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Book Name: ${widget.bookName}',
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
                    'Book Price: ${widget.bookPrice}',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default',
                    ),
                  ),
                  SizedBox(height: 40),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        fetchInfo();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(0, 162, 222, 1),
                        fixedSize: Size(MediaQuery.of(context).size.width * 0.6,
                            MediaQuery.of(context).size.height * 0.05),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Text(
                        'Buy Book',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'default',
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isFetched = false;

  bool _isSubmit = false;

  bool _isLoading = false;
  double transactionAmount = 0.0;

  Future<void> submitTransaction(
      String TransID, String TransDate, String TransType) async {
    _isSubmit = false;
    if (_isSubmit) return;
    try {
      final apiService = await SubmitBookTransactionAPIService.create();

      final Map<String, dynamic>? dashboardData =
          await apiService.submitTransaction(
              transactionId: TransID,
              transactionDate: TransDate,
              transactionType: TransType,
              bookId: widget.bookId.toString(),
              transactionAmount: widget.bookPrice);
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
          await apiService.FetchApplicantInfo('');
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

      startPayment(context, Name, Email, Mobile);

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

  void startPayment(
      BuildContext context, String Name, String Email, String Mobile) async {
    String tranId = generateTransactionId();

    String bookPriceString = widget.bookPrice.replaceAll(
        RegExp(r'[^\d.]'), ''); // Removes all non-numeric characters
    transactionAmount = double.parse(bookPriceString);
    print(transactionAmount);

    Sslcommerz sslcommerz = Sslcommerz(
      initializer: SSLCommerzInitialization(
        multi_card_name: "visa,master,bkash,rocket,nagad",
        currency: SSLCurrencyType.BDT,
        product_category: "Exam Fee",
        sdkType: SSLCSdkType.TESTBOX,
        // Change to LIVE for production
        store_id: BookCard.storeId,
        store_passwd: BookCard.storePassword,
        total_amount: transactionAmount,
        tran_id: tranId,
      ),
    );

    // Add customer information
    sslcommerz.addCustomerInfoInitializer(
      customerInfoInitializer: SSLCCustomerInfoInitializer(
        customerState: "",
        customerName: Name,
        customerEmail: Email,
        customerAddress1: "",
        customerCity: "",
        customerPostCode: "",
        customerCountry: "Bangladesh",
        customerPhone: Mobile,
      ),
    );

    // Add non-physical goods product information (Exam Registration and Book Fee)
    sslcommerz.addProductInitializer(
      sslcProductInitializer:
          SSLCProductInitializer.WithNonPhysicalGoodsProfile(
        productName: "Book Fee",
        productCategory: "Education",
        nonPhysicalGoods: NonPhysicalGoods(
          productProfile: "Book Payment",
          nonPhysicalGoods: "Book Purchase",
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
        await submitTransaction(transactionId, transactionDate, transactionType)
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
        });

        // Optionally, show a snackbar for successful transactions
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

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
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:http/http.dart' as http;
import '../../../Data/Data Sources/API Service (Admit Card)/apiserviceAdmitCard.dart';
import '../../../Data/Data Sources/API Service (Fetch Applicant Info)/apiServiceFetchApplicantinfo.dart';
import '../../../Data/Data Sources/API Service (Payment)/apiServiceSubmitTransaction.dart';
import '../../../Data/Data Sources/API Service (Result)/apiserviceResult.dart';
import '../../Pages/Dashboard UI/dashboardUI.dart';
import '../paymentCard.dart';
import 'appilcationcard.dart';
import 'listTileDashboardApplication.dart';

class ApplicationCarousel extends StatefulWidget {
  final List<Widget> applicationWidgets;

  const ApplicationCarousel({Key? key, required this.applicationWidgets})
      : super(key: key);

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
                    ApplicationTemplate applicant =
                        widget.applicationWidgets[index] as ApplicationTemplate;
                    return ApplicationCard(
                      examName: applicant.name,
                      examineeID: applicant.ExamineeID,
                      examCatagories: applicant.Categories,
                      Payment: applicant.payment,
                      AdmitCard: applicant.admitcard,
                      Result: applicant.result,
                      onPaymentPressed: () {
                        fetchInfo(applicant.applicationID, applicant.bookFee,
                            applicant.examFee);
                      },
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
                    color: _currentApplicationPage == 0
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: _currentApplicationPage ==
                            widget.applicationWidgets.length - 1
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

  bool _isFetched = false;
  bool _isSubmit = false;

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

  Future<void> fetchInfo(var id, String bookFee, String examFee) async {
    print(id);
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
          await apiService.FetchApplicantInfo(id.toString());
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

      startPayment(context, id.toString(), Name, Email, Mobile, Address,
          PostCode, bookFee, examFee);

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
      BuildContext context,
      String id,
      String Name,
      String Email,
      String Mobile,
      String Address,
      String PostCode,
      String bookFee,
      String examFee) async {
    String tranId = generateTransactionId();

    final BookFee = double.parse(bookFee);
    final ExamFee = double.parse(examFee);
    final totalAmount = BookFee + ExamFee;

    List<String> parts = PostCode.split('-');
    String city = parts[0];
    String code = parts[1];

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
          customerState: city,
          customerName: Name,
          customerEmail: Email,
          customerAddress1: Address,
          customerCity: city,
          customerPostCode: code,
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
      String examRegistrationId = id;
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

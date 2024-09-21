import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sslcommerz/model/SSLCAdditionalInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCCustomerInfoInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCEMITransactionInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCShipmentInfoInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/model/sslproductinitilizer/General.dart';
import 'package:flutter_sslcommerz/model/sslproductinitilizer/NonPhysicalGoods.dart';
import 'package:flutter_sslcommerz/model/sslproductinitilizer/PhysicalGoods.dart';
import 'package:flutter_sslcommerz/model/sslproductinitilizer/SSLCProductInitializer.dart';
import 'package:flutter_sslcommerz/model/sslproductinitilizer/TelecomVertical.dart';
import 'package:flutter_sslcommerz/model/sslproductinitilizer/TravelVertical.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Fetch Applicant Info)/apiServiceFetchApplicantinfo.dart';
import '../../../Data/Data Sources/API Service (Payment)/apiServiceSubmitTransaction.dart';
import '../../Widgets/custombottomnavbar.dart';
import '../Dashboard UI/dashboardUI.dart';

/// A screen that displays the payment confirmation for an examinee.
///
/// This widget is responsible for showing the success message of a
/// registration submission and allowing the user to confirm their
/// payment via Bkash. It includes a form for entering the transaction
/// ID and a button to submit the payment information.
///
/// Parameters:
/// - [ExamineeID]: The unique identifier for the examinee.
class PaymentConfirmationUI extends StatefulWidget {
  final String ExamineeID;
  final String ExamRegID;
  final String price;
  final String city;

  const PaymentConfirmationUI(
      {Key? key,
      required this.ExamineeID,
      required this.ExamRegID,
      required this.price,
      required this.city})
      : super(key: key);

  @override
  State<PaymentConfirmationUI> createState() => _PaymentConfirmationUIState();
}

class _PaymentConfirmationUIState extends State<PaymentConfirmationUI>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TextEditingController _paymentConfirmationController =
      TextEditingController();
  bool buttonloading = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return InternetConnectionChecker(
      child: PopScope(
        canPop: false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.grey[100],
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: const Color.fromRGBO(0, 162, 222, 1),
            titleSpacing: 5,
            automaticallyImplyLeading: false,
            title: const Text(
              'Payment Confirmation',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'default',
              ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  color: Colors.grey[100],
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image(
                          image: AssetImage('Assets/Images/Success-Mark.png'),
                          height: 150,
                          width: 150,
                          alignment: Alignment.center,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          'Congratulations, Your Registration Successfully Submitted',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromRGBO(143, 150, 158, 1),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'default',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: Text(
                          'Your ID: ${widget.ExamineeID}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromRGBO(143, 150, 158, 1),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'default',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      Column(
                        children: [
                          Center(
                            child: Material(
                              elevation: 5,
                              borderRadius: BorderRadius.circular(5),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromRGBO(0, 162, 222, 1),
                                  fixedSize: Size(
                                      MediaQuery.of(context).size.width * 0.85,
                                      MediaQuery.of(context).size.height *
                                          0.08),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                onPressed: () {
                                  fetchInfo();
                                },
                                child: const Text('Click here for payment',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'default',
                                    )),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Material(
                              elevation: 5,
                              borderRadius: BorderRadius.circular(5),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromRGBO(0, 162, 222, 1),
                                  fixedSize: Size(
                                      MediaQuery.of(context).size.width * 0.85,
                                      MediaQuery.of(context).size.height *
                                          0.08),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DashboardUI(
                                                shouldRefresh: true,
                                              )),
                                      (route) => false);
                                },
                                child: const Text('Pay Later',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'default',
                                    )),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: CustomBottomNavBar(),
        ),
      ),
    );
  }

  bool _isFetched = false;
  bool _isSubmit = false;
  bool _isLoading = false;

  Future<void> submitTransaction(String RegID, String TransID, String TransDate,
      String TransType, String Amount) async {
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
              transactionAmount: Amount);
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
          await apiService.FetchApplicantInfo(widget.ExamRegID);
      if (dashboardData == null || dashboardData.isEmpty) {
        print(
            'No data available or error occurred while fetching dashboard data');
        return;
      }

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

  /* static const String storeId = "rajsh6554638e006b6";
  static const String storePassword = "rajsh6554638e006b6@ssl";*/
  static const String storeId = "mrtou66baeda11df08";
  static const String storePassword = "mrtou66baeda11df08@ssl";
  static const String apiUrl =
      "https://sandbox.sslcommerz.com/gwprocess/v3/api.php";
  static const String requestedUrl =
      "https://sandbox.sslcommerz.com/validator/api/validationserverAPI.php?val_id=\$val_id&store_id=\$store_id&store_passwd=\$store_passwd&v=1&format=json";

  void startPayment(BuildContext context, String Name, String Email,
      String Mobile, String Address, String PostCode) async {
    String tranId = generateTransactionId();

    List<String> parts = PostCode.split('-');
    String city = parts[0];
    String code = parts[1];

    Sslcommerz sslcommerz = Sslcommerz(
      initializer: SSLCommerzInitialization(
        currency: SSLCurrencyType.BDT,
        product_category: "Exam Fee",
        sdkType: SSLCSdkType.TESTBOX,
        store_id: storeId,
        store_passwd: storePassword,
        total_amount: double.parse(widget.price),
        tran_id: tranId,
      ),
    );

    // Add customer information
    sslcommerz.addCustomerInfoInitializer(
      customerInfoInitializer: SSLCCustomerInfoInitializer(
        customerState: widget.city ?? "Unknown",
        customerName: Name,
        customerEmail: Email,
        customerAddress1: Address,
        customerCity: city ?? "Unknown",
        customerPostCode: code ?? "Unknown",
        customerCountry: "Bangladesh",
        customerPhone: Mobile,
      ),
    );

    sslcommerz.addProductInitializer(
      sslcProductInitializer: SSLCProductInitializer(
        productName: "Exam Registration and Book Fee",
        productCategory: "Education",
        general: General(
          productProfile: "Online Exam and Book Payment",
          general: "Exam Registration Fee, Book Purchase",
        ),
      ),
    );

    sslcommerz.addEMITransactionInitializer(
      sslcemiTransactionInitializer: SSLCEMITransactionInitializer(
        emi_options: 0,
      ),
    );

    sslcommerz.addShipmentInfoInitializer(
      sslcShipmentInfoInitializer: SSLCShipmentInfoInitializer(
        shipmentMethod: "no",
        numOfItems: 0,
        shipmentDetails: ShipmentDetails(
          shipAddress1: "N/A",
          shipCity: "N/A",
          shipCountry: "N/A",
          shipName: "N/A",
          shipPostCode: "N/A",
        ),
      ),
    );

    sslcommerz.addProductInitializer(
        sslcProductInitializer:
        SSLCProductInitializer.WithNonPhysicalGoodsProfile(
            productName:  "N/A",
            productCategory:"N/A",
            nonPhysicalGoods:
            NonPhysicalGoods(productProfile: "N/A",
                nonPhysicalGoods:"N/A"
            )));

    sslcommerz.addProductInitializer(
        sslcProductInitializer:
        SSLCProductInitializer.WithTravelVerticalProfile(
            productName:"N/A",
            productCategory:"N/A",
            travelVertical:TravelVertical(
                productProfile: "N/A",
                hotelName: "N/A",
                lengthOfStay: "N/A",
                checkInTime: "N/A",
                hotelCity: "N/A"
            )));

    sslcommerz.addProductInitializer(
        sslcProductInitializer:
        SSLCProductInitializer.WithPhysicalGoodsProfile(
            productName: "N/A",
            productCategory: "N/A",
            physicalGoods: PhysicalGoods(
                productProfile: "N/A",
                physicalGoods: "N/A"
            )));

    sslcommerz.addProductInitializer(
        sslcProductInitializer:
        SSLCProductInitializer.WithTelecomVerticalProfile(
            productName: "N/A",
            productCategory: "N/A",
            telecomVertical: TelecomVertical(
                productProfile: "N/A",
                productType: "N/A",
                topUpNumber: "N/A",
                countryTopUp: "N/A"
            )));

    sslcommerz.addAdditionalInitializer(
      sslcAdditionalInitializer: SSLCAdditionalInitializer(
        valueA: "N/A",
        valueB: "N/A",
        valueC: "N/A",
        valueD: "N/A",
      ),
    );

    String snackbarContent = """
    Initializing SSLCommerz with:
    - Store ID: $storeId
    - Store Password: $storePassword
    - SDK Type: TESTBOX
    - Currency: BDT
    - Transaction ID: $tranId
    - Total Amount: ${widget.price}
    - Product Name: Exam Registration and Book Fee
    - Customer State: ${widget.city}
    - Customer Name: $Name
    - Customer Email: $Email
    - Customer Phone: $Mobile
    - Customer Address: $Address
    - Customer City: $city
    - Customer PostCode: $code
    - Customer Country: Bangladesh
  """;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(snackbarContent),
      duration: Duration(seconds: 5), // Show for 5 seconds
    ));

    try {
      var ini = sslcommerz.initializer.toString();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${ini}'), duration: Duration(seconds: 5)));
      var cus = sslcommerz.customerInfoInitializer.toString();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${cus}'), duration: Duration(seconds: 5)));
    var tans = sslcommerz.sslcemiTransactionInitializer.toString();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${tans}'), duration: Duration(seconds: 5)));
    var ship = sslcommerz.sslcShipmentInfoInitializer.toString();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${ship}'), duration: Duration(seconds: 5)));
    var prod = sslcommerz.sslcProductInitializer.toString();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${prod}'), duration: Duration(seconds: 5)));
    var add = sslcommerz.sslcAdditionalInitializer.toString();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${add}'), duration: Duration(seconds: 5)));
    var datas = await sslcommerz.toJson();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${datas}'), duration: Duration(seconds: 5)));
      var result = await sslcommerz.payNow();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${jsonEncode(result.toString())}'),
          duration: Duration(seconds: 5)));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${result.status}'), duration: Duration(seconds: 5)));
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
                transactionDate, transactionType, widget.price)
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

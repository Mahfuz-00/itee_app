import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
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

  const PaymentConfirmationUI(
      {Key? key,
      required this.ExamineeID,
      required this.ExamRegID,
      required this.price})
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

    Sslcommerz sslcommerz = Sslcommerz(
      initializer: SSLCommerzInitialization(
        multi_card_name: "visa,master,bkash,rocket,nagad",
        currency: SSLCurrencyType.BDT,
        product_category: "Exam Fee",
        sdkType: SSLCSdkType.TESTBOX,
        // Change to LIVE for production
        store_id: storeId,
        store_passwd: storePassword,
        total_amount: double.parse(widget.price),
        tran_id: tranId,
      ),
    );

    // Add customer information
    sslcommerz.addCustomerInfoInitializer(
      customerInfoInitializer: SSLCCustomerInfoInitializer(
        customerState: "",
        customerName: Name,
        customerEmail: Email,
        customerAddress1: Address,
        customerCity: "",
        customerPostCode: PostCode,
        customerCountry: "Bangladesh",
        customerPhone: Mobile,
      ),
    );

    // Add non-physical goods product information (Exam Registration and Book Fee)
    sslcommerz.addProductInitializer(
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

/*  void showPaymentModal(BuildContext context) {
    // Define the available payment methods with images
    List<Map<String, String>> paymentMethods = [
      {
        "name": "Visa",
        "image": "Assets/Images/Visa_logo.png",
        "type": "card",
      },
      {
        "name": "MasterCard",
        "image": "Assets/Images/MasterCard_logo.png",
        "type": "card",
      },
      {
        "name": "bKash",
        "image": "Assets/Images/bKash_logo.png",
        "type": "mobile",
      },
      {
        "name": "Rocket",
        "image": "Assets/Images/Rocket_Logo.png",
        "type": "mobile",
      },
      {
        "name": "Nagad",
        "image": "Assets/Images/Nagad_logo.png",
        "type": "mobile",
      },
    ];

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          height: 1000,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15,),
              Center(
                child: Text(
                  'Proceed with Exam Payment',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default'),
                ),
              ),
              SizedBox(height: 20),
              Text('Select Payment Method:',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'default')),
              SizedBox(height: 10),
              // Display payment method cards
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: paymentMethods.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        // Show different modal based on payment type
                        if (paymentMethods[index]["name"] == "bKash" ||
                            paymentMethods[index]["name"] == "Rocket" ||
                            paymentMethods[index]["name"] == "Nagad") {
                          showMobilePaymentModal(
                              context, paymentMethods[index]["name"]!, paymentMethods[index]["image"]!);
                        } else {
                          showCardPaymentModal(
                              context, paymentMethods[index]["name"]!, paymentMethods[index]["image"]!);
                        }
                      },
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                paymentMethods[index]["image"]!,
                                width: 70,
                                height: 70,
                              ),
                              SizedBox(height: 5),
                              Text(
                                paymentMethods[index]["name"]!,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'default'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showMobilePaymentModal(BuildContext context, String paymentMethod, String logo) {
    TextEditingController mobileController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    TextEditingController securityController = TextEditingController();

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          //height: 1000,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 15),
              Text('Mobile Payment: $paymentMethod',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w500)),
              SizedBox(height: 15,),
              Image.asset(logo, height: 100, width: 100),
              const SizedBox(height: 30),
              _buildTextField(
                  mobileController, 'Mobile Number', TextInputType.phone),
              const SizedBox(height: 10),
              _buildTextField(amountController, 'Amount', TextInputType.number),
              const SizedBox(height: 10),
              _buildTextField(
                  securityController, 'Security Code', TextInputType.number),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildPaymentButton('Confirm', () {
                    String mobileNumber = mobileController.text;
                    String amount = amountController.text;
                    print('Mobile Payment: $mobileNumber, Amount: $amount');
                    //Navigator.of(context).pop();
                  }),
                  const SizedBox(width: 10),
                  _buildPaymentButton(
                      'Cancel', () => Navigator.of(context).pop()),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void showCardPaymentModal(BuildContext context, String paymentMethod, String logo) {
    TextEditingController cardNumberController = TextEditingController();
    TextEditingController expiryDateController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController securitycodeController = TextEditingController();
    TextEditingController amountController = TextEditingController();

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
         // height: 1000,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 15),
              Text(
                'Card Payment: $paymentMethod',
                style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'default',
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 15),
              Image.asset(logo, height: 100, width: 100),
              SizedBox(height: 30),
              _buildTextField(cardNumberController, 'Card Number', TextInputType.number),
              SizedBox(height: 10),
              _buildTextField(expiryDateController, 'Expiry Date (MM/YY)', TextInputType.datetime),
              SizedBox(height: 10),
              _buildTextField(amountController, 'Amount', TextInputType.number),
              SizedBox(height: 10),
              _buildTextField(nameController, 'Name on Card', TextInputType.text),
              SizedBox(height: 10),
              _buildTextField(securitycodeController, 'CVV/CVC', TextInputType.number),
              const SizedBox(height: 10),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildPaymentButton('Confirm', () {
                    String cardNumber = cardNumberController.text;
                    String expiryDate = expiryDateController.text;
                    String amount = amountController.text;
                    print('Card Payment: $cardNumber, Expiry: $expiryDate, Amount: $amount');
                    Navigator.of(context).pop();
                  }),
                  SizedBox(width: 10),
                  _buildPaymentButton('Cancel', () => Navigator.of(context).pop()),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      TextInputType keyboardType) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(
        color: Color.fromRGBO(143, 150, 158, 1),
        fontSize: 16,
        fontWeight: FontWeight.bold,
        fontFamily: 'default',
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 16,
          fontFamily: 'default',
        ),
        border: OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      ),
    );
  }

  Widget _buildPaymentButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(0, 162, 222, 1),
        fixedSize: Size(MediaQuery.of(context).size.width * 0.40, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: Text(label,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'default')),
      onPressed: onPressed,
    );
  }

  String generateTransactionId() {
    const String chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final Random random = Random();
    String randomId = '';

    for (int i = 0; i < 10; i++) {
      randomId += chars[random.nextInt(chars.length)];
    }

    return 'tran_$randomId';
  }

  void startPayment(BuildContext context, String paymentMethod) async {
    String tranId = generateTransactionId();

    Sslcommerz sslcommerz = Sslcommerz(
      initializer: SSLCommerzInitialization(
        multi_card_name: "visa,master,bkash,rocket,nagad",
        currency: SSLCurrencyType.BDT,
        product_category: "Exam Fee",
        sdkType: SSLCSdkType.TESTBOX,
        // Change to LIVE for production
        store_id: "rajsh6554638e006b6",
        store_passwd: "rajsh6554638e006b6@ssl",
        total_amount: 1000.00,
        tran_id: tranId,
      ),
    );

    // Add customer information
    sslcommerz.addCustomerInfoInitializer(
      customerInfoInitializer: SSLCCustomerInfoInitializer(
        customerState: "Dhaka",
        customerName: "Student Name",
        customerEmail: "student_email@example.com",
        customerAddress1: "Student Address",
        customerCity: "Dhaka",
        customerPostCode: "1230",
        customerCountry: "Bangladesh",
        customerPhone: "student_phone_number",
      ),
    );

    // Add non-physical goods product information (Exam Fee)
    sslcommerz.addProductInitializer(
      sslcProductInitializer:
          SSLCProductInitializer.WithNonPhysicalGoodsProfile(
        productName: "Exam Registration Fee",
        productCategory: "Education",
        nonPhysicalGoods: NonPhysicalGoods(
          productProfile: "Online Exam Payment",
          nonPhysicalGoods: "Exam Registration Fee",
        ),
      ),
    );

    try {
      var result = await sslcommerz.payNow();
      print(result);
      */ /* Navigator.pop(context); // Close the modal bottom sheet
    if (result['status'] == 'SUCCESS') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Payment successful!'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Payment failed!'),
      ));
    }*/ /*
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Payment error: $e'),
      ));
    }
  }*/
}

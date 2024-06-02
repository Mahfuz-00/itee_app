
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:itee_exam_app/Connection%20Checker/internetconnectioncheck.dart';


import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../API Model and Service (Admit Card)/apiserviceAdmitCard.dart';
import '../API Model and Service (Center Selection)/apiserviceCenterSelection.dart';
import '../API Model and Service (Center Selection)/centerModels.dart';
import '../Template Models/dropdownfield.dart';

class AdmitCardDownload extends StatefulWidget {
  const AdmitCardDownload({super.key});

  @override
  State<AdmitCardDownload> createState() => _AdmitCardDownloadState();
}

class _AdmitCardDownloadState extends State<AdmitCardDownload> with SingleTickerProviderStateMixin{
  bool _isLoading = false;
  late final String name;
  bool isloaded = false;
  bool _pageLoading = true;
  bool _isFetched = false;
  bool _isFetchedPrint = false;
  List<Map<String, dynamic>> records = [];
  late String courseCategoryID = "";
  late String courseTypeID = "";
  late String link = "";
  String? selectedExamCategory;
  String? selectedExamType;
  bool isLoadingExamCategory = false;
  bool isLoadingExamTypes = false;
  List<ExamCategory> ExamCategories = [];
  List<ExamType> ExamTypes = [];
  late String _ExamCatagoriesID = '';
  late String _ExamTypeID = '';


  Future<void> fetchConnectionRequests() async {
    if (_isFetched) return;
    try {
      final apiService = await CenterAPIService.create();

      // Fetch dashboard data
      final Map<String, dynamic> dashboardData =
      await apiService.fetchCenterItems();
      if (dashboardData == null || dashboardData.isEmpty) {
        // No data available or an error occurred
        print(
            'No data available or error occurred while fetching dashboard data');
        return;
      }

      final Map<String, dynamic> records = dashboardData['records'];
      if (records == null || records.isEmpty) {
        // No records available
        print('No records available');
        return;
      }

      await handleRecords(records); // Handle each section separately

      setState(() {
        _isFetched = true;
      });
    } catch (e) {
      print('Error fetching connection requests: $e');
      _isFetched = true;
      // Handle error as needed
    }
  }

  Future<void> handleRecords(Map<String, dynamic> records) async {
    if (records.containsKey('exam_categories')) {
      final List<dynamic> examCategories = records['exam_categories'];
      await handleExamCategories(examCategories);
    }

    if (records.containsKey('exam_type')) {
      final List<dynamic> examTypes = records['exam_type'];
      await handleExamTypes(examTypes);
    }
  }

  Future<void> handleExamCategories(List<dynamic> examCategories) async {
    setState(() {
      isLoadingExamCategory = true;
    });
    List<ExamCategory> fetchedExamCategories = [];
    try {
      for (dynamic categoryData in examCategories) {
        ExamCategory category = ExamCategory.fromJson(categoryData);
        fetchedExamCategories.add(category);
        print('Exam Category Name: ${category.name}');
        print('Exam Category ID: ${category.id}');
        // Further processing if needed
      }
      print(fetchedExamCategories);
      setState(() {
        isLoadingExamCategory = false;
        ExamCategories = fetchedExamCategories;
      });
    } catch (e) {
      print('Error handling exam categories: $e');
      // Handle error
    }
  }

  Future<void> handleExamTypes(List<dynamic> examTypes) async {
    setState(() {
      isLoadingExamTypes = true;
    });
    List<ExamType> fetchedExamTypes = [];
    try {
      for (dynamic typeData in examTypes) {
        ExamType type = ExamType.fromJson(typeData);
        fetchedExamTypes.add(type);
        print('Exam Type Name: ${type.name}');
        print('Exam Type ID: ${type.id}');
        // Further processing if needed
      }
      setState(() {
        isLoadingExamTypes = false;
        ExamTypes = fetchedExamTypes;
      });
    } catch (e) {
      print('Error handling exam types: $e');
      // Handle error
    }
  }


  Future<void> GetAdmitCardLinkandPrint(String categoryId, String typeId) async {
    if (_isFetchedPrint) return;

    try {
      const snackBar = SnackBar(
        content: Text(
            'Processing, Please wait'),
      );
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(snackBar);
      final apiService = await AdmitCardAPIService.create();

      // Fetch dashboard data
      final Map<String, dynamic> dashboardData =
      await apiService.fetchAdmitCardItems(categoryId, typeId);
      if (dashboardData == null || dashboardData.isEmpty) {
        // No data available or an error occurred
        print(
            'No data available or error occurred while fetching dashboard data');
        return;
      }

      link = dashboardData['download'].toString();

      if(link != null)
      generatePDF(context, link);
      else {
        const snackBar = SnackBar(
          content: Text(
              'You did not Registered in this Exam'),
        );
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(snackBar);
      }

      // Set isLoading to true while fetching data
      setState(() {
        _isLoading = true;
      });

      // Simulate fetching data for 5 seconds
      await Future.delayed(Duration(seconds: 1));

      setState(() {
        _isFetchedPrint = true;
      });
    } catch (e) {
      print('Error fetching connection requests: $e');
      _isFetchedPrint = true;
      // Handle error as needed
    }
  }

  @override
  void initState() {
    super.initState();
    print('initState called');
    if (!_isFetched) {
      fetchConnectionRequests();
      //_isFetched = true; // Set _isFetched to true after the first call
    }
    Future.delayed(Duration(seconds: 4), () {
      setState(() {
        _pageLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return _pageLoading
        ? Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        // Show circular loading indicator while waiting
        child: CircularProgressIndicator(),
      ),
    )
        : InternetChecker(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(0, 162, 222, 1),
          titleSpacing: 5,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Colors.white,
              )),
          title: const Text(
            'Admit Card',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: 'default',
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              //height: screenHeight,
              color: Colors.grey[100],
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Congratulations, Your Payment is Completed, \n You can download your admit card',
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
                 /* ListView.builder(
                    shrinkWrap: true,
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      final AdmitCardItem = records[index];
                      return _buildDotPointItem( AdmitCardItem['name'],
                          AdmitCardItem['download']);
                    },
                  ),*/
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Select a Exam Catagory',
                            style: TextStyle(
                              color: Color.fromRGBO(143, 150, 158, 1),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'default',
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              width: screenWidth * 0.9,
                              height: screenHeight * 0.075,
                              padding: EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Stack(
                                children: [
                                  // Inside your build method or wherever appropriate
                                  DropdownFormField(
                                    hintText: 'Select Exam Category',
                                    dropdownItems:
                                    ExamCategories.map((category) => category.name)
                                        .toList(),
                                    initialValue: selectedExamCategory,
                                    onChanged: (newValue) {
                                      setState(() {
                                        // Reset other selected values if needed
                                        selectedExamCategory = newValue!;
                                        // Further logic if needed
                                      });
                                      if (newValue != null) {
                                        ExamCategory selectedCatagoriesObject =
                                        ExamCategories.firstWhere(
                                              (category) => category.name == newValue,
                                        );
                                        if (selectedCatagoriesObject != null) {
                                          //It Takes ID Int
                                          _ExamCatagoriesID =
                                              selectedCatagoriesObject.id.toString();
                                          print(_ExamCatagoriesID);
                                        }
                                      }
                                    },
                                  ),
                                  if (isLoadingExamCategory)
                                    Align(
                                      alignment: Alignment.center,
                                      child: CircularProgressIndicator(
                                        color: const Color.fromRGBO(25, 192, 122, 1),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Select a Exam Type',
                            style: TextStyle(
                              color: Color.fromRGBO(143, 150, 158, 1),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'default',
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: screenWidth * 0.9,
                              height: screenHeight * 0.075,
                              padding: EdgeInsets.only(left: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Stack(
                                children: [
                                  DropdownFormField(
                                    hintText: 'Select Exam Type',
                                    dropdownItems:
                                    ExamTypes.map((type) => type.name).toList(),
                                    initialValue: selectedExamType,
                                    onChanged: (newValue) {
                                      setState(() {
                                        // Reset other selected values if needed
                                        selectedExamType = newValue!;
                                        // Further logic if needed
                                      });
                                      if (newValue != null) {
                                        ExamType selectedTypeObject = ExamTypes.firstWhere(
                                              (type) => type.name == newValue,
                                          /*orElse: () => null,*/
                                        );
                                        if (selectedTypeObject != null) {
                                          //It Takes ID Int
                                          _ExamTypeID = selectedTypeObject.id.toString();
                                          print(_ExamTypeID);
                                        }
                                      }
                                    },
                                  ),
                                  if (isLoadingExamTypes)
                                    Align(
                                      alignment: Alignment.center,
                                      child: CircularProgressIndicator(
                                        color: const Color.fromRGBO(25, 192, 122, 1),
                                      ),
                                    ),
                                ],
                              ),

                              /*DropdownButtonFormField<String>(
                    value: selectedCourse,
                    items: selectedCourseType != null
                        ? courseOptions[selectedCourseType!]!
                            .map((String course) {
                            return DropdownMenuItem<String>(
                              value: course,
                              child: Text(
                                course,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  fontFamily: 'default',
                                ),
                              ),
                            );
                          }).toList()
                        : [],
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCourse = newValue;
                        selectedBatchNo = null;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Exam Type',
                      labelStyle: TextStyle(
                        color: Color.fromRGBO(143, 150, 158, 1),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'default',
                      ),
                      border: InputBorder.none,
                    ),
                  )*/
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  Center(
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(5),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(0, 162, 222, 1),
                          fixedSize: Size(MediaQuery.of(context).size.width* 0.85, MediaQuery.of(context).size.height * 0.08),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () {
                          GetAdmitCardLinkandPrint(_ExamCatagoriesID, _ExamTypeID);
                        },
                        child: const Text('Download',
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
              ),
            ),
          ),
        ),
      ),
    );
  }


  /*Widget _buildDotPointItem(String name, String link) {
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
                  // Change color to blue for links
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'default',
                  decoration:
                  TextDecoration.underline, // Add underline for links
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }*/

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
      // Handle any errors
      print('Error generating PDF: $e');
    }

  }

}

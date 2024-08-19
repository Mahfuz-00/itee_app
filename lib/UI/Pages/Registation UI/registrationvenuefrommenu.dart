import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Data/Data Sources/API Service (Center Selection)/apiserviceCenterSelection.dart';
import '../../../Data/Data Sources/API Service (Center Selection)/apiserviceFee.dart';
import '../../../Data/Data Sources/API Service (Center Selection)/apiservicebook.dart';
import '../../../Data/Data Sources/API Service (Center Selection)/apiservicetype.dart';
import '../../../Data/Models/centerModels.dart';
import '../../Widgets/LabelText.dart';
import '../../Widgets/dropdownfield.dart';
import '../B-Jet Details UI/B-jetDetailsUI.dart';
import '../Dashboard UI/dashboardUI.dart';
import '../ITEE Details UI/iteedetailsui.dart';
import '../ITEE Training Program Details UI/trainingprogramdetails.dart';
import 'registrationpersonalinfo.dart';

class RegistrationCenterFromMenu extends StatefulWidget {
  const RegistrationCenterFromMenu({super.key});

  @override
  State<RegistrationCenterFromMenu> createState() =>
      _RegistrationCenterFromMenuState();
}

class _RegistrationCenterFromMenuState extends State<RegistrationCenterFromMenu>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? selectedVenue;
  String? selectedExamCategory;
  String? selectedExamType;
  String? selectedBook;
  String? selectedTutionFee;

  bool isLoadingVenues = false;
  bool isLoadingExamCategory = false;
  bool isLoadingExamTypes = false;
  bool isLoadingBooks = false;
  List<Venue> Venues = [];
  List<ExamCategory> ExamCategories = [];
  List<ExamType> ExamTypes = [];
  List<Book> Books = [];

  late String _VenueID = '';
  late String _ExamCatagoriesID = '';
  late String _ExamTypeID = '';
  late String _BookID = '';
  late String _BookPrice = '';
  late int FeeID = 0;

  bool _isFetched = false;
  bool _isBookFetched = false;
  bool _pageLoading = true;
  bool _isLoading = false;
  bool isFetchFeeInvoked = false;
  bool _isFetchedType = false;

  Future<void> fetchConnectionRequests() async {
    if (_isFetched) return;
    setState(() {
      isLoadingExamTypes = true;
      isLoadingBooks = true;
      isLoadingExamCategory = true;
      isLoadingVenues = true;
    });
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

      // getBooks(selectedExamCategory.toString());

      final Map<String, dynamic> records = dashboardData['records'];
      if (records == null || records.isEmpty) {
        // No records available
        print('No records available');
        return;
      }

      await handleRecords(records);

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
    if (records.containsKey('venues')) {
      final List<dynamic> venues = records['venues'];
      await handleVenues(venues);
    }

    if (records.containsKey('exam_categories')) {
      final List<dynamic> examCategories = records['exam_categories'];
      await handleExamCategories(examCategories);
    }

/*
    if (records.containsKey('exam_type')) {
      final List<dynamic> examTypes = records['exam_type'];
      await handleExamTypes(examTypes);
    }
*/

    /*if (records.containsKey('books')) {
      final List<dynamic> books = records['books'];
      await handleBooks(books);
    }*/
  }

  Future<void> handleVenues(List<dynamic> venues) async {
    List<Venue> fetchedVenues = [];
    try {
      for (dynamic venueData in venues) {
        Venue venue = Venue.fromJson(venueData);
        fetchedVenues.add(venue);
        print('Venue Name: ${venue.name}');
        print('Venue ID: ${venue.id}');
        // Further processing if needed
      }
      setState(() {
        isLoadingVenues = false;
        Venues = fetchedVenues;
      });
    } catch (e) {
      print('Error handling venues: $e');
      // Handle error
    }
  }

  Future<void> handleExamCategories(List<dynamic> examCategories) async {
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

  Future<void> fetchType(String CatagoriesID) async {
    if (_isFetchedType) return; // Exit early if already fetched

    setState(() {
      isLoadingExamTypes = true;
    });

    try {
      print('Category ID: $CatagoriesID');

      if (CatagoriesID.isNotEmpty) {
        final apiService = await TypeAPIService.create();

        // Fetch types data
        final Map<String, dynamic> response = await apiService.fetchTypes(CatagoriesID);

        if (response == null || response.isEmpty) {
          print('No data available or an error occurred while fetching types');
          return;
        }

        final dynamic records = response['records']; // Could be a list or map

        if (records == null || records.isEmpty) {
          print('No records available');
          return;
        }

        // Handle the fetched books
        await handleExamTypes(records);

        // If records is a list, use an index to access elements
        if (records is List) {
          for (var record in records) {
            final String name = record['name'] as String;
            final int id = record['id'] as int;
            final String categoryID = record['category_id'];

            print('Type: $name');
            print('Type ID: $id');
            print('Category ID: $categoryID');
          }
        }
        // If records is a map, access elements directly
        else if (records is Map) {
          final String name = records['name'] as String;
          final int id = records['id'] as int;
          final int categoryID = records['category_id'] as int;

          print('Type: $name');
          print('Type ID: $id');
          print('Category ID: $categoryID');
        }

        setState(() {
          _isFetchedType = true; // Mark as fetched
        //  isFetchFeeInvoked = false; // Stop indicating loading
        });

      } else {
        print('Category ID is empty');
      }
    } catch (e) {
      print('Error fetching types: $e');
      setState(() {
        _isFetchedType = true; // Mark as fetched even on error
       // isFetchFeeInvoked = false; // Stop indicating loading
      });
    }
  }



  Future<void> handleExamTypes(List<dynamic> examTypes) async {
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

  late String examFee = '';
  bool _isFetchedFee = false;

  Future<void> fetchFee(String Catagories, String type, bool triggered) async {
    setState(() {
      _isFetchedFee = false;
    });
    print('Invoked');
    if (triggered == true &&
        (Catagories.isNotEmpty ?? false) &&
        (type.isNotEmpty ?? false)) {
      if (_isFetchedFee) return;
      try {
        final apiService = await FeeAPIService.create();

        final response = await apiService.fetchExamFee(Catagories, type);
        final fee = response['records']['fee'] as String;
        final id = response['records']['id'];

        setState(() {
          examFee = fee;
          isFetchFeeInvoked = false;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('Exam fee', examFee);
        await prefs.setInt('Exam Fee ID', id);

        FeeID = prefs.getInt('Exam Fee ID')!;

        _isFetchedFee = true;
      } catch (e) {
        print('Error fetching connection requests: $e');
        _isFetchedFee = true;
        // Handle error as needed
      }
    }
  }

  Future<void> handleBooks(List<dynamic> books) async {
    List<Book> fetchedBooks = [];
    try {
      for (dynamic bookData in books) {
        Book book = Book.fromJson(bookData);
        fetchedBooks.add(book);
        print('Book Name: ${book.name}');
        print('Book ID: ${book.id}');
        print('Book Price: ${book.bookprice}');
        // Further processing if needed
      }
      setState(() {
        // isLoadingBooks = false;
        Books = fetchedBooks;
      });
    } catch (e) {
      print('Error handling books: $e');
      // Handle error
    }
  }

  Future<void> getBooks(String Catagory) async {
    if (_isBookFetched) return;

    setState(() {
      isLoadingBooks = true;
    });

    try {
      final apiService = await BookAPIService.create();

      // Fetch books data
      final Map<String, dynamic> dashboardData =
          await apiService.fetchBooks(Catagory);
      if (dashboardData == null || dashboardData.isEmpty) {
        print(
            'No data available or an error occurred while fetching dashboard data');
        return;
      }

      final List<dynamic> records = dashboardData['records'];
      if (records == null || records.isEmpty) {
        print('No records available');
        return;
      }

      // Handle the fetched books
      await handleBooks(records);

      setState(() {
        _isBookFetched = true;
        isLoadingBooks = false;
      });
    } catch (e) {
      print('Error fetching books: $e');
      setState(() {
        _isBookFetched = true;
        isLoadingBooks = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchConnectionRequests();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
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
          'Registration Form',
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
          //height: screenHeight-80,
          color: Colors.grey[100],
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Register here to learn creative skill',
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
              LabeledTextWithAsterisk(
                text: 'Select a Venue',
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
                      DropdownFormField(
                        hintText: 'Select Venue',
                        dropdownItems:
                            Venues.map((venue) => venue.name).toList(),
                        initialValue: selectedVenue,
                        onChanged: (newValue) {
                          setState(() {
                            // Reset other selected values if needed
                            selectedVenue = newValue!;
                            // Further logic if needed
                          });
                          if (newValue != null) {
                            Venue selectedVenueObject = Venues.firstWhere(
                              (type) => type.name == newValue,
                            );
                            if (selectedVenueObject != null) {
                              //It Takes ID Int
                              _VenueID = selectedVenueObject.id.toString();
                              print(_VenueID);
                            }
                          }
                        },
                      ),
                      if (isLoadingVenues) ...[
                        Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            color: const Color.fromRGBO(0, 162, 222, 1),
                          ),
                        ),
                      ]
                    ],
                  ),
                  /*DropdownButtonFormField<String>(
                    value: selectedCenter,
                    items: courseTypeOptions.keys.map((String courseType) {
                      return DropdownMenuItem<String>(
                        value: courseType,
                        child: Text(
                          courseType,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'default',
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCenter = newValue;
                        //selectedCourseType = null;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Venue',
                      labelStyle: TextStyle(
                        color: Color.fromRGBO(143, 150, 158, 1),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'default',
                      ),
                      border: InputBorder.none,
                    ),
                  ),*/
                ),
              ),
              SizedBox(
                height: 15,
              ),
              LabeledTextWithAsterisk(
                text: 'Select a Exam Catagory',
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
                  //padding: EdgeInsets.only(left: 10),
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
                            isFetchFeeInvoked = true;
                            if (newValue != null) {
                              _isBookFetched = false;
                              getBooks(selectedExamCategory!);
                              ExamCategory selectedCategoriesObject =
                                  ExamCategories.firstWhere(
                                (category) => category.name == newValue,
                              );

                              if (selectedCategoriesObject != null) {
                                // It Takes ID Int
                                _ExamCatagoriesID =
                                    selectedCategoriesObject.id.toString();

                                fetchFee(_ExamCatagoriesID, _ExamTypeID,
                                    isFetchFeeInvoked);
                                _isFetchedType = false;
                                fetchType(_ExamCatagoriesID);

                                if (_ExamCatagoriesID != '' &&
                                    _ExamTypeID != '' &&
                                    _ExamCatagoriesID != null &&
                                    _ExamTypeID != null) {
                                  fetchFee(_ExamCatagoriesID, _ExamTypeID,
                                      isFetchFeeInvoked);
                                }
                                print(_ExamCatagoriesID);
                              }
                            }
                          });
                        },
                      ),
                      if (isLoadingExamCategory) ...[
                        Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            color: const Color.fromRGBO(0, 162, 222, 1),
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              LabeledTextWithAsterisk(
                text: 'Select a Exam Type',
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
                  //padding: EdgeInsets.only(left: 5),
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
                            isFetchFeeInvoked = true;
                            if (newValue != null) {
                              ExamType selectedTypeObject =
                                  ExamTypes.firstWhere(
                                (type) => type.name == newValue,
                                /*orElse: () => null,*/
                              );
                              if (selectedTypeObject != null) {
                                //It Takes ID Int
                                _ExamTypeID = selectedTypeObject.id.toString();
                                print(_ExamTypeID);

                                fetchFee(_ExamCatagoriesID, _ExamTypeID,
                                    isFetchFeeInvoked);
                                if (_ExamCatagoriesID != '' &&
                                    _ExamTypeID != '' &&
                                    _ExamCatagoriesID != null &&
                                    _ExamTypeID != null) {
                                  fetchFee(_ExamCatagoriesID, _ExamTypeID,
                                      isFetchFeeInvoked);
                                }
                              }
                            }
                          });
                        },
                      ),
                      if (isLoadingExamTypes) ...[
                        Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            color: const Color.fromRGBO(0, 162, 222, 1),
                          ),
                        ),
                      ]
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
              SizedBox(
                height: 15,
              ),
              LabeledTextWithAsterisk(
                text: 'Exam Free',
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
                  //padding: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Container(
                    padding: EdgeInsets.only(top: 15, left: 15),
                    child: Text(
                      examFee != null && examFee.isNotEmpty
                          ? '$examFee TK'
                          : 'Exam Fee',
                      style: TextStyle(
                        color: Color.fromRGBO(143, 150, 158, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'default',
                      ),
                    ),
                  ),
                ),
              ),
              /*  if (selectedExamCategory != null && selectedExamType != null) ...[
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Exam Fee : ',
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
                Container(
                  width: screenWidth * 0.9,
                  height: screenHeight * 0.075,
                  child: TextFormField(
                    readOnly: true,
                    style: const TextStyle(
                      color: Color.fromRGBO(143, 150, 158, 1),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default',
                    ),
                    decoration: InputDecoration(
                      labelText: 'Exam Fee',
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'default',
                      ),
                      alignLabelWithHint: true,
                      //contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: screenHeight * 0.15),
                      border: const OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                  ),
                ),
              ],*/
              SizedBox(
                height: 15,
              ),
              Text(
                'Select a Book (If you want to)',
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
                      DropdownFormField(
                        hintText: 'Select Book',
                        dropdownItems: Books.map((book) => book.name).toList(),
                        initialValue: selectedBook,
                        onChanged: (newValue) {
                          setState(() {
                            // Reset other selected values if needed
                            selectedBook = newValue!;
                            // Further logic if needed
                          });
                          if (newValue != null) {
                            Book selectedBookObject = Books.firstWhere(
                              (type) => type.name == newValue,
                            );
                            if (selectedBookObject != null) {
                              //It Takes ID Int
                              _BookID = selectedBookObject.id.toString();
                              _BookPrice =
                                  selectedBookObject.bookprice.toString();
                              print(_BookID);
                            }
                          }
                        },
                      ),
                      if (isLoadingBooks)
                        Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            color: const Color.fromRGBO(0, 162, 222, 1),
                          ),
                        ),
                    ],
                  ),
                  /*DropdownButtonFormField<String>(
                    value: selectedBatchNo,
                    items: selectedCourse != null
                        ? batchNoOptions[selectedCourse!]!.map((String batch) {
                            return DropdownMenuItem<String>(
                              value: batch,
                              child: Text(
                                batch,
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
                        selectedBatchNo = newValue;
                        //selectedTutionFee = null;
                        selectedTutionFee =
                            tutionFeeOptions[selectedBatchNo!]?.first;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Book Name',
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
              SizedBox(
                height: 15,
              ),
              Text(
                'Book Price : ',
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
                  padding: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Container(
                    padding: EdgeInsets.only(top: 15, left: 15),
                    child: Text(
                      _BookPrice != null && _BookPrice.isNotEmpty
                          ? 'TK $_BookPrice/-'
                          : 'Book Price',
                      style: TextStyle(
                        color: Color.fromRGBO(143, 150, 158, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'default',
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Center(
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(5),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(0, 162, 222, 1),
                      fixedSize: Size(MediaQuery.of(context).size.width * 0.9,
                          MediaQuery.of(context).size.height * 0.08),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () async {
                      print(_VenueID);
                      print(_ExamCatagoriesID);
                      print(_ExamTypeID);
                      print(_BookID);
                      print(examFee);
                      if (_VenueID != null &&
                          _ExamCatagoriesID != null &&
                          _ExamTypeID != null &&
                          _VenueID != '' &&
                          _ExamCatagoriesID != '' &&
                          _ExamTypeID != '' &&
                          examFee != null &&
                          examFee != null) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setString('Venue', _VenueID);
                        await prefs.setString(
                            'Exam Catagories', _ExamCatagoriesID);
                        await prefs.setString('Exam Type', _ExamTypeID);
                        await prefs.setString('Exam Fee', examFee);
                        // await prefs.setInt('Exam Fee ID', _);
                        await prefs.setString('Book', _BookID);
                        await prefs.setString('BookPrice', _BookPrice);
                        await prefs.setString(
                            'Venue_Name', selectedVenue.toString());
                        await prefs.setString('Exam Catagories_Name',
                            selectedExamCategory.toString());
                        await prefs.setString(
                            'Exam Type_Name', selectedExamType.toString());
                        //await prefs.setString('Exam Fee ID', examFee);
                        await prefs.setString(
                            'Book_Name', selectedBook.toString());

                        print('Catagory : $_ExamCatagoriesID');
                        print('Type : $_ExamTypeID');
                        print('Book: $_BookID');
                        print('Fee ID : ${examFee}');

                        final String? VenueSaved =
                            await prefs.getString('Venue');
                        final String? CatagoresSaved =
                            await prefs.getString('Exam Catagories');
                        final String? TypeSaved =
                            await prefs.getString('Exam Type');
                        final String? BookSaved = await prefs.getString('Book');
                        final String? BookPriceSaved =
                            await prefs.getString('BookPrice');
                        final String? FeeSaved =
                            await prefs.getString('Exam Fee');

                        print('Fee ID : $FeeID');
                        print(VenueSaved);
                        print('Exam Catagory : $CatagoresSaved');
                        print('Exam Type : $TypeSaved');
                        print(BookSaved);
                        print(FeeSaved);
                        print(BookPriceSaved);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const RegistrationPersonalInformation()));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Fill up all required fields'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                    child: const Text('Next',
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
      )),
      bottomNavigationBar: Container(
        height: screenHeight * 0.08,
        color: const Color.fromRGBO(0, 162, 222, 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Dashboard(
                              shouldRefresh: true,
                            )));
              },
              child: Container(
                width: screenWidth / 5,
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.home,
                      size: 30,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Home',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: 'default',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ITEEDetails()));
              },
              child: Container(
                width: screenWidth / 5,
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 30,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'ITEE',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: 'default',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BJetDetails()));
              },
              child: Container(
                width: screenWidth / 5,
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Image(
                      image: AssetImage('Assets/Images/Bjet-Small.png'),
                      height: 30,
                      width: 50,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'B-Jet',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: 'default',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ITEETrainingProgramDetails()));
              },
              child: Container(
                width: screenWidth / 5,
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Image(
                      image: AssetImage('Assets/Images/ITEE-Small.png'),
                      height: 30,
                      width: 60,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Training',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: 'default',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                showPhoneNumberDialog(context);
              },
              child: Container(
                width: screenWidth / 5,
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.phone,
                      size: 30,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Contact',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: 'default',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showPhoneNumberDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Select a Number to Call',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromRGBO(0, 162, 222, 1),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',
                    fontSize: 22,
                  ),
                ),
              ),
              Divider()
            ],
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                phoneNumberTile(context, '0255006847'),
                Divider(),
                phoneNumberTile(context, '028181032'),
                Divider(),
                phoneNumberTile(context, '028181033'),
                Divider(),
                phoneNumberTile(context, '+8801857321122'),
                Divider(),
              ],
            ),
          ),
          actions: [
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromRGBO(0, 162, 222, 1)),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default',
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget phoneNumberTile(BuildContext context, String phoneNumber) {
    return ListTile(
      title: Text(
        phoneNumber,
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'default',
        ),
      ),
      trailing: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(0, 162, 222, 1),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: IconButton(
          icon: Icon(
            Icons.call,
            color: Colors.white,
          ),
          onPressed: () async {
            try {
              await FlutterPhoneDirectCaller.callNumber(phoneNumber);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Calling $phoneNumber...')),
              );
            } catch (e) {
              print('Error: $e');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to make the call: $e')),
              );
            }
          },
        ),
      ),
    );
  }

  _callNumber() async {
    const number = '+8801857321122'; //set the number here
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
  }

  // Function to make a phone call
  Future<void> _makePhoneCall(BuildContext context, String url) async {
    print('Attempting to launch: $url');

    if (await canLaunch(url)) {
      print('Launching: $url');
      await launch(url);
    } else {
      print('Could not launch $url');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not Call $url')),
      );
    }
  }
}

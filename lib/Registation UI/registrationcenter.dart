import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../API Model and Service (Center Selection)/apiserviceCenterSelection.dart';
import '../API Model and Service (Center Selection)/apiserviceFee.dart';
import '../API Model and Service (Center Selection)/centerModels.dart';
import '../Dashboard UI/dashboardUI.dart';
import '../Login UI/loginUI.dart';
import '../Template Models/dropdownfield.dart';
import 'registrationpersonalinfo.dart';

class RegistrationCenter extends StatefulWidget {
  const RegistrationCenter({super.key});

  @override
  State<RegistrationCenter> createState() => _RegistrationCenterState();
}

class _RegistrationCenterState extends State<RegistrationCenter>
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

  bool _isFetched = false;
  bool _pageLoading = true;
  bool _isLoading = false;

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
    if (records.containsKey('venues')) {
      final List<dynamic> venues = records['venues'];
      await handleVenues(venues);
    }

    if (records.containsKey('exam_categories')) {
      final List<dynamic> examCategories = records['exam_categories'];
      await handleExamCategories(examCategories);
    }

    if (records.containsKey('exam_type')) {
      final List<dynamic> examTypes = records['exam_type'];
      await handleExamTypes(examTypes);
    }

    if (records.containsKey('books')) {
      final List<dynamic> books = records['books'];
      await handleBooks(books);
    }
  }

  Future<void> handleVenues(List<dynamic> venues) async {
    setState(() {
      isLoadingVenues = true;
    });
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

  Future<void> handleBooks(List<dynamic> books) async {
    setState(() {
      isLoadingBooks = true;
    });
    List<Book> fetchedBooks = [];
    try {
      for (dynamic bookData in books) {
        Book book = Book.fromJson(bookData);
        fetchedBooks.add(book);
        print('Book Name: ${book.name}');
        print('Book ID: ${book.id}');
        // Further processing if needed
      }
      setState(() {
        isLoadingBooks = false;
        Books = fetchedBooks;
      });
    } catch (e) {
      print('Error handling books: $e');
      // Handle error
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
              Text(
                'Select a Venue',
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
                      if (isLoadingVenues)
                        Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            color: const Color.fromRGBO(25, 192, 122, 1),
                          ),
                        ),
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
                              print(_BookID);
                            }
                          }
                        },
                      ),
                      if (isLoadingBooks)
                        Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            color: const Color.fromRGBO(25, 192, 122, 1),
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
              /* Text(
                'Book Fee : ',
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
                  height: screenHeight * 0.085,
                  padding: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    child: Text(
                      selectedTutionFee ?? 'Book Fee',
                      style: TextStyle(
                        color: Color.fromRGBO(143, 150, 158, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'default',
                      ),
                    ),
                  ),
                ),
              ),*/
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
                      if (_VenueID != null &&
                          _ExamCatagoriesID != null &&
                          _ExamTypeID != null && _VenueID != '' &&
                          _ExamCatagoriesID != '' &&
                          _ExamTypeID != '') {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setString('Venue', _VenueID);
                        await prefs.setString(
                            'Exam Catagories', _ExamCatagoriesID);
                        await prefs.setString('Exam Type', _ExamTypeID);
                        await prefs.setString('Book', _BookID);
                        await prefs.setString('Venue_Name', selectedVenue.toString());
                        await prefs.setString(
                            'Exam Catagories_Name', selectedExamCategory.toString());
                        await prefs.setString('Exam Type_Name', selectedExamType.toString());
                        await prefs.setString('Book_Name', selectedBook.toString());

                        late final String? VenueSaved;
                        late final String? CatagoresSaved;
                        late final String? TypeSaved;
                        late final String? BookSaved;

                        VenueSaved = await prefs.getString('Venue');
                        CatagoresSaved = await prefs.getString('Exam Catagories');
                        TypeSaved = await prefs.getString('Exam Type');
                        BookSaved = await prefs.getString('Book');
                        print(VenueSaved);
                        print(CatagoresSaved);
                        print(TypeSaved);
                        print(BookSaved);


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
    );
  }
}

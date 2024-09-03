import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Data/Data Sources/API Service (Center Selection)/apiserviceCenterSelection.dart';
import '../../../Data/Data Sources/API Service (Center Selection)/apiserviceFee.dart';
import '../../../Data/Data Sources/API Service (Center Selection)/apiservicebook.dart';
import '../../../Data/Data Sources/API Service (Center Selection)/apiservicetype.dart';
import '../../../Data/Models/examModels.dart';
import '../../Bloc/first_page_cubit.dart';
import '../../Widgets/LabelText.dart';
import '../../Widgets/custombottomnavbar.dart';
import '../../Widgets/dropdownfield.dart';
import 'registrationpersonalinfo.dart';

/// A widget that represents the registration center form accessed from the menu.
///
/// This widget allows users to register for exams by displaying
/// a registration form that collects necessary information such as:
/// - Selected exam category
/// - User personal details
/// - Venue details
///
/// Actions included:
/// - Submitting the registration form
/// - Validating input fields
///
/// This widget integrates with the `ExamRegistrationCubit` to manage
/// state and handle submissions.
class RegistrationCenterUIFromMenu extends StatefulWidget {
  const RegistrationCenterUIFromMenu({super.key});

  @override
  State<RegistrationCenterUIFromMenu> createState() =>
      _RegistrationCenterUIFromMenuState();
}

class _RegistrationCenterUIFromMenuState extends State<RegistrationCenterUIFromMenu>
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
      final Map<String, dynamic> dashboardData =
          await apiService.fetchCenterItems();
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
      await handleRecords(records);

      setState(() {
        _isFetched = true;
      });
    } catch (e) {
      print('Error fetching connection requests: $e');
      _isFetched = true;
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
  }

  Future<void> handleVenues(List<dynamic> venues) async {
    List<Venue> fetchedVenues = [];
    try {
      for (dynamic venueData in venues) {
        Venue venue = Venue.fromJson(venueData);
        fetchedVenues.add(venue);
        print('Venue Name: ${venue.name}');
        print('Venue ID: ${venue.id}');
      }
      setState(() {
        isLoadingVenues = false;
        Venues = fetchedVenues;
      });
    } catch (e) {
      print('Error handling venues: $e');
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
      }
      print(fetchedExamCategories);
      setState(() {
        isLoadingExamCategory = false;
        ExamCategories = fetchedExamCategories;
      });
    } catch (e) {
      print('Error handling exam categories: $e');
    }
  }

  Future<void> fetchType(String CatagoriesID) async {
    if (_isFetchedType) return;

    setState(() {
      isLoadingExamTypes = true;
    });

    try {
      print('Category ID: $CatagoriesID');

      if (CatagoriesID.isNotEmpty) {
        final apiService = await TypeAPIService.create();

        final Map<String, dynamic> response =
            await apiService.fetchTypes(CatagoriesID);

        if (response == null || response.isEmpty) {
          print('No data available or an error occurred while fetching types');
          return;
        }
        final dynamic records = response['records'];

        if (records == null || records.isEmpty) {
          print('No records available');
          return;
        }

        await handleExamTypes(records);

        if (records is List) {
          for (var record in records) {
            final String name = record['name'] as String;
            final int id = record['id'] as int;
            final String categoryID = record['category_id'];

            print('Type: $name');
            print('Type ID: $id');
            print('Category ID: $categoryID');
          }
        } else if (records is Map) {
          final String name = records['name'] as String;
          final int id = records['id'] as int;
          final int categoryID = records['category_id'] as int;

          print('Type: $name');
          print('Type ID: $id');
          print('Category ID: $categoryID');
        }

        setState(() {
          _isFetchedType = true;
        });
      } else {
        print('Category ID is empty');
      }
    } catch (e) {
      print('Error fetching types: $e');
      setState(() {
        _isFetchedType = true;
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
      }
      setState(() {
        isLoadingExamTypes = false;
        ExamTypes = fetchedExamTypes;
      });
    } catch (e) {
      print('Error handling exam types: $e');
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

        FeeID = id;

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
      }
      setState(() {
        Books = fetchedBooks;
      });
    } catch (e) {
      print('Error handling books: $e');
    }
  }

  Future<void> getBooks(String Catagory) async {
    if (_isBookFetched) return;
    setState(() {
      isLoadingBooks = true;
    });

    try {
      final apiService = await BookAPIService.create();

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

  List<Book> _selectedBooks = [];

  double _calculateTotalPrice() {
    return _selectedBooks.fold(0.0, (sum, book) {
      double price = double.tryParse(book.bookprice) ?? 0.0;
      return sum + price;
    });
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
          color: Colors.grey[100],
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Fill the Form for Exam Registration',
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
                            selectedVenue = newValue!;
                          });
                          if (newValue != null) {
                            Venue selectedVenueObject = Venues.firstWhere(
                              (type) => type.name == newValue,
                            );
                            if (selectedVenueObject != null) {
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
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Stack(
                    children: [
                      DropdownFormField(
                        hintText: 'Select Exam Category',
                        dropdownItems:
                            ExamCategories.map((category) => category.name)
                                .toList(),
                        initialValue: selectedExamCategory,
                        onChanged: (newValue) {
                          setState(() {
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
                            selectedExamType = newValue!;
                            isFetchFeeInvoked = true;
                            if (newValue != null) {
                              ExamType selectedTypeObject =
                                  ExamTypes.firstWhere(
                                (type) => type.name == newValue,
                              );
                              if (selectedTypeObject != null) {
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
              SizedBox(
                height: 15,
              ),
              if (selectedExamCategory != null) ...[
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
              ],
              Column(
                children: [
                  ...Books.map((book) {
                    return CheckboxListTile(
                      title: Text(
                        book.name,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'default'),
                      ),
                      value: _selectedBooks.contains(book),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _selectedBooks.add(book);
                          } else {
                            _selectedBooks.remove(book);
                          }
                        });
                        print(
                            'Selected Books: ${_selectedBooks.map((b) => b.name).join(', ')}');
                      },
                    );
                  }).toList(),
                  SizedBox(height: 20),
                  if (_selectedBooks.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selected Books:',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'default'),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ..._selectedBooks.map((book) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              '${book.name} - \$${(double.tryParse(book.bookprice) ?? 0.0).toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'default'),
                            ),
                          );
                        }).toList(),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Total Price: \$${_calculateTotalPrice().toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'default'),
                        ),
                      ],
                    ),
                ],
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
                      if (fieldChecker()) {
                        final firstPageCubit = context.read<FirstPageCubit>();

                        double totalBookPrice = _calculateTotalPrice();

                        firstPageCubit.updateFirstPageData(
                          venueID: _VenueID,
                          venueName: selectedVenue.toString(),
                          courseCategoryID: _ExamCatagoriesID,
                          courseCategoryName: selectedExamCategory.toString(),
                          courseTypeID: _ExamTypeID,
                          courseTypeName: selectedExamType.toString(),
                          examFee: examFee,
                          examFeeID: FeeID,
                          selectedBookNames:
                              _selectedBooks.map((book) => book.name).toList(),
                          selectedBookIDs: _selectedBooks
                              .map((book) => book.id.toString())
                              .toList(),
                          bookPrice: totalBookPrice,
                        );

                        print(
                            'Venue ID from State: ${firstPageCubit.state.venueID}');
                        print(
                            'Venue Name from State: ${firstPageCubit.state.venueName}');
                        print(
                            'Category ID from State: ${firstPageCubit.state.courseCategoryID}');
                        print(
                            'Category Name from State: ${firstPageCubit.state.courseCategoryName}');
                        print(
                            'Type ID from State: ${firstPageCubit.state.courseTypeID}');
                        print(
                            'Type Name from State: ${firstPageCubit.state.courseTypeName}');
                        print(
                            'Exam Fee from State: ${firstPageCubit.state.examFee}');
                        print(
                            'Exam Fee ID from State: ${firstPageCubit.state.examFeeID}');
                        print(
                            'Selected Book Names from State: ${firstPageCubit.state.selectedBookNames}');
                        print(
                            'Selected Book IDs from State: ${firstPageCubit.state.selectedBookIDs}');
                        print(
                            'Total Book Price from State: ${firstPageCubit.state.bookPrice}');

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const RegistrationPersonalInformationUI()));
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
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  bool fieldChecker() {
    return _VenueID != null &&
        _ExamCatagoriesID != null &&
        _ExamTypeID != null &&
        _VenueID != '' &&
        _ExamCatagoriesID != '' &&
        _ExamTypeID != '' &&
        examFee != null &&
        examFee != null;
  }
}

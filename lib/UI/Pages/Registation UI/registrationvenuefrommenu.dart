import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Data/Data Sources/API Service (Center Selection)/apiserviceCenterSelection.dart';
import '../../../Data/Data Sources/API Service (Center Selection)/apiserviceFee.dart';
import '../../../Data/Data Sources/API Service (Center Selection)/apiservicebook.dart';
import '../../../Data/Data Sources/API Service (Center Selection)/apiservicetype.dart';
import '../../../Data/Models/examModels.dart';
import '../../Bloc/first_page_cubit.dart';
import '../../Widgets/LabelText.dart';
import '../../Widgets/custombottomnavbar.dart';
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

        // Fetch types data
        final Map<String, dynamic> response = await apiService.fetchTypes(CatagoriesID);

        if (response == null || response.isEmpty) {
          print('No data available or an error occurred while fetching types');
          return;
        }

        final dynamic records = response['records'];

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
        // Further processing if needed
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

  List<Book> _selectedBooks = [];

  double _calculateTotalPrice() {
    return _selectedBooks.fold(0.0, (sum, book) {
      double price = double.tryParse(book.bookprice) ??
          0.0; // Convert to double, default to 0.0 if null
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
              SizedBox(
                height: 15,
              ),
              if(selectedExamCategory != null) ...[
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
                  // Checkbox list for selecting books
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
                  // Add some space before the selected books section

                  // Section to show selected books and their prices
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
                        SizedBox(height: 10,),
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
                        SizedBox(height: 10,),
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
                      if (_VenueID != null &&
                          _ExamCatagoriesID != null &&
                          _ExamTypeID != null &&
                          _VenueID != '' &&
                          _ExamCatagoriesID != '' &&
                          _ExamTypeID != '' &&
                          examFee != null &&
                          examFee != null) {
                  /*      final prefs = await SharedPreferences.getInstance();
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
                        await prefs.setString(
                            'Book_Name', selectedBook.toString());

                        List<String> selectedBookIds =
                        _selectedBooks.map((book) => book.id.toString()).toList();
                        List<String> selectedBookNames =
                        _selectedBooks.map((book) => book.name).toList();
                        double totalPrice = _calculateTotalPrice();

                        await prefs.setStringList('selectedBookIds', selectedBookIds);
                        await prefs.setStringList('selectedBookNames', selectedBookNames);
                        await prefs.setDouble('totalPrice', totalPrice);

                        print('Selected Book IDs saved: $selectedBookIds');
                        print('Selected Book Names saved: $selectedBookNames');
                        print('Total Price saved: $totalPrice');

                        print('Fee ID : $FeeID');
                        print(VenueSaved);
                        print('Exam Catagory : $CatagoresSaved');
                        print('Exam Type : $TypeSaved');
                        print(BookSaved);
                        print(FeeSaved);
                        print(BookPriceSaved);*/

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
                          selectedBookNames: _selectedBooks.map((book) => book.name).toList(),
                          selectedBookIDs: _selectedBooks.map((book) => book.id.toString()).toList(),
                          bookPrice: totalBookPrice,
                        );

                        print('Venue ID from State: ${firstPageCubit.state.venueID}');
                        print('Venue Name from State: ${firstPageCubit.state.venueName}');
                        print('Category ID from State: ${firstPageCubit.state.courseCategoryID}');
                        print('Category Name from State: ${firstPageCubit.state.courseCategoryName}');
                        print('Type ID from State: ${firstPageCubit.state.courseTypeID}');
                        print('Type Name from State: ${firstPageCubit.state.courseTypeName}');
                        print('Exam Fee from State: ${firstPageCubit.state.examFee}');
                        print('Exam Fee ID from State: ${firstPageCubit.state.examFeeID}');
                        print('Selected Book Names from State: ${firstPageCubit.state.selectedBookNames}');
                        print('Selected Book IDs from State: ${firstPageCubit.state.selectedBookIDs}');
                        print('Total Book Price from State: ${firstPageCubit.state.bookPrice}');

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
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}

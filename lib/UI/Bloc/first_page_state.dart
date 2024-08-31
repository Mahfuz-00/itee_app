part of 'first_page_cubit.dart';

/// Represents the state of the first page in the application.
class FirstPageState extends Equatable {
  final String venueID;
  final String venueName;
  final String courseCategoryID;
  final String courseCategoryName;
  final String courseTypeID;
  final String courseTypeName;
  final String examFee;
  final int examFeeID;
  final List<String> selectedBookNames;
  final List<String> selectedBookIDs;
  final double bookPrice;

  const FirstPageState({
    required this.venueID,
    required this.venueName,
    required this.courseCategoryID,
    required this.courseCategoryName,
    required this.courseTypeID,
    required this.courseTypeName,
    required this.examFee,
    required this.examFeeID,
    required this.selectedBookNames,
    required this.selectedBookIDs,
    required this.bookPrice,
  });

  FirstPageState copyWith({
    String? venueID,
    String? venueName,
    String? courseCategoryID,
    String? courseCategoryName,
    String? courseTypeID,
    String? courseTypeName,
    String? examFee,
    int? examFeeID,
    List<String>? selectedBookNames,
    List<String>? selectedBookIDs,
    double? bookPrice,
  }) {
    return FirstPageState(
      venueID: venueID ?? this.venueID,
      venueName: venueName ?? this.venueName,
      courseCategoryID: courseCategoryID ?? this.courseCategoryID,
      courseCategoryName: courseCategoryName ?? this.courseCategoryName,
      courseTypeID: courseTypeID ?? this.courseTypeID,
      courseTypeName: courseTypeName ?? this.courseTypeName,
      examFee: examFee ?? this.examFee,
      examFeeID: examFeeID ?? this.examFeeID,
      selectedBookNames: selectedBookNames ?? this.selectedBookNames,
      selectedBookIDs: selectedBookIDs ?? this.selectedBookIDs,
      bookPrice: bookPrice ?? this.bookPrice,
    );
  }

  @override
  List<Object> get props => [
    venueID,
    venueName,
    courseCategoryID,
    courseCategoryName,
    courseTypeID,
    courseTypeName,
    examFee,
    examFeeID,
    selectedBookNames,
    selectedBookIDs,
    bookPrice,
  ];
}




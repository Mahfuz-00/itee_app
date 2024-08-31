part of 'combine_page_cubit.dart';

/// Represents the combined state of data from multiple Cubits.
class CombinedDataState extends Equatable {
  final String imagePath;
  final String venueName;
  final String courseCategory;
  final String courseType;
  final String examFee;
  final int examFeeID;
  final List<String>? savedBookNames;
  final double? bookPrice;
  final String venueID;
  final String courseCategoryID;
  final String courseTypeID;
  final List<String>? bookID;
  final String fullName;
  final String email;
  final String mobileNumber;
  final String dateOfBirth;
  final String gender;
  final String linkedin;
  final String address;
  final String postCode;
  final String occupation;
  final String educationQualification;
  final String subject;
  final String discipline;
  final String passingYear;
  final String institute;
  final String result;
  final String passingID;

  const CombinedDataState({
    this.imagePath = '',
    this.venueName = '',
    this.courseCategory = '',
    this.courseType = '',
    this.examFee = '',
    this.examFeeID = 0,
    this.savedBookNames,
    this.bookPrice = 0.0,
    this.venueID = '',
    this.courseCategoryID = '',
    this.courseTypeID = '',
    this.bookID,
    this.fullName = '',
    this.email = '',
    this.mobileNumber = '',
    this.dateOfBirth = '',
    this.gender = '',
    this.linkedin = '',
    this.address = '',
    this.postCode = '',
    this.occupation = '',
    this.educationQualification = '',
    this.subject = '',
    this.discipline = '',
    this.passingYear = '',
    this.institute = '',
    this.result = '',
    this.passingID = '',
  });

  @override
  List<Object> get props => [
    imagePath,
    venueName,
    courseCategory,
    courseType,
    examFee,
    examFeeID,
    savedBookNames ?? [],
    bookPrice ?? 0.0,
    venueID,
    courseCategoryID,
    courseTypeID,
    bookID ?? [],
    fullName,
    email,
    mobileNumber,
    dateOfBirth,
    gender,
    linkedin,
    address,
    postCode,
    occupation,
    educationQualification,
    subject,
    discipline,
    passingYear,
    institute,
    result,
    passingID,
  ];
}

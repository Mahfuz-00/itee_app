import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'first_page_cubit.dart';
import 'second_page_cubit.dart';
import 'third_page_cubit.dart';

part 'combine_page_state.dart';

/// A Cubit class that combines data from three separate Cubits
/// ([FirstPageCubit], [SecondPageCubit], and [ThirdPageCubit])
/// to provide a unified view of the data for the application.
/// Resets the combined data and the individual page states.
class CombinedDataCubit extends Cubit<CombinedDataState> {
  final FirstPageCubit firstPageCubit;
  final SecondPageCubit secondPageCubit;
  final ThirdPageCubit thirdPageCubit;

  CombinedDataCubit({
    required this.firstPageCubit,
    required this.secondPageCubit,
    required this.thirdPageCubit,
  }) : super(const CombinedDataState());

  void getCombinedData() {
    final firstState = firstPageCubit.state;
    final secondState = secondPageCubit.state;
    final thirdState = thirdPageCubit.state;

    emit(CombinedDataState(
      imagePath: secondState.imagePath,
      venueName: firstState.venueName,
      courseCategory: firstState.courseCategoryName,
      courseType: firstState.courseTypeName,
      examFee: firstState.examFee,
      examFeeID: firstState.examFeeID,
      savedBookNames: firstState.selectedBookNames,
      bookPrice: firstState.bookPrice,
      venueID: firstState.venueID,
      courseCategoryID: firstState.courseCategoryID,
      courseTypeID: firstState.courseTypeID,
      bookID: firstState.selectedBookIDs,
      fullName: secondState.fullName,
      email: secondState.email,
      mobileNumber: secondState.phone,
      dateOfBirth: secondState.dateOfBirth,
      gender: secondState.gender,
      linkedin: secondState.linkedin,
      address: secondState.address,
      postCode: secondState.postCode,
      occupation: secondState.occupation,
      educationQualification: thirdState.qualification,
      subject: thirdState.subjectName,
      discipline: thirdState.disipline,
      passingYear: thirdState.passingYear,
      institute: thirdState.institute,
      result: thirdState.result,
      passingID: thirdState.passingId,
    ));

    printCombinedData();
  }

  void printCombinedData() {
    final data = state;

    print('Image Path: ${data.imagePath}');
    print('Venue Name: ${data.venueName}');
    print('Course Category: ${data.courseCategory}');
    print('Course Type: ${data.courseType}');
    print('Exam Fee: ${data.examFee}');
    print('Exam Fee ID: ${data.examFeeID}');
    print('Saved Book Names: ${data.savedBookNames}');
    print('Book Price: ${data.bookPrice}');
    print('Venue ID: ${data.venueID}');
    print('Course Category ID: ${data.courseCategoryID}');
    print('Course Type ID: ${data.courseTypeID}');
    print('Book IDs: ${data.bookID}');
    print('Full Name: ${data.fullName}');
    print('Email: ${data.email}');
    print('Mobile Number: ${data.mobileNumber}');
    print('Date of Birth: ${data.dateOfBirth}');
    print('Gender: ${data.gender}');
    print('LinkedIn: ${data.linkedin}');
    print('Address: ${data.address}');
    print('Post Code: ${data.postCode}');
    print('Occupation: ${data.occupation}');
    print('Education Qualification: ${data.educationQualification}');
    print('Subject: ${data.subject}');
    print('Passing Year: ${data.passingYear}');
    print('Institute: ${data.institute}');
    print('Result: ${data.result}');
    print('Passing ID: ${data.passingID}');
  }

  void resetData() {
    firstPageCubit.reset();
    secondPageCubit.reset();
    thirdPageCubit.reset();

    emit(const CombinedDataState());
    print('Combine Data Reset');
  }
}

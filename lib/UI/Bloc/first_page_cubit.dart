import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'first_page_state.dart';

/// Represents the state of the first page in the exam registration.
class FirstPageCubit extends Cubit<FirstPageState> {
  FirstPageCubit()
      : super(const FirstPageState(
    venueID: '',
    venueName: '',
    courseCategoryID: '',
    courseCategoryName: '',
    courseTypeID: '',
    courseTypeName: '',
    examFee: '',
    examFeeID: 0,
    selectedBookNames: [],
    selectedBookIDs: [],
    bookPrice: 0.0,
  ));

  void updateFirstPageData({
    required String venueID,
    required String venueName,
    required String courseCategoryID,
    required String courseCategoryName,
    required String courseTypeID,
    required String courseTypeName,
    required String examFee,
    required int examFeeID,
    required List<String> selectedBookNames,
    required List<String> selectedBookIDs,
    required double bookPrice,
  }) {
    emit(state.copyWith(
      venueID: venueID,
      venueName: venueName,
      courseCategoryID: courseCategoryID,
      courseCategoryName: courseCategoryName,
      courseTypeID: courseTypeID,
      courseTypeName: courseTypeName,
      examFee: examFee,
      examFeeID: examFeeID,
      selectedBookNames: selectedBookNames,
      selectedBookIDs: selectedBookIDs,
      bookPrice: bookPrice,
    ));
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'third_page_state.dart';

/// Represents the state of the third page in the exam registration process.
///
/// Initializes the state with default values for [qualification], [subjectName],
/// [disipline], [passingYear], [institute], [result], and [passingId].
/// Updates the state with new data for the third page.
/// Resets page states.
class ThirdPageCubit extends Cubit<ThirdPageState> {
  ThirdPageCubit()
      : super(const ThirdPageState(
    qualification: '',
    subjectName: '',
    disipline: '',
    passingYear: '',
    institute: '',
    result: '',
    passingId: '',
  ));

  void updateQualificationInfo({
    required String qualification,
    required String subjectName,
    required String  disipline,
    required String passingYear,
    required String institute,
    required String result,
    required String passingId,
  }) {
    emit(state.copyWith(
      qualification: qualification,
      subjectName: subjectName,
      disipline:  disipline,
      passingYear: passingYear,
      institute: institute,
      result: result,
      passingId: passingId,
    ));
  }

  void reset() {
    emit(ThirdPageState(
      qualification: '',
      subjectName: '',
      disipline: '',
      passingYear: '',
      institute: '',
      result: '',
      passingId: '',
    ));
    print('Third Page Data Reset');
  }
}

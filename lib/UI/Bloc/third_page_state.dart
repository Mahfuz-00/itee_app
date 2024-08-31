part of 'third_page_cubit.dart';

/// Represents the state of the third page in the application.
class ThirdPageState extends Equatable {
  final String qualification;
  final String subjectName;
  final String disipline;
  final String passingYear;
  final String institute;
  final String result;
  final String passingId;

  const ThirdPageState({
    required this.qualification,
    required this.subjectName,
    required this.disipline,
    required this.passingYear,
    required this.institute,
    required this.result,
    required this.passingId,
  });

  ThirdPageState copyWith({
    String? qualification,
    String? subjectName,
    String? disipline,
    String? passingYear,
    String? institute,
    String? result,
    String? passingId,
  }) {
    return ThirdPageState(
      qualification: qualification ?? this.qualification,
      subjectName: subjectName ?? this.subjectName,
      disipline: disipline ?? this.disipline,
      passingYear: passingYear ?? this.passingYear,
      institute: institute ?? this.institute,
      result: result ?? this.result,
      passingId: passingId ?? this.passingId,
    );
  }

  @override
  List<Object> get props => [
    qualification,
    subjectName,
    passingYear,
    institute,
    result,
    passingId,
  ];
}

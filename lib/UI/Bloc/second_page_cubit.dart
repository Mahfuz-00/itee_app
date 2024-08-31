import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'second_page_state.dart';

/// Represents the state of the second page in the exam registration.
class SecondPageCubit extends Cubit<SecondPageState> {
  SecondPageCubit()
      : super(const SecondPageState(
    fullName: '',
    email: '',
    phone: '',
    dateOfBirth: '',
    gender: '',
    linkedin: '',
    address: '',
    postCode: '',
    occupation: '',
    imagePath: '',
  ));

  void updateUserInfo({
    required String fullName,
    required String email,
    required String phone,
    required String dateOfBirth,
    required String gender,
    required String linkedin,
    required String address,
    required String postCode,
    required String occupation,
    required String imagePath,
  }) {
    emit(state.copyWith(
      fullName: fullName,
      email: email,
      phone: phone,
      dateOfBirth: dateOfBirth,
      gender: gender,
      linkedin: linkedin,
      address: address,
      postCode: postCode,
      occupation: occupation,
      imagePath: imagePath,
    ));
  }
}

part of 'second_page_cubit.dart';

/// Represents the state of the second page in the application.
///
/// Contains information about the user's [fullName], [email], [phone],
/// [dateOfBirth], [gender], [linkedin], [address], [postCode],
/// [occupation], and [imagePath].
class SecondPageState extends Equatable {
  final String fullName;
  final String email;
  final String phone;
  final String dateOfBirth;
  final String gender;
  final String linkedin;
  final String address;
  final String city;
  final String postCode;
  final String occupation;
  final String imagePath;

  const SecondPageState({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.dateOfBirth,
    required this.gender,
    required this.linkedin,
    required this.address,
    required this.city,
    required this.postCode,
    required this.occupation,
    required this.imagePath,
  });

  SecondPageState copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? dateOfBirth,
    String? gender,
    String? linkedin,
    String? address,
    String? city,
    String? postCode,
    String? occupation,
    String? imagePath,
  }) {
    return SecondPageState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      linkedin: linkedin ?? this.linkedin,
      address: address ?? this.address,
      city: city ?? this.city,
      postCode: postCode ?? this.postCode,
      occupation: occupation ?? this.occupation,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  @override
  List<Object> get props => [
    fullName,
    email,
    phone,
    dateOfBirth,
    gender,
    linkedin,
    address,
    city,
    postCode,
    occupation,
    imagePath,
  ];
}

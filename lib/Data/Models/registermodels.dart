/// Represents the response model from the registration API call.
///
/// This class encapsulates the response data returned after a user
/// attempts to register an account.
///
/// ### Properties:
/// - [message]: A string containing a message regarding the registration status.
/// - [status]: A string indicating the status of the registration.
class RegisterResponseModel {
  String message;
  String status;

  RegisterResponseModel({required this.message, required this.status});

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(message: json['message'], status: '');
  }
}


/// Represents the request model for the registration API call.
///
/// This class contains the necessary information required to register a new user.
///
/// ### Properties:
/// - [fullName]: A string representing the user's full name.
/// - [email]: A string representing the user's email address.
/// - [phone]: A string representing the user's phone number.
/// - [occupation]: A string representing the user's occupation.
/// - [linkedin]: A string representing the user's LinkedIn profile URL.
/// - [password]: A string representing the user's chosen password.
/// - [confirmPassword]: A string for confirming the user's password.
class RegisterRequestmodel {
  late String fullName;
  late String email;
  late String phone;
  late String occupation;
  late String linkedin;
  late String password;
  late String confirmPassword;

  RegisterRequestmodel({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.occupation,
    required this.linkedin,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJSON() {
    Map<String, dynamic> map = {
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'occupation': occupation,
      'LinkedIn': linkedin,
      'password': password,
      'password_confirmation': confirmPassword,
    };
    return map;
  }
}
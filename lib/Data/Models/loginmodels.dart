/// Represents the response model from the login API call.
///
/// This class encapsulates the data returned after a successful login attempt,
/// including the authentication token, any error messages, and the type of user.
///
/// ### Properties:
/// - [token]: A string representing the authentication token returned by the API.
/// - [error]: A string containing any error message from the login attempt.
/// - [userType]: A string indicating the type of user.
class LoginResponseModel {
  late final String token;
  late final String error;
  late final String userType;

  LoginResponseModel({this.token = "", this.error = "", this.userType = ""});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json["token"] ?? "",
      error: json["error"] ?? "",
      userType: json["userType"] ?? "",
    );
  }
}

/// Represents the request model for the login API call.
///
/// This class encapsulates the data required to initiate a login request,
/// including the user's email and password.
///
/// ### Properties:
/// - [Email]: A string representing the user's email address.
/// - [Password]: A string representing the user's password.
class LoginRequestmodel {
  late String Email;
  late String Password;

  LoginRequestmodel({
    required this.Email,
    required this.Password
  });

  Map<String, dynamic> toJSON() {
    Map<String, dynamic> map = {
      'email': Email,
      'password': Password
    };

    return map;
  }
}

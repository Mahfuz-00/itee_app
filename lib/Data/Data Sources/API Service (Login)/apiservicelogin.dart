import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../Models/loginmodels.dart';

/// A service class for handling **User Authentication** functionalities,
/// specifically for user login.
///
/// This class provides a method to log in a user by making a POST request
/// to the designated API endpoint with the user's credentials.
///
/// ### Key Actions:
/// - **login(LoginRequestmodel loginRequestModel)**: Sends a POST request
///   to the login endpoint with the user's credentials in JSON format.
///   It expects a `LoginRequestmodel` object, which is converted to JSON
///   using its `toJSON()` method.
///
///   - **Parameters**:
///     - `loginRequestModel`: The model containing user credentials
///       (e.g., email and password).
///
///   - **Returns**: A `LoginResponseModel` object if the login is
///     successful, or `null` if the request fails.
///
///   - **Throws**: An exception if the login fails or if an error occurs
///     during the request, providing relevant error messages.
class LoginAPIService {
  Future<LoginResponseModel?> login(LoginRequestmodel loginRequestModel) async {
    try {
      String url = "https://bcc.touchandsolve.com/api/login";

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(loginRequestModel.toJSON()),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return LoginResponseModel.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to login: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error occurred while logging in: $e');
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;

/// A service class for handling the **Create New Password** API requests.
///
/// This class provides a method to create a new password by sending
/// a POST request to the designated API endpoint.
///
/// ### Key Variables:
/// - `url`: The URL for the API endpoint that handles password resets.
/// - `authToken`: A placeholder for the authentication token (not used in this class).
///
/// ### Key Actions:
/// - **create()**: A factory method to instantiate the service.
/// - **NewPassword(String email, String password, String confirmPassword)**: Sends a
///   POST request to create a new password. It constructs the request body, handles
///   the response, and returns the message from the response. It also handles
///   exceptions that may occur during the request.
class CreateNewPasswordAPIService{
  final String url = 'https://bcc.touchandsolve.com/api/forget/password';
  late final String authToken;

  CreateNewPasswordAPIService._();

  static Future<CreateNewPasswordAPIService> create() async {
    var apiService = CreateNewPasswordAPIService._();
    return apiService;
  }

  Future<String> NewPassword(String email, String password, String confirmPassword) async {
    print(email);
    final Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> requestBody = {
      'email': email,
      'new_password': password,
      'password_confirmation': confirmPassword,
    };

    final String requestBodyJson = jsonEncode(requestBody);

    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: requestBodyJson,
      );

      if (response.statusCode == 200) {
        print('New Password Created successfully.');
        print('Response body: ${response.body}');
        var jsonResponse = jsonDecode(response.body);
        var message = jsonResponse['message'];
        return message;
      } else {
        print('Failed to create new password. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        var jsonResponse = jsonDecode(response.body);
        var message = jsonResponse['message'];
        return message;
      }

    } catch (e) {
      print('Error creating new password: $e');
      return 'Error creating new password';
    }
  }
}

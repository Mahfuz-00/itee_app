import 'dart:convert';
import 'package:http/http.dart' as http;

class APIServiceCreateNewPassword{
  final String url = 'https://bcc.touchandsolve.com/api/forget/password';
  late final String authToken;

  APIServiceCreateNewPassword._();

  static Future<APIServiceCreateNewPassword> create() async {
    var apiService = APIServiceCreateNewPassword._();
    return apiService;
  }




  Future<String> NewPassword(String email, String password, String confirmPassword) async {
    print(email);
    final Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    // Create the request body
    final Map<String, dynamic> requestBody = {
      'email': email,
      'new_password': password,
      'password_confirmation': confirmPassword,
    };

    // Encode the request body as JSON
    final String requestBodyJson = jsonEncode(requestBody);

    try {
      // Make the POST request
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: requestBodyJson,
      );

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Handle the response here, if needed
        print('New Password Created successfully.');
        print('Response body: ${response.body}');
        var jsonResponse = jsonDecode(response.body);
        var message = jsonResponse['message'];
        return message;
      } else {
        // Handle other status codes here
        print('Failed to create new password. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        var jsonResponse = jsonDecode(response.body);
        var message = jsonResponse['message'];
        return message;
      }

    } catch (e) {
      // Handle any exceptions that occur during the request
      print('Error creating new password: $e');
      return 'Error creating new password';
    }
  }
}

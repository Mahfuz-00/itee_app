import 'dart:convert';
import 'package:http/http.dart' as http;

/// A service class for handling the **Forgot Password** functionality.
///
/// This class provides a method to send a One-Time Password (OTP) to
/// the user's email for password recovery by making a POST request
/// to the designated API endpoint.
///
/// ### Key Variables:
/// - `url`: The URL for the API endpoint that handles sending the OTP.
/// - `authToken`: A placeholder for the authentication token (not used in this class).
///
/// ### Key Actions:
/// - **create()**: A factory method to instantiate the service.
/// - **sendForgotPasswordOTP(String email)**: Sends a POST request to send
///   an OTP to the specified email address. It constructs the request body,
///   handles the response, and returns the message from the response. It also
///   handles exceptions that may occur during the request.
class ForgotPasswordAPIService{
  final String url = 'https://bcc.touchandsolve.com/api/send/forget/password/otp';
  late final String authToken;

  ForgotPasswordAPIService();
  ForgotPasswordAPIService._();

  static Future<ForgotPasswordAPIService> create() async {
    var apiService = ForgotPasswordAPIService._();
    return apiService;
  }

  Future<String> sendForgotPasswordOTP(String email) async {
    print(email);
    final Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> requestBody = {
      'email': email,
    };

    final String requestBodyJson = jsonEncode(requestBody);

    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: requestBodyJson,
      );

      if (response.statusCode == 200) {
        print('Forgot password OTP sent successfully.');
        print('Response body: ${response.body}');
        var jsonResponse = jsonDecode(response.body);
        var message = jsonResponse['message'];
        return message;
      } else {
        print('Failed to send forgot password OTP. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        var jsonResponse = jsonDecode(response.body);
        var message = jsonResponse['message'];
        return message;
      }

    } catch (e) {
      print('Error sending forgot password OTP: $e');
      return 'Error sending forgot password OTP';
    }
  }
}

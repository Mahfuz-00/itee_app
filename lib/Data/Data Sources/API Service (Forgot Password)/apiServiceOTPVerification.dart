import 'dart:convert';
import 'package:http/http.dart' as http;

/// A service class for handling **OTP Verification** functionality.
///
/// This class provides a method to verify a One-Time Password (OTP) sent
/// to the user's email by making a POST request to the designated API endpoint.
///
/// ### Key Variables:
/// - `url`: The URL for the API endpoint that handles OTP verification.
/// - `authToken`: A placeholder for the authentication token (not used in this class).
///
/// ### Key Actions:
/// - **create()**: A factory method to instantiate the service.
/// - **OTPVerification(String email, String OTP)**: Sends a POST request
///   to verify the provided OTP for the specified email address. It constructs
///   the request body, handles the response, and returns the message from the
///   response. It also handles exceptions that may occur during the request.
class OTPVerificationAPIService{
  final String url = 'https://bcc.touchandsolve.com/api/verify/otp';
  late final String authToken;

  OTPVerificationAPIService._();

  static Future<OTPVerificationAPIService> create() async {
    var apiService = OTPVerificationAPIService._();
    return apiService;
  }

  Future<String> OTPVerification(String email, String OTP) async {
    print(email);
    final Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> requestBody = {
      'email': email,
      'otp': OTP,
    };

    final String requestBodyJson = jsonEncode(requestBody);

    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: requestBodyJson,
      );

      if (response.statusCode == 200) {
        print('OTP Invoked.');
        print('Response body: ${response.body}');
        var jsonResponse = jsonDecode(response.body);
        var message = jsonResponse['message'];
        return message;
      } else {
        print('Failed to send OTP. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        var jsonResponse = jsonDecode(response.body);
        var message = jsonResponse['message'];
        return message;
      }

    } catch (e) {
      print('Error sending OTP: $e');
      return 'Error sending OTP';
    }
  }
}

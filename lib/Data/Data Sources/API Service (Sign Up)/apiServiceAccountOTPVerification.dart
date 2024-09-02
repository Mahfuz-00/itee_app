import 'dart:convert';
import 'package:http/http.dart' as http;

/// A service class for managing **Account OTP Verification** functionalities.
///
/// This class provides methods to handle OTP verification for account registration.
///
/// ### Key Actions:
/// - **AccountOTPVerification(String email, String OTP)**:
///   Sends an OTP for verification to the specified email.
///
///   - **Parameters**:
///     - [email]: The email address of the user.
///     - [OTP]: The OTP sent to the user for verification.
///   - **Returns**:
///     A [String] message indicating the result of the OTP verification.
///
///   - **Throws**:
///     An exception if an error occurs during the request, providing
///     relevant error messages.
class APIServiceAccountOTPVerification{
  final String url = 'https://bcc.touchandsolve.com/api/registration/confirm_otp';
  late final String authToken;

  APIServiceAccountOTPVerification._();

  static Future<APIServiceAccountOTPVerification> create() async {
    var apiService = APIServiceAccountOTPVerification._();
    return apiService;
  }

  Future<String> AccountOTPVerification(String email, String OTP) async {
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

import 'dart:convert';
import 'package:http/http.dart' as http;

class APIServiceOTPVerification{
  final String url = 'https://bcc.touchandsolve.com/api/verify/otp';
  late final String authToken;

  APIServiceOTPVerification._();

  static Future<APIServiceOTPVerification> create() async {
    var apiService = APIServiceOTPVerification._();
    return apiService;
  }



  Future<String> OTPVerification(String email, String OTP) async {
    print(email);
    final Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    // Create the request body
    final Map<String, dynamic> requestBody = {
      'email': email,
      'otp': OTP,
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
        print('OTP Invoked.');
        print('Response body: ${response.body}');
        var jsonResponse = jsonDecode(response.body);
        var message = jsonResponse['message'];
        return message;
      } else {
        // Handle other status codes here
        print('Failed to send OTP. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        var jsonResponse = jsonDecode(response.body);
        var message = jsonResponse['message'];
        return message;
      }

    } catch (e) {
      // Handle any exceptions that occur during the request
      print('Error sending OTP: $e');
      return 'Error sending OTP';
    }
  }
}

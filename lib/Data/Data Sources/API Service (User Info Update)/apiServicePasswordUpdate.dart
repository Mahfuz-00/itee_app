import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// A service class for updating the user's password through the API.
///
/// This class manages the process of updating the user's password,
/// requiring the current password, a new password, and a confirmation
/// of the new password. The class utilizes an authentication token
/// stored in shared preferences to authorize the request.
///
/// ### Key Actions:
/// - **updatePassword**:
///   Updates the user's password by sending a JSON-formatted POST request
///   to the password update endpoint.
///
///   - **Parameters**:
///     - [currentPassword]: A [String] representing the user's current password.
///     - [newPassword]: A [String] representing the new password to set.
///     - [passwordConfirmation]: A [String] confirming the new password.
///
///   - **Returns**:
///     A [String] containing the server's response message if the request
///     is successful.
///
///   - **Throws**:
///     An exception if the authentication token is empty, if the request
///     fails, or if the server returns an error response, providing relevant
///     error messages.
class PasswordUpdateAPIService {
  String baseURL = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  PasswordUpdateAPIService._();

  static Future<PasswordUpdateAPIService> create() async {
    var apiService = PasswordUpdateAPIService._();
    await apiService._loadAuthToken();
    print('triggered API');
    return apiService;
  }

  Future<void> _loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('token') ?? '';
    print('Load Token');
    print(prefs.getString('token'));
  }

  Future<String> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String passwordConfirmation,
  }) async {
    final String token = await authToken;
    print('Authen:: $authToken');
    try {
      if (token.isEmpty) {
        await _loadAuthToken();
        throw Exception('Authentication token is empty.');
      }

      print('Current $currentPassword');
      print('New $newPassword');
      print('Confirm $passwordConfirmation');

      final requestBody = jsonEncode({
        'current_password': currentPassword,
        'new_password': newPassword,
        'password_confirmation': passwordConfirmation,
      });

      print('Request Body: $requestBody'); 
      print('Auth: $authToken');


      final response = await http.post(
        Uri.parse('$baseURL/update/password'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        print('password');
        // Request successful, parse response data if needed
        final responseData = jsonDecode(response.body);
        print(response.body);
        final responseMessage = responseData['message'];
        print(responseMessage);
        return responseMessage;
      } else {
        print(response.statusCode);
        print(response.body);
        final responseData = jsonDecode(response.body);
        final responseError = responseData['errors'];
        print(responseError);
        final List<dynamic> responseMessageList = responseError['current_password'];
        final String responseMessage = responseMessageList.join(', ');
        print(responseMessage);
        print(response.request);
        return responseMessage.toString();
      }
    } catch (e) {
      throw Exception('Failed to update Password: $e');
    }
  }
}

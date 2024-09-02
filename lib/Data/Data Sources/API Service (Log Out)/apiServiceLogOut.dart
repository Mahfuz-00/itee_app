import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// A service class for handling **User Logout** functionality.
///
/// This class provides a method to log out the user by making a request to
/// the designated API endpoint. It handles authentication tokens stored in
/// shared preferences to authorize the logout request.
///
/// ### Key Variables:
/// - `URL`: The base URL for the API endpoint.
/// - `authToken`: A placeholder for the authentication token used for
///   authorization when making requests.
///
/// ### Key Actions:
/// - **create()**: A factory method to instantiate the service and load
///   the authentication token.
/// - **_loadAuthToken()**: Loads the authentication token from shared
///   preferences.
/// - **signOut()**: Sends a GET request to the sign-out endpoint. It checks
///   if the authentication token is available and handles the response,
///   returning a boolean indicating whether the sign-out was successful.
///   If an exception occurs during the request, it attempts a POST request
///   to the sign-out endpoint instead, and handles the response accordingly.
class LogOutApiService {
  static const String URL = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  LogOutApiService._();

  static Future<LogOutApiService> create() async {
    var apiService = LogOutApiService._();
    await apiService._loadAuthToken();
    print('triggered API');
    return apiService;
  }

  Future<void> _loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('token') ?? '';
    print('Load Token');
    print(authToken);
  }

  Future<bool> signOut() async {
    print(authToken);
    try {
      if (authToken.isEmpty) {
        print(authToken);
        await _loadAuthToken();
        throw Exception('Authentication token is empty.');
      }

      final response = await http.get(
        Uri.parse('$URL/sign/out'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken'
        },
      );

      if (response.statusCode == 200) {
        print(response.body);
        print('Sign out successful');
        return true;
      } else {
        print(response.body);
        print('Failed to sign out: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      final response = await http.post(
          Uri.parse('$URL/sign/out'),
          headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken'
          },
      );
      print(response.body);
      print('Exception during sign out: $e');
      return false;
    }
  }
}

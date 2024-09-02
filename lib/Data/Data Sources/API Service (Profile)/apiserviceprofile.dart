import 'dart:convert';
import 'package:http/http.dart' as http;

/// A service class for handling **User Profile Management** functionalities,
/// specifically for fetching user profile data from the API.
///
/// This class provides methods to manage authentication and retrieve
/// the user's profile information.
///
/// ### Key Actions:
/// - **fetchUserProfile(String authToken)**:
///   Sends a GET request to retrieve the user's profile based on the
///   provided [authToken].
///
///   - **Parameters**:
///     - [authToken]: A [String] representing the user's authentication token.
///
///   - **Returns**:
///     A [Map<String, dynamic>] representing the user's profile information,
///     or throws an exception if the request fails.
///
///   - **Throws**:
///     An exception if the [authToken] is empty or if an error occurs during
///     the request, providing relevant error messages.
class APIProfileService {
  final String URL = 'https://bcc.touchandsolve.com/api';

  Future<Map<String, dynamic>> fetchUserProfile(String authToken) async {
    print('Authen: $authToken');
    try{
        if (authToken.isEmpty) {
          throw Exception('Authentication token is empty.');
        }


      final response = await http.get(
        Uri.parse('$URL/user/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );
        print(response.statusCode);

      print(response.body);
      if (response.statusCode == 200) {
        print('Profile Loaded successfully.');
        Map<String, dynamic> userProfile = json.decode(response.body);
        print(response.body);
        return userProfile['records'];
      } else {
        print('Failed to load Profile. Status code: ${response.statusCode}');
        throw Exception('Failed to load Profile.');
      }
    } catch(e){
      print('Error sending profile request: $e');
      throw Exception('Error sending profile request');
    }
  }
}

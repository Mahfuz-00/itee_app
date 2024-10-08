import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// A service class for handling **Personal Information Management** functionalities,
/// specifically for fetching personal information from the API.
///
/// This class provides methods to manage authentication and retrieve
/// the user's personal information.
///
/// ### Key Actions:
/// - **getPersonalInfo()**:
///   Sends a GET request to retrieve the user's personal information.
///
///   - **Returns**:
///     A [Map<String, dynamic>?] representing the user's personal information,
///     or throws an exception if the request fails.
///
///   - **Throws**:
///     An exception if the [authToken] is empty or if an error occurs during
///     the request, providing relevant error messages.
class PersonalInfoAPIService {
  final String baseUrl = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  PersonalInfoAPIService._();

  static Future<PersonalInfoAPIService> create() async {
    var apiService = PersonalInfoAPIService._();
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

  Future<Map<String, dynamic>?> getPersonalInfo() async {
    final String token = await authToken;
    try {
      if (token.isEmpty) {
        throw Exception('Authentication token is empty.');
      }
      final response = await http.get(
        Uri.parse('$baseUrl/itee/get-personal-info'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );
      print(response.request);
      print(response.statusCode);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print(jsonData);
        return jsonData;
      } else {
        throw Exception('Failed to get Personal Data');
      }
    } catch (e) {
      throw Exception('Error fetching Personal Data: $e');
    }
  }
}

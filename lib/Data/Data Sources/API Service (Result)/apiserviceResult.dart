import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// A service class for handling **Result Retrieval** functionalities,
/// specifically for fetching individual exam results for a student.
///
/// This class provides methods to manage authentication and retrieve
/// results from the API.
///
/// ### Key Actions:
/// - **getResult()**:
///   Fetches the exam results for a specific examinee.
///
///   - **Parameters**:
///     - [String examineeID]:
///       The unique identifier for the student whose results are to be fetched.
///
///   - **Returns**:
///     A [Map<String, dynamic>?] containing the result data,
///     or null if the request fails.
///
///   - **Throws**:
///     An exception if the [authToken] is empty or if an error occurs
///     during the request, providing relevant error messages.
class ResultAPIService {
  final String baseUrl = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  ResultAPIService._();

  static Future<ResultAPIService> create() async {
    var apiService = ResultAPIService._();
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

  Future<Map<String, dynamic>?> getResult(String examineeID) async {
    final String token = await authToken;
    print('ID :$examineeID');
    try {
      if (token.isEmpty) {
        throw Exception('Authentication token is empty.');
      }
      final response = await http.get(
        Uri.parse('$baseUrl/itee/student/individual/result/$examineeID'),
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
        throw Exception('Failed to load result');
      }
    } catch (e) {
      throw Exception('Error fetching result: $e');
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AdmitCardAPIService {
  final String baseUrl = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  AdmitCardAPIService._();

  static Future<AdmitCardAPIService> create() async {
    var apiService = AdmitCardAPIService._();
    await apiService._loadAuthToken();
    print('triggered API');
    return apiService;
  }

/*  AdmitCardAPIService() {
    _loadAuthToken();
    print('triggered');
  }*/

  Future<void> _loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('token') ?? '';
    print('Load Token');
    print(prefs.getString('token'));
  }

  Future<Map<String, dynamic>> fetchAdmitCardItems(String CatatogyID, String TypeID) async {

    final String token = await authToken;
    try {
      if (token.isEmpty) {
        throw Exception('Authentication token is empty.');
      }
      final response = await http.get(
        Uri.parse('$baseUrl/itee/admit/$CatatogyID/$TypeID'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print(jsonData);
        return jsonData;
      } else {
        throw Exception('Failed to load Admit Card');
      }
    } catch (e) {
      throw Exception('Error fetching syllabus: $e');
    }
  }
}

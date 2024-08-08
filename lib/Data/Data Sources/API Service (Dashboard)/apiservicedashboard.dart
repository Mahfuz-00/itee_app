import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DashboardAPIService {
  final String baseUrl = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  DashboardAPIService._();

  static Future<DashboardAPIService> create() async {
    var apiService = DashboardAPIService._();
    await apiService._loadAuthToken();
    print('triggered API');
    return apiService;
  }

/*  DashboardAPIService() {
    _loadAuthToken();
    print('triggered');
  }*/

  Future<void> _loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('token') ?? '';
    print('Load Token');
    print(prefs.getString('token'));
  }

  Future<Map<String, dynamic>> fetchDashboardItems() async {
    final String token = await authToken;
    final response;
    try {
      if (token.isEmpty) {
        response = await http.get(
            Uri.parse('$baseUrl/itee/dashboard'),
            headers: {
              'Accept': 'application/json',
            },
        );
      }else {
        response = await http.get(
          Uri.parse('$baseUrl/itee/dashboard'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $authToken',
          },
        );
      }


      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print(jsonData);
        return jsonData;
      } else {
        throw Exception('Failed to load dashboard items');
      }
    } catch (e) {
      throw Exception('Error fetching dashboard items: $e');
    }
  }
}

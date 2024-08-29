import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BookAPIService {
  final String baseUrl = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  BookAPIService._();

  static Future<BookAPIService> create() async {
    var apiService = BookAPIService._();
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

  Future<Map<String, dynamic>> fetchBooks(String examCategoryId) async {
    final String token = await authToken;
    try {
      if (token.isEmpty) {
        throw Exception('Authentication token is empty.');
      }
      print(examCategoryId);
      final response = await http.get(
        Uri.parse('$baseUrl/itee/get/book/fee/$examCategoryId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print(response.body);
        return jsonData;
      } else {
        throw Exception('Failed to load dashboard items');
      }
    } catch (e) {
      throw Exception('Error fetching dashboard items: $e');
    }
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../Models/userInfoUpdateModel.dart';

/// A service class for updating the user's profile information through the API.
///
/// This class manages the process of updating the user's profile,
/// requiring the user's ID and the new name. The class utilizes an
/// authentication token stored in shared preferences to authorize the
/// request.
///
/// ### Key Actions:
/// - **updateUserProfile**:
///   Updates the user's profile by sending a POST request to the
///   profile update endpoint.
///
///   - **Parameters**:
///     - [userData]: An instance of [UserProfileUpdateModel] containing the
///       user's ID and the new name to be updated.
///
///   - **Returns**:
///     A [String] containing the server's response message if the request
///     is successful.
///
///   - **Throws**:
///     An exception if the authentication token is empty or if the
///     request fails, providing a relevant error message.
class UpdateUserAPIService {
  late final String authToken;
  String URL = "https://bcc.touchandsolve.com/api/user/profile/update";

  UpdateUserAPIService._();

  static Future<UpdateUserAPIService> create() async {
    var apiService = UpdateUserAPIService._();
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

  Future<String> updateUserProfile(UserProfileUpdateModel userData) async {
    final String token = await authToken;
    try {
      if (token.isEmpty) {
        await _loadAuthToken();
        throw Exception('Authentication token is empty.');
      }

      var response = await http.post(
        Uri.parse(URL),
        headers: <String, String>{
          'Authorization': 'Bearer $token'
        },
        body: {
          'userId': userData.userId,
          'name': userData.name,
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        print('User profile updated successfully!');
        return jsonResponse['message'];
      } else {
        print('Failed to update user profile: ${response.body}');
        return 'Failed to update user profile. Please try again.';
      }
    } catch (e) {
      var response = await http.post(
        Uri.parse(URL),
        headers: <String, String>{
          'Authorization': 'Bearer $token'
        },
        body: {
          'userId': userData.userId,
          'name': userData.name,
        },
      );
      print(response.body);
      print('Error occurred while updating user profile: $e');
      return 'Failed to update user profile. Please try again.';
    }
  }
}

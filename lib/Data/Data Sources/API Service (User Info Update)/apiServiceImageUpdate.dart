import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/imageUpdateModel.dart';

/// A service class for updating the user's profile picture through the API.
///
/// This class manages the process of uploading a new profile picture for
/// the authenticated user, using an authentication token stored in
/// shared preferences.
///
/// ### Key Actions:
/// - **updateProfilePicture({required File image})**:
///   Uploads a new profile picture by sending a multipart POST request
///   to the profile picture update endpoint.
///
///   - **Parameters**:
///     - `image`: A [File] object representing the image to be uploaded.
///
///   - **Returns**:
///     A [ProfilePictureUpdateResponse] object containing the server's
///     response if the request is successful.
///
///   - **Throws**:
///     An exception if the authentication token is empty, if the request
///     fails, or if the server returns an error response, providing relevant
///     error messages.
class ProfilePictureUpdateAPIService {
  static const String URL =
      'https://bcc.touchandsolve.com/api/user/profile/photo/update';
  late final String authToken;

  ProfilePictureUpdateAPIService._();

  static Future<ProfilePictureUpdateAPIService> create() async {
    var apiService = ProfilePictureUpdateAPIService._();
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

  Future<ProfilePictureUpdateResponse> updateProfilePicture({required File image}) async {
    final String token = await authToken;
    try {
      if (token.isEmpty) {
        await _loadAuthToken();
        throw Exception('Authentication token is empty.');
      }
      var request = http.MultipartRequest('POST', Uri.parse(URL));
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';
      print(image);
      var imageStream = http.ByteStream(image!.openRead());
      var length = await image.length();
      var multipartFile = http.MultipartFile('photo', imageStream, length,
          filename: image.path.split('/').last);
      print(multipartFile);
      request.files.add(multipartFile);

      var response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        Map<String, dynamic> json = jsonDecode(responseBody);
        print(json);
        return ProfilePictureUpdateResponse.fromJson(json);
      } else {
        String responseBody = await response.stream.bytesToString();
        print(response.statusCode);
        print(responseBody);
        throw Exception(
            'Failed to update profile picture: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to update profile picture: $e');
    }
  }
}

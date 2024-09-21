import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image/image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../UI/Bloc/combine_page_cubit.dart';

/// A service class for handling **Exam Registration** functionalities,
/// specifically for sending exam registration data to the API.
///
/// This class provides methods to manage authentication and send
/// registration data along with any associated images.
///
/// ### Key Actions:
/// - **sendRegistrationDataFromCubit()**:
///   Sends a multipart POST request to register for an exam.
///
///   - **Parameters**:
///     - [CombinedDataCubit combinedDataCubit]:
///       The cubit containing the data necessary for registration.
///     - [File? imageFile]:
///       An optional image file to be uploaded with the registration data.
///
///   - **Returns**:
///     A [Map<String, dynamic>?] representing the API response,
///     or null if the request fails.
///
///   - **Throws**:
///     An exception if the [authToken] is empty or if an error occurs
///     during the request, providing relevant error messages.
class ExamRegistrationAPIService {
  static const String apiUrl =
      'https://bcc.touchandsolve.com/api/itee/exam/registration';

  late final String authToken;

  ExamRegistrationAPIService._();

  static Future<ExamRegistrationAPIService> create() async {
    var apiService = ExamRegistrationAPIService._();
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

  Future<Map<String, dynamic>?> sendRegistrationDataFromCubit(
      CombinedDataCubit combinedDataCubit, File? imageFile) async {
    // Get the data from the cubit
    final state = combinedDataCubit.state;

    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      'Authorization': 'Bearer $authToken',
    });

    String book = state.savedBookNames?.join('|') ?? 'No books selected';
    String bookID = state.bookID?.join('|') ?? 'No books selected';

    print('Book: $book');
    print('Book ID: $bookID');

    request.fields['itee_venue_id'] = state.venueID;
    request.fields['itee_exam_category_id'] = state.courseCategoryID;
    request.fields['itee_exam_type_id'] = state.courseTypeID;
    request.fields['exam_fees'] = state.examFee;
    request.fields['fee_id'] = state.examFeeID.toString();
    request.fields['itee_book_id'] = bookID;
    request.fields['itee_book_fees'] = state.bookPrice.toString();
    request.fields['full_name'] = state.fullName;
    request.fields['email'] = state.email;
    request.fields['phone'] = state.mobileNumber;
    request.fields['dob'] = state.dateOfBirth;
    request.fields['gender'] = state.gender;
    request.fields['address'] = state.address;
    request.fields['city'] = state.city;
    request.fields['post_code'] = state.postCode;
    request.fields['occupation'] = state.occupation;
    request.fields['linkedin'] = state.linkedin;
    request.fields['education_qualification'] = state.educationQualification;
    if (state.discipline.isNotEmpty) {
      request.fields['discipline'] = state.discipline;
    }
    if (state.subject.isNotEmpty) {
      request.fields['subject_name'] = state.subject;
    }
    request.fields['passing_year'] = state.passingYear;
    request.fields['institute_name'] = state.institute;
    request.fields['result'] = state.result;
    request.fields['previous_passing_id'] = state.passingID;

    if (imageFile != null) {
      var imageStream = http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();
      var multipartFile = http.MultipartFile('photo', imageStream, length,
          filename: imageFile.path.split('/').last);
      request.files.add(multipartFile);
    }

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
        print('Registration data sent successfully');
        print(jsonResponse);
        return jsonResponse;
      } else {
        var responseBody = await response.stream.bytesToString();
        Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
        print('Missing Data :$jsonResponse');
        print(
            'Failed to send registration data. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error sending registration data: $e');
      return null;
    }
  }
}

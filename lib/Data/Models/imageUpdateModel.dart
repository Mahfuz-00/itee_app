/// Represents the response from updating a profile picture.
///
/// This class encapsulates the response data returned after a profile picture
/// update request, including the status of the operation and a message.
///
/// ### Properties:
/// - [status]: A boolean indicating the success or failure of the update operation.
/// - [message]: A descriptive message about the result of the update operation.
class ProfilePictureUpdateResponse {
  final bool status;
  final String message;

  ProfilePictureUpdateResponse({required this.status, required this.message});

  factory ProfilePictureUpdateResponse.fromJson(Map<String, dynamic> json) {
    return ProfilePictureUpdateResponse(
      status: json['status'],
      message: json['message'],
    );
  }
}

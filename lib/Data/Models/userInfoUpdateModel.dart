/// Represents the data for updating a user profile.
///
/// This class is used to encapsulate the information required to
/// update a user's profile in the system.
///
/// ### Properties:
/// - [userId]: A string representing the unique identifier for the user.
/// - [name]: A string representing the user's name.
class UserProfileUpdateModel {
  final String userId;
  final String name;


  UserProfileUpdateModel({
    required this.userId,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
    };
  }
}

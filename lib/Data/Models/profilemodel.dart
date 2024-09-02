/// Represents the user profile information.
///
/// This class encapsulates the essential details of a user profile,
/// including the user's ID, name, and profile photo URL.
///
/// ### Properties:
/// - [Id]: An integer representing the unique identifier for the user.
/// - [name]: A string representing the name of the user.
/// - [photo]: A string representing the URL that contains the user's profile photo.
class UserProfile {
  final int Id;
  final String name;
  final String photo;

  UserProfile({
    required this.Id,
    required this.name,
    required this.photo,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      Id: json['userId'],
      name: json['name'],
      photo: json['photo'],
    );
  }
}
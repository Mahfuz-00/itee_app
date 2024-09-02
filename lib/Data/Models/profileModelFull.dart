/// Represents a more complete user profile containing additional information.
///
/// This class encapsulates detailed user profile information,
/// including the user's ID, name, phone number, email address, and profile photo URL.
///
/// ### Properties:
/// - [id]: An integer representing the unique identifier for the user.
/// - [name]: A string representing the name of the user.
/// - [phone]: A string representing the user's phone number.
/// - [email]: A string representing the user's email address.
/// - [photo]: A string representing the URL of the user's profile photo.
class UserProfileFull {
  final int id;
  final String name;
  final String phone;
  final String email;
  final String photo;

  UserProfileFull({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.photo,
  });

  factory UserProfileFull.fromJson(Map<String, dynamic> json) {
    return UserProfileFull(
      id: json['userId'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      photo: json['photo'],
    );
  }
}
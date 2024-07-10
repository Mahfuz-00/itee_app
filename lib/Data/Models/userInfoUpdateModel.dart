class UserProfileUpdate {
  final String userId;
  final String name;


  UserProfileUpdate({
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

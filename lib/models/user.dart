class User {
  final int accountId;
  final String email;
  final String? profileImagePath;

  User({
    required this.accountId,
    required this.email,
    this.profileImagePath,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      accountId: json['account_id'],
      email: json['email'],
      profileImagePath: json['profile_image_path'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'account_id': accountId,
      'email': email,
      'profile_image_path': profileImagePath,
    };
  }
}
class UserProfile {
  final String uid;
  final String email;
  final String role;

  UserProfile({required this.uid, required this.email, required this.role});

  Map<String, dynamic> toMap() {
    return {'email': email, 'role': role, 'updatedAt': DateTime.now()};
  }

  factory UserProfile.fromMap(String uid, Map<String, dynamic> map) {
    return UserProfile(
      uid: uid,
      email: map['email'] ?? '',
      role: map['role'] ?? 'user',
    );
  }
}

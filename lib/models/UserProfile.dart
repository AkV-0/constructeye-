class UserProfile {
  final String uid;
  final String email;
  final String role; // admin, client, executive
  final String? displayName;
  final String? profileImageUrl;
  final DateTime? createdAt;
  final String? phoneNumber;
  final String? designation; // For executives: Engineer, Supervisor, etc.

  UserProfile({
    required this.uid,
    required this.email,
    required this.role,
    this.displayName,
    this.profileImageUrl,
    this.createdAt,
    this.phoneNumber,
    this.designation,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'role': role,
      'displayName': displayName ?? '',
      'profileImageUrl': profileImageUrl ?? '',
      'createdAt': createdAt ?? DateTime.now(),
      'phoneNumber': phoneNumber ?? '',
      'designation': designation ?? '',
      'updatedAt': DateTime.now(),
    };
  }

  factory UserProfile.fromMap(String uid, Map<String, dynamic> map) {
    return UserProfile(
      uid: uid,
      email: map['email'] ?? '',
      role: map['role'] ?? 'client',
      displayName: map['displayName'] ?? '',
      profileImageUrl: map['profileImageUrl'],
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as dynamic).toDate()
          : DateTime.now(),
      phoneNumber: map['phoneNumber'],
      designation: map['designation'],
    );
  }
}

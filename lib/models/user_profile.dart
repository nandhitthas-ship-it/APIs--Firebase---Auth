class UserProfile {
  const UserProfile({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.createdAt,
  });

  final String uid;
  final String email;
  final String displayName;
  final DateTime createdAt;

  factory UserProfile.fromMap(String uid, Map<String, dynamic> data) {
    final rawCreatedAt = data['createdAt'];
    final createdAt = rawCreatedAt is DateTime
        ? rawCreatedAt
        : DateTime.tryParse(rawCreatedAt?.toString() ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(0);

    return UserProfile(
      uid: uid,
      email: data['email'] as String? ?? '',
      displayName: data['displayName'] as String? ?? '',
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

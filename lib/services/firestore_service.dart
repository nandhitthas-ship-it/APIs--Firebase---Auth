import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_profile.dart';

class FirestoreService {
  FirestoreService({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<void> saveProfile(User user) async {
    final reference = _firestore.collection('users').doc(user.uid);
    final existing = await reference.get();
    final profile = {
      'email': user.email ?? '',
      'displayName': user.displayName ?? '',
    };
    if (existing.exists) {
      await reference.set(profile, SetOptions(merge: true));
      return;
    }
    await reference.set({
      ...profile,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<UserProfile?> loadProfile(String uid) async {
    final snapshot = await _firestore.collection('users').doc(uid).get();
    final data = snapshot.data();
    if (!snapshot.exists || data == null) return null;

    final normalized = Map<String, dynamic>.from(data);
    final timestamp = normalized['createdAt'];
    if (timestamp is Timestamp) {
      normalized['createdAt'] = timestamp.toDate().toIso8601String();
    }
    return UserProfile.fromMap(snapshot.id, normalized);
  }
}

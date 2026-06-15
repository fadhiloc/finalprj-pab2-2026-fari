import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GymSubmissionService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<void> submitGym({
    required String name,
    required String location,
    required String description,
    required double latitude,
    required double longitude,
    required String type,
    required List<String> imageUrls,
  }) async {
    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) return;

    await _firestore
        .collection('gym_submissions')
        .add({
      'name': name,
      'location': location,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,

      'type': type,
      'imageUrls': imageUrls,

      'submittedBy': user.uid,
      'submittedByEmail': user.email,

      'status': 'pending',

      'createdAt': Timestamp.now(),
    });
  }
}
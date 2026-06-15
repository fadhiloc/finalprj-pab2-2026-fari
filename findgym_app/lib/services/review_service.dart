import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReviewService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  Future<void> submitReview({
    required String gymId,
    required double rating,
    required String comment,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User belum login');
    }

    final userDoc =
        await _firestore
            .collection('users')
            .doc(user.uid)
            .get();

    final userName =
        userDoc.data()?['name'] ??
            user.email;

    await _firestore
        .collection('gyms')
        .doc(gymId)
        .collection('reviews')
        .add({
      'userId': user.uid,
      'userName': userName,
      'rating': rating,
      'comment': comment,
      'createdAt': Timestamp.now(),
    });

    await _updateGymRating(gymId);
  }

  Future<void> _updateGymRating(
      String gymId) async {
    final snapshot =
        await _firestore
            .collection('gyms')
            .doc(gymId)
            .collection('reviews')
            .get();

    if (snapshot.docs.isEmpty) {
      await _firestore
          .collection('gyms')
          .doc(gymId)
          .update({
        'rating': 0.0,
        'ratingCount': 0,
      });

      return;
    }

    double total = 0;

    for (var doc in snapshot.docs) {
      total +=
          (doc['rating'] as num)
              .toDouble();
    }

    final average =
        total / snapshot.docs.length;

    await _firestore
        .collection('gyms')
        .doc(gymId)
        .update({
      'rating': average,
      'ratingCount':
          snapshot.docs.length,
    });
  }
}
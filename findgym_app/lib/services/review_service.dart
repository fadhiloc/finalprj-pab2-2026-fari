import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'notification_service.dart';

class ReviewService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  final NotificationService
      _notificationService =
      NotificationService();

  Future<void> submitReview({
    required String gymId,
    required double rating,
    required String comment,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception(
        'User belum login',
      );
    }

    // Ambil data user
    final userDoc =
        await _firestore
            .collection('users')
            .doc(user.uid)
            .get();

    final userData =
        userDoc.data() ??
        <String, dynamic>{};

    final userName =
        userData['name'] ??
        user.email ??
        'User';

    // Simpan review
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

    // Update rating gym
    await _updateGymRating(gymId);

    // ==========================
    // NOTIFIKASI KE OWNER GYM
    // ==========================

    final gymDoc =
        await _firestore
            .collection('gyms')
            .doc(gymId)
            .get();

    if (gymDoc.exists) {
      final gymData =
          gymDoc.data()!;

      final ownerId =
          gymData['ownerId'];

      final gymName =
          gymData['name'] ??
          'Gym';

      // Jangan kirim notif ke diri sendiri
      if (ownerId != null &&
          ownerId != user.uid) {
        await _notificationService
            .createNotification(
          userId: ownerId,
          title: 'Review Baru',
          body:
              '$userName memberi rating '
              '${rating.toStringAsFixed(1)}⭐ '
              'untuk $gymName.',
          type: 'review',
        );
      }
    }
  }

  Future<void> _updateGymRating(
    String gymId,
  ) async {
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

    for (var doc
        in snapshot.docs) {
      total +=
          (doc['rating']
                  as num)
              .toDouble();
    }

    final average =
        total /
        snapshot.docs.length;

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
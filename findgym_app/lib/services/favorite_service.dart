import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  /// Cek apakah gym sudah difavoritkan
  Future<bool> isFavorite(
    String gymId,
  ) async {
    final user = _auth.currentUser;

    if (user == null) {
      return false;
    }

    final doc = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(gymId)
        .get();

    return doc.exists;
  }

  /// Tambah/Hapus favorite
  Future<void> toggleFavorite(
    String gymId,
  ) async {
    final user = _auth.currentUser;

    if (user == null) return;

    final favoriteRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(gymId);

    final doc =
        await favoriteRef.get();

    if (doc.exists) {
      // Hapus favorite
      await favoriteRef.delete();
    } else {
      // Tambah favorite
      await favoriteRef.set({
        'createdAt': Timestamp.now(),
      });
    }
  }

  /// Tambahkan ke favorite
  Future<void> addFavorite(
    String gymId,
  ) async {
    final user = _auth.currentUser;

    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(gymId)
        .set({
      'createdAt': Timestamp.now(),
    });
  }

  /// Hapus favorite
  Future<void> removeFavorite(
    String gymId,
  ) async {
    final user = _auth.currentUser;

    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(gymId)
        .delete();
  }
}
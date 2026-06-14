import 'package:cloud_firestore/cloud_firestore.dart';

class GymService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final String collectionName = "gyms";

  Future<void> addGym({
    required String name,
    required String location,
    required String description,
    required double latitude,
    required double longitude,
    required String type,
    required List<String> imageUrls,
  }) async {
    await _firestore.collection(collectionName).add({
      'name': name,
      'location': location,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'type': type,
      'imageUrls': imageUrls,
      'rating': 0.0,
      'ratingCount': 0,
      'createdAt': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getGyms() {
    return _firestore
        .collection(collectionName)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> updateGym({
    required String id,
    required String name,
    required String location,
    required String description,
    required double latitude,
    required double longitude,
    required String type,
  }) async {
    await _firestore
        .collection(collectionName)
        .doc(id)
        .update({
      'name': name,
      'location': location,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'type': type,
    });
  }

  Future<void> deleteGym(String id) async {
    await _firestore
        .collection(collectionName)
        .doc(id)
        .delete();
  }
}
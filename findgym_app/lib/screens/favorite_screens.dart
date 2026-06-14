import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Models/Gym.dart';
import '../widgets/item_card.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  Gym gymFromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Gym(
      id: doc.id,
      name: data['name'] ?? '',
      location: data['location'] ?? '',
      description: data['description'] ?? '',
      latitude: (data['latitude'] ?? 0).toDouble(),
      longitude: (data['longitude'] ?? 0).toDouble(),

      types: List<String>.from(
        data['types'] ?? [],
      ),

      imageUrls: List<String>.from(
        data['imageUrls'] ?? [],
      ),

      rating:
          (data['rating'] ?? 0)
              .toDouble(),

      ratingCount:
          data['ratingCount'] ?? 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Silakan login terlebih dahulu',
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor:
          Colors.blueGrey.shade50,

      appBar: AppBar(
        title: const Text(
          'Favorite Gym',
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .collection(
                  'favorites',
                )
                .snapshots(),

        builder: (
          context,
          snapshot,
        ) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error
                    .toString(),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          final favoriteIds =
              snapshot.data!.docs
                  .map(
                    (e) => e.id,
                  )
                  .toList();

          if (favoriteIds.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada gym favorit',
              ),
            );
          }

          return StreamBuilder<
              QuerySnapshot>(
            stream:
                FirebaseFirestore
                    .instance
                    .collection(
                      'gyms',
                    )
                    .where(
                      FieldPath
                          .documentId,
                      whereIn:
                          favoriteIds,
                    )
                    .snapshots(),

            builder: (
              context,
              gymSnapshot,
            ) {
              if (!gymSnapshot
                  .hasData) {
                return const Center(
                  child:
                      CircularProgressIndicator(),
                );
              }

              final gyms =
                  gymSnapshot
                      .data!
                      .docs
                      .map(
                        gymFromDocument,
                      )
                      .toList();

              return GridView.builder(
                padding:
                    const EdgeInsets.all(
                      16,
                    ),

                itemCount:
                    gyms.length,

                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          2,
                      crossAxisSpacing:
                          12,
                      mainAxisSpacing:
                          12,
                      childAspectRatio:
                          0.75,
                    ),

                itemBuilder: (
                  context,
                  index,
                ) {
                  return ItemCard(
                    gym:
                        gyms[index],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
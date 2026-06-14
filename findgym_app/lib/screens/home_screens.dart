import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Models/Gym.dart';
import '../widgets/item_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController
      _searchController =
      TextEditingController();

  String searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Gym gymFromDocument(
    DocumentSnapshot doc,
  ) {
    final data =
        doc.data() as Map<String, dynamic>;

    return Gym(
      id: doc.id,
      name: data['name'] ?? '',
      location: data['location'] ?? '',
      description:
          data['description'] ?? '',
      latitude:
          (data['latitude'] ?? 0)
              .toDouble(),
      longitude:
          (data['longitude'] ?? 0)
              .toDouble(),

      types:List<String>.from(
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

  Future<void> _logout() async {
    await FirebaseAuth.instance
        .signOut();

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/signin',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user =
        FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F6FA),

      appBar: AppBar(
        title: const Text(
          "Aplikasi Gym Palembang",
        ),
        centerTitle: true,

        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _logout();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                enabled: false,
                child: Text(
                  user?.email ?? 'Belum login',
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.all(
                  16,
                ),
            child: TextField(
              controller:
                  _searchController,
              decoration:
                  InputDecoration(
                hintText:
                    "Cari gym...",
                prefixIcon:
                    const Icon(
                      Icons.search,
                    ),
                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                        15,
                      ),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery =
                      value
                          .toLowerCase()
                          .trim();
                });
              },
            ),
          ),

          Expanded(
            child:
                StreamBuilder<
                  QuerySnapshot
                >(
                  stream:
                      FirebaseFirestore
                          .instance
                          .collection(
                            'gyms',
                          )
                          .where(
                            'Status',
                            isEqualTo: 'Approved',
                          )
                          .snapshots(),

                  builder: (
                    context,
                    snapshot,
                  ) {
                    if (snapshot
                        .hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                        ),
                      );
                    }

                    if (snapshot
                            .connectionState ==
                        ConnectionState
                            .waiting) {
                      return const Center(
                        child:
                            CircularProgressIndicator(),
                      );
                    }

                    final docs =
                        snapshot
                            .data!
                            .docs;

                    final gyms =
                        docs
                            .map(
                              gymFromDocument,
                            )
                            .where((
                              gym,
                            ) {
                              return gym
                                      .name
                                      .toLowerCase()
                                      .contains(
                                        searchQuery,
                                      ) ||
                                  gym
                                      .location
                                      .toLowerCase()
                                      .contains(
                                        searchQuery,
                                      );
                            })
                            .toList();

                    if (gyms
                        .isEmpty) {
                      return const Center(
                        child: Text(
                          "Belum ada data gym",
                        ),
                      );
                    }

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
                ),
          ),
        ],
      ),

      floatingActionButton:
          FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/submitgym',
              );
            },
            child: const Icon(
              Icons.add,
            ),
          ),
    );
  }
}
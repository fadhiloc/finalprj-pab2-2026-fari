import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Models/Gym.dart';
import 'detail_screens.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController =
      TextEditingController();

  String searchQuery = '';

  Gym gymFromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Gym(
      id: doc.id,
      name: data['name'] ?? '',
      location: data['location'] ?? '',
      description: data['description'] ?? '',
      latitude: (data['latitude'] ?? 0).toDouble(),
      longitude: (data['longitude'] ?? 0).toDouble(),
      types: List<String>.from( data['type'] ?? [],),
      imageUrls:
          List<String>.from(data['imageUrls'] ?? []),
      rating: (data['rating'] ?? 0).toDouble(),
      ratingCount: data['ratingCount'] ?? 0,
      openTime: data['openTime'] ?? '',
      closeTime: data['closeTime'] ?? '',
      contact: data['contact'] ?? '',
      instagram: data['instagram'] ?? '',

    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Cari Gym',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              16,
              topPadding + 64,
              16,
              16,
            ),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              gradient: LinearGradient(
                colors: [
                  Color(0xFF7C3AED),
                  Color(0xFFA78BFA),
                ],
              ),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Cari gym...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery =
                      value.toLowerCase().trim();
                });
              },
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('gyms')
                  .where(
                    'status', isEqualTo: 'approved',
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Error: ${snapshot.error}",
                    ),
                  );
                }

                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child:
                        CircularProgressIndicator(),
                  );
                }

                final gyms = snapshot.data!.docs
                    .map(gymFromDocument)
                    .where((gym) {
                  return gym.name
                          .toLowerCase()
                          .contains(searchQuery) ||
                      gym.location
                          .toLowerCase()
                          .contains(searchQuery);
                }).toList();

                if (gyms.isEmpty) {
                  return const Center(
                    child: Text(
                      "Gym tidak ditemukan",
                    ),
                  );
                }

                return ListView.builder(
                  padding:
                      const EdgeInsets.all(16),
                  itemCount: gyms.length,
                  itemBuilder: (context, index) {
                    final gym = gyms[index];

                    return Card(
                      margin:
                          const EdgeInsets.only(
                        bottom: 12,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            gym.name.isNotEmpty
                                ? gym.name[0]
                                : "G",
                          ),
                        ),
                        title: Text(gym.name),
                        subtitle: Text(
                          gym.location,
                        ),
                        trailing: const Icon(
                          Icons.chevron_right,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  DetailScreen(
                                gym: gym,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}   
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Models/Gym.dart';
import '../widgets/item_card.dart';
import '../widgets/notification_bell.dart';

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
  String selectedType = 'Semua';
  String sortBy = 'Top Rating';

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

      openTime: data['openTime'] ?? '',
      closeTime: data['closeTime'] ?? '',
      contact: data['contact'] ?? '',
      instagram: data['instagram'] ?? '',

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
          "FindMyGym",
        ),
        centerTitle: true,

        actions: [
          const NotificationBell(),
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

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),

            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('gym_types')
                  .orderBy('name')
                  .snapshots(),

              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                }

                final types = [
                  'Semua',
                  ...snapshot.data!.docs.map(
                    (e) => e['name'].toString(),
                  ),
                ];

                final isAdmin =
                    user?.email ==
                    'admin@gmail.com';

                return Wrap(
                  spacing: 8,
                  runSpacing: 8,

                  children: [
                    ...types.map((type) {
                      return ChoiceChip(
                        label: Text(type),

                        selected:
                            selectedType == type,

                        onSelected: (_) {
                          setState(() {
                            selectedType = type;
                          });
                        },
                      );
                    }).toList(),

                    if (isAdmin)
                      ActionChip(
                        avatar: const Icon(
                          Icons.add,
                          size: 18,
                        ),

                        label: const Text(
                          'Kategori',
                        ),

                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/admincategory',
                          );
                        },
                      ),
                  ],
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          Padding(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 16,
            ),

            child: DropdownButtonFormField<
                String>(
              value: sortBy,

              decoration:
                  const InputDecoration(
                labelText: 'Urutkan',
              ),

              items: const [
                DropdownMenuItem(
                  value: 'Top Rating',
                  child: Text(
                    'Top Rating',
                  ),
                ),

                DropdownMenuItem(
                  value: 'Nama A-Z',
                  child: Text(
                    'Nama A-Z',
                  ),
                ),
              ],

              onChanged: (value) {
                setState(() {
                  sortBy = value!;
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
                            'status',
                            isEqualTo: 'approved',
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
                            .where((gym) {
                              final matchSearch =
                                  gym.name
                                      .toLowerCase()
                                      .contains(searchQuery) ||
                                  gym.location
                                      .toLowerCase()
                                      .contains(searchQuery);

                              final matchType =
                                  selectedType == 'Semua' ||
                                  gym.types.contains(selectedType);

                              return matchSearch && matchType;
                            })
                            .toList();

                    if (sortBy ==
                        'Top Rating') {
                      gyms.sort(
                        (a, b) => b.rating
                            .compareTo(a.rating),
                      );
                    }

                    if (sortBy ==
                        'Nama A-Z') {
                      gyms.sort(
                        (a, b) =>
                            a.name.compareTo(
                          b.name,
                        ),
                      );
                    }
                    

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
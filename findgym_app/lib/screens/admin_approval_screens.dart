import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminApprovalScreen extends StatelessWidget {
  const AdminApprovalScreen({super.key});

  Future<void> approveGym(String id) async {
    await FirebaseFirestore.instance
        .collection('gyms')
        .doc(id)
        .update({
      'status': 'approved',
    });
  }

  Future<void> rejectGym(String id) async {
    await FirebaseFirestore.instance
        .collection('gyms')
        .doc(id)
        .update({
      'status': 'rejected',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Approval Gym',
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('gyms')
            .where(
              'status',
              isEqualTo: 'pending',
            )
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                'Tidak ada pengajuan gym',
              ),
            );
          }

          return ListView.builder(
            itemCount: docs.length,

            itemBuilder: (context, index) {
              final data =
                  docs[index].data()
                      as Map<String, dynamic>;

              return Card(
                margin:
                    const EdgeInsets.all(12),

                child: Padding(
                  padding:
                      const EdgeInsets.all(
                          16),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [
                      Text(
                        data['name'] ?? '',
                        style:
                            const TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      Text(
                        data['location'] ??
                            '',
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      Wrap(
                        spacing: 8,
                        children:
                            List<String>.from(
                          data['types'] ??
                              [],
                        ).map((type) {
                          return Chip(
                            label: Text(
                              type,
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      Row(
                        children: [
                          Expanded(
                            child:
                                ElevatedButton.icon(
                              style:
                                  ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.green,
                              ),

                              onPressed:
                                  () async {
                                await approveGym(
                                  docs[index]
                                      .id,
                                );

                                ScaffoldMessenger.of(
                                        context)
                                    .showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Gym disetujui',
                                    ),
                                  ),
                                );
                              },

                              icon:
                                  const Icon(
                                Icons.check,
                              ),

                              label:
                                  const Text(
                                'Approve',
                              ),
                            ),
                          ),

                          const SizedBox(
                            width: 12,
                          ),

                          Expanded(
                            child:
                                ElevatedButton.icon(
                              style:
                                  ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.red,
                              ),

                              onPressed:
                                  () async {
                                await rejectGym(
                                  docs[index]
                                      .id,
                                );

                                ScaffoldMessenger.of(
                                        context)
                                    .showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Gym ditolak',
                                    ),
                                  ),
                                );
                              },

                              icon:
                                  const Icon(
                                Icons.close,
                              ),

                              label:
                                  const Text(
                                'Reject',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
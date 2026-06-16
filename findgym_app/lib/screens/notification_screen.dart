import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  IconData getIcon(String type) {
    switch (type) {
      case 'approved':
        return Icons.check_circle;

      case 'rejected':
        return Icons.cancel;

      case 'review':
        return Icons.star;

      case 'submit':
        return Icons.fitness_center;

      default:
        return Icons.notifications;
    }
  }

  Color getColor(String type) {
    switch (type) {
      case 'approved':
        return Colors.green;

      case 'rejected':
        return Colors.red;

      case 'review':
        return Colors.amber;

      case 'submit':
        return const Color(0xFF7C3AED);

      default:
        return Colors.blueGrey;
    }
  }

  String formatTime(Timestamp? timestamp) {
    if (timestamp == null) {
      return '';
    }

    final date = timestamp.toDate();

    return
        '${date.day}/${date.month}/${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'User belum login',
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(
        0xFFF5F3FF,
      ),

      appBar: AppBar(
        title: const Text(
          'Notifikasi',
        ),
        centerTitle: true,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .where(
              'userId',
              isEqualTo: user.uid,
            )
            .orderBy(
              'createdAt', descending: true,
            )
            .snapshots(),

        builder: (context, snapshot) {
          // ERROR
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error:\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          // LOADING
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          // TIDAK ADA DATA
          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada notifikasi',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            );
          }

          final docs =
              snapshot.data!.docs;

          return ListView.builder(
            padding:
                const EdgeInsets.all(12),

            itemCount: docs.length,

            itemBuilder: (
              context,
              index,
            ) {
              final doc =
                  docs[index];

              final data =
                  doc.data()
                      as Map<String, dynamic>;

              final bool isRead =
                  data['isRead'] ?? false;

              return Card(
                elevation: 3,
                margin:
                    const EdgeInsets.only(
                  bottom: 10,
                ),

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),
                ),

                child: ListTile(
                  contentPadding:
                      const EdgeInsets.all(
                    12,
                  ),

                  leading: CircleAvatar(
                    radius: 24,
                    backgroundColor:
                        getColor(
                      data['type'] ?? '',
                    ),

                    child: Icon(
                      getIcon(
                        data['type'] ?? '',
                      ),
                      color:
                          Colors.white,
                    ),
                  ),

                  title: Text(
                    data['title'] ?? '',
                    style: TextStyle(
                      fontWeight:
                          isRead
                              ? FontWeight
                                  .normal
                              : FontWeight
                                  .bold,
                    ),
                  ),

                  subtitle: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [
                      const SizedBox(
                        height: 4,
                      ),

                      Text(
                        data['body'] ??
                            '',
                      ),

                      const SizedBox(
                        height: 6,
                      ),

                      Text(
                        formatTime(
                          data['createdAt']
                              as Timestamp?,
                        ),
                        style:
                            const TextStyle(
                          fontSize: 11,
                          color:
                              Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  trailing: isRead
                      ? null
                      : const Icon(
                          Icons.circle,
                          size: 12,
                          color: Colors.red,
                        ),

                  onTap: () async {
                    await FirebaseFirestore
                        .instance
                        .collection(
                          'notifications',
                        )
                        .doc(doc.id)
                        .update({
                      'isRead': true,
                    });
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
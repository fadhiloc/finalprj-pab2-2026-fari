import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationBell extends StatelessWidget {
  const NotificationBell({super.key});

  @override
  Widget build(BuildContext context) {
    final uid =
        FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const SizedBox();
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('notifications')
          .where(
            'userId',
            isEqualTo: uid,
          )
          .where(
            'isRead',
            isEqualTo: false,
          )
          .snapshots(),

      builder: (context, snapshot) {
        final count =
            snapshot.data?.docs.length ?? 0;

        return Stack(
          children: [
            IconButton(
              icon: const Icon(
                Icons.notifications,
              ),

              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/notifications',
                );
              },
            ),

            if (count > 0)
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  padding:
                      const EdgeInsets.all(4),

                  decoration:
                      const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),

                  child: Text(
                    '$count',
                    style:
                        const TextStyle(
                      color:
                          Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
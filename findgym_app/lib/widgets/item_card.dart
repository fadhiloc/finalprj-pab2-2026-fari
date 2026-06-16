import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:aplikasi_gym_palembang/Models/Gym.dart';
import 'package:aplikasi_gym_palembang/screens/detail_screens.dart';

class ItemCard extends StatelessWidget {
  final Gym gym;

  const ItemCard({
    super.key,
    required this.gym,
  });

  @override
  Widget build(BuildContext context) {
    final imageBase64 =
        gym.imageUrls.isNotEmpty
            ? gym.imageUrls.first
            : '';

    final user =
        FirebaseAuth.instance.currentUser;

    final bool isAdmin =
        user?.email ==
        'admin@gmail.com';

    return InkWell(
      borderRadius:
          BorderRadius.circular(15),

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

      child: Stack(
        children: [
          Card(
            elevation: 3,

            shape:
                RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(
                15,
              ),
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [
                Expanded(
                  flex: 6,

                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(
                      top:
                          Radius.circular(
                        15,
                      ),
                    ),

                    child:
                        imageBase64
                                .isNotEmpty
                            ? Image.memory(
                                base64Decode(
                                  imageBase64,
                                ),
                                width:
                                    double.infinity,
                                fit:
                                    BoxFit.cover,

                                errorBuilder: (
                                  context,
                                  error,
                                  stackTrace,
                                ) {
                                  return Container(
                                    color: Colors
                                        .grey
                                        .shade300,

                                    child:
                                        const Center(
                                      child:
                                          Icon(
                                        Icons
                                            .broken_image,
                                        size:
                                            40,
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Container(
                                color: Colors
                                    .grey
                                    .shade300,

                                child:
                                    const Center(
                                  child: Icon(
                                    Icons
                                        .image,
                                    size:
                                        40,
                                  ),
                                ),
                              ),
                  ),
                ),

                Expanded(
                  flex: 4,

                  child: Padding(
                    padding:
                        const EdgeInsets.fromLTRB(
                      10,
                      8,
                      10,
                      8,
                    ),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [
                        Text(
                          gym.name,
                          maxLines: 1,
                          overflow:
                              TextOverflow
                                  .ellipsis,

                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight
                                    .bold,
                            fontSize:
                                14,
                          ),
                        ),

                        const SizedBox(
                          height: 4,
                        ),

                        Text(
                          gym.types.join(
                            ', ',
                          ),

                          maxLines: 1,
                          overflow:
                              TextOverflow
                                  .ellipsis,

                          style:
                              TextStyle(
                            color: Colors
                                .grey
                                .shade700,
                            fontSize:
                                12,
                          ),
                        ),

                        const Spacer(),

                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 16,
                              color: Colors
                                  .amber,
                            ),

                            const SizedBox(
                              width: 4,
                            ),

                            Text(
                              gym.rating
                                  .toStringAsFixed(
                                1,
                              ),

                              style:
                                  const TextStyle(
                                fontWeight:
                                    FontWeight
                                        .bold,
                                fontSize:
                                    12,
                              ),
                            ),

                            const SizedBox(
                              width: 4,
                            ),

                            Text(
                              '(${gym.ratingCount})',

                              style:
                                  TextStyle(
                                fontSize:
                                    11,
                                color: Colors
                                    .grey
                                    .shade600,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 4,
                        ),

                        Row(
                          children: [
                            Icon(
                              Icons
                                  .location_on,
                              size: 14,
                              color: Colors
                                  .red
                                  .shade400,
                            ),

                            const SizedBox(
                              width: 4,
                            ),

                            Expanded(
                              child: Text(
                                gym.location,

                                maxLines: 1,
                                overflow:
                                    TextOverflow
                                        .ellipsis,

                                style:
                                    const TextStyle(
                                  fontSize:
                                      11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tombol hapus untuk admin
          if (isAdmin)
            Positioned(
              top: 8,
              right: 8,

              child: CircleAvatar(
                radius: 18,
                backgroundColor:
                    Colors.white,

                child: IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 18,
                  ),

                  onPressed:
                      () async {
                    final confirm =
                        await showDialog<
                            bool>(
                      context:
                          context,

                      builder:
                          (_) =>
                              AlertDialog(
                        title:
                            const Text(
                          'Hapus Gym',
                        ),

                        content:
                            Text(
                          'Yakin ingin menghapus ${gym.name}?',
                        ),

                        actions: [
                          TextButton(
                            onPressed:
                                () {
                              Navigator.pop(
                                context,
                                false,
                              );
                            },

                            child:
                                const Text(
                              'Batal',
                            ),
                          ),

                          ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors
                                      .red,
                            ),

                            onPressed:
                                () {
                              Navigator.pop(
                                context,
                                true,
                              );
                            },

                            child:
                                const Text(
                              'Hapus',
                            ),
                          ),
                        ],
                      ),
                    );

                    if (confirm ==
                        true) {
                      await FirebaseFirestore
                          .instance
                          .collection(
                            'gyms',
                          )
                          .doc(
                            gym.id,
                          )
                          .delete();

                      if (context
                          .mounted) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(
                          const SnackBar(
                            content:
                                Text(
                              'Gym berhasil dihapus',
                            ),
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
    final imageUrl =
        gym.imageUrls.isNotEmpty ? gym.imageUrls.first : '';

    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailScreen(
              gym: gym,
            ),
          ),
        );
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                child: imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder:
                            (context, url) {
                          return Container(
                            color:
                                Colors.grey.shade300,
                            child: const Center(
                              child:
                                  CircularProgressIndicator(),
                            ),
                          );
                        },
                        errorWidget:
                            (context, url, error) {
                          return Container(
                            color:
                                Colors.grey.shade300,
                            child: const Icon(
                              Icons.broken_image,
                              size: 40,
                            ),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey.shade300,
                        child: const Center(
                          child: Icon(
                            Icons.image,
                            size: 40,
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
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      gym.name,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      gym.type,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: TextStyle(
                        color:
                            Colors.grey.shade700,
                        fontSize: 12,
                      ),
                    ),

                    const Spacer(),

                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          gym.rating
                              .toStringAsFixed(1),
                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${gym.ratingCount})',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors
                                .grey.shade600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color:
                              Colors.red.shade400,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            gym.location,
                            maxLines: 1,
                            overflow:
                                TextOverflow
                                    .ellipsis,
                            style:
                                const TextStyle(
                              fontSize: 11,
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
    );
  }
}
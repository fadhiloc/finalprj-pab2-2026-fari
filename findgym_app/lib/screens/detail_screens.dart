import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:aplikasi_gym_palembang/Models/Gym.dart';
import '../services/review_service.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../services/favorite_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailScreen extends StatefulWidget {
  final Gym gym;

  const DetailScreen({
    super.key,
    required this.gym,
  });

  @override
    State<DetailScreen> createState() =>
        _DetailScreenState();
  }

  class _DetailScreenState
      extends State<DetailScreen> {

      Widget _buildReviews() {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('gyms')
              .doc(widget.gym.id)
              .collection('reviews')
              .orderBy(
                'createdAt',
                descending: true,
              )
              .snapshots(),

          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text(
                "Gagal memuat review",
              );
            }

            if (!snapshot.hasData) {
              return const Center(
                child:
                    CircularProgressIndicator(),
              );
            }

            final reviews =
                snapshot.data!.docs;

            if (reviews.isEmpty) {
              return const Text(
                "Belum ada review",
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(),
              itemCount: reviews.length,

              itemBuilder:
                  (context, index) {
                final data =
                    reviews[index].data()
                        as Map<String,
                            dynamic>;

                return Card(
                  margin:
                      const EdgeInsets.only(
                    bottom: 12,
                  ),

                  child: Padding(
                    padding:
                        const EdgeInsets.all(
                      12,
                    ),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              child: Icon(
                                Icons.person,
                              ),
                            ),

                            const SizedBox(
                              width: 10,
                            ),

                            Expanded(
                              child: Text(
                                data['userName'] ??
                                    'User',
                                style:
                                    const TextStyle(
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),

                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color:
                                      Colors.amber,
                                  size: 18,
                                ),
                                Text(
                                  data['rating']
                                      .toString(),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        Text(
                          data['comment'] ??
                              '',
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      }

    final ReviewService _reviewService =
        ReviewService();

    final TextEditingController
        _reviewController =
            TextEditingController();

    final FavoriteService _favoriteService =
        FavoriteService();

    bool isFavorite = false;
    double _rating = 5;

    @override
    void initState() {
      super.initState();
      _loadFavorite();
    }

    Future<void> _loadFavorite() async {
      final result =
          await _favoriteService.isFavorite(
        widget.gym.id,
      );

      if (mounted) {
        setState(() {
          isFavorite = result;
        });
      }
    }
    

    @override
    void dispose() {
      _reviewController.dispose();
      super.dispose();
    }

  Widget _buildRatingChip() {
    if (widget.gym.rating <= 0 || widget.gym.ratingCount <= 0) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          "Belum ada rating",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star,
            color: Colors.orange,
            size: 18,
          ),
          const SizedBox(width: 6),
          Text(
            widget.gym.rating.toStringAsFixed(1),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            "(${widget.gym.ratingCount})",
            style: const TextStyle(
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.red),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.gym.location,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(Icons.fitness_center, color: Colors.green),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.gym.types.join(', '),
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGallery() {
    if (widget.gym.imageUrls.isEmpty) {
      return Container(
        height: 120,
        alignment: Alignment.center,
        child: const Text(
          "Belum ada foto",
        ),
      );
    }

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.gym.imageUrls.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.memory(
                base64Decode(
                  widget.gym.imageUrls[index],
                ),
                width: 140,
                fit: BoxFit.cover,
      
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 140,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.error),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final heroImage =
        widget.gym.imageUrls.isNotEmpty ? widget.gym.imageUrls.first : '';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                heroImage.isNotEmpty
                    ? Image.memory(
                        base64Decode(heroImage),
                        width: double.infinity,
                        height: 320,
                        fit: BoxFit.cover,

                        errorBuilder:
                            (context, error, stackTrace) {
                          return Container(
                            width: double.infinity,
                            height: 320,
                            color: Colors.grey.shade300,
                            child: const Icon(
                              Icons.broken_image,
                              size: 80,
                            ),
                          );
                        },
                      )
                    : Container(
                        width: double.infinity,
                        height: 320,
                        color: Colors.grey.shade300,
                        child: const Icon(
                          Icons.image,
                          size: 80,
                        ),
                      ),

                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: CircleAvatar(
                      backgroundColor:
                          Colors.white.withOpacity(0.8),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  right: 16,
                  child: CircleAvatar(
                    backgroundColor:
                        Colors.white.withOpacity(0.8),
                    child: IconButton(
                      icon: Icon(
                        isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.red,
                      ),
                      onPressed: () async {
                        await _favoriteService
                            .toggleFavorite(
                          widget.gym.id,
                        );

                        setState(() {
                          isFavorite = !isFavorite;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.gym.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  _buildRatingChip(),

                  const SizedBox(height: 20),

                  _buildInfoCard(),

                  const SizedBox(height: 24),

                  const Text(
                    "Deskripsi",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    widget.gym.description,
                    style: const TextStyle(
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [

                        Row(
                          children: [
                            const Icon(Icons.access_time),
                            const SizedBox(width: 10),
                            Text(
                              "${widget.gym.openTime} - ${widget.gym.closeTime}",
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            const Icon(Icons.phone),
                            const SizedBox(width: 10),
                            Text(widget.gym.contact),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            const Icon(Icons.alternate_email),
                            const SizedBox(width: 10),
                            Text(widget.gym.instagram),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // FlutterMap nanti
                      },
                      icon: const Icon(Icons.map),
                      label: const Text(
                        "Lihat Lokasi Gym",
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    "Galeri Foto",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  _buildGallery(),

                  const SizedBox(height: 24),

                  const Text(
                    "Beri Review",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  RatingBar.builder(
                    initialRating: _rating,
                    minRating: 1,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemBuilder: (context, _) =>
                        const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (value) {
                      _rating = value;
                    },
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: _reviewController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: "Tulis review...",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 12),

                  ElevatedButton(
                    onPressed: () async {
                      if (_reviewController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Review tidak boleh kosong",
                            ),
                          ),
                        );
                        return;
                      }

                      await _reviewService.submitReview(
                        gymId: widget.gym.id,
                        rating: _rating,
                        comment:
                            _reviewController.text,
                      );

                      _reviewController.clear();

                      setState(() {
                        _rating = 5;
                      });

                      if (!mounted) return;

                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Review berhasil dikirim",
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      "Kirim Review",
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    "Review Pengguna",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),


                  const SizedBox(height: 12),

                  _buildReviews(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
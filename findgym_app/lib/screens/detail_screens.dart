import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:aplikasi_gym_palembang/Models/Gym.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreen extends StatefulWidget {
  final Gym gym;
  const DetailScreen({super.key, required this.gym});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isFavorite = false;
  bool isSignedIn = false;

  String get _favKey => 'favorite_${widget.gym.name}';

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    final prefs = await SharedPreferences.getInstance();

    final signedIn = prefs.getBool('isSignedIn') ?? false;
    final fav = prefs.getBool(_favKey) ?? false;

    if (!mounted) return;
    setState(() {
      isSignedIn = signedIn;
      isFavorite = fav;
    });
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();

    final signedIn = prefs.getBool('isSignedIn') ?? false;
    if (!signedIn) {
      if (!mounted) return;
      Navigator.pushNamed(context, '/signin').then((_) {
        _loadStatus();
      });
      return;
    }

    final newStatus = !isFavorite;
    await prefs.setBool(_favKey, newStatus);

    if (!mounted) return;
    setState(() {
      isSignedIn = true;
      isFavorite = newStatus;
    });
  }


  String _typeText() {
    final sec = (widget.gym.secondaryType ?? '').trim();
    if (sec.isEmpty) return widget.gym.type;
    return '${widget.gym.type} • $sec';
  }

  Widget _buildRatingChip() {
    final double rating = widget.gym.rating;
    final int count = widget.gym.ratingCount;

    if (rating <= 0 || count <= 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.blueGrey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blueGrey.shade100),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star_border, size: 16, color: Colors.orange),
            SizedBox(width: 6),
            Text(
              'Belum ada rating',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, size: 16, color: Colors.orange),
          const SizedBox(width: 6),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
          const SizedBox(width: 6),
          Text(
            '($count)',
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      widget.gym.imageAsset,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[100]?.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.gym.name,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: _toggleFavorite,
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : null,
                        ),
                      ),
                    ],
                  ),

                  _buildRatingChip(),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      const Icon(Icons.place, color: Colors.red),
                      const SizedBox(width: 8),
                      const SizedBox(
                        width: 70,
                        child: Text('Lokasi',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(child: Text(': ${widget.gym.location}')),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.calendar_month, color: Colors.blue),
                      const SizedBox(width: 8),
                      const SizedBox(
                        width: 70,
                        child: Text('Dibangun',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Text(': ${widget.gym.built}'),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.house, color: Colors.green),
                      const SizedBox(width: 8),
                      const SizedBox(
                        width: 70,
                        child: Text('Tipe',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(child: Text(': ${_typeText()}')),
                    ],
                  ),

                  const SizedBox(height: 16),
                  Divider(color: Colors.blueGrey.shade100),
                  const SizedBox(height: 16),

                  const Text('Deskripsi',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Text(widget.gym.description,
                      style: const TextStyle(fontSize: 14)),

                  const SizedBox(height: 16),
                  Divider(color: Colors.blueGrey.shade100),

                  const Text('Galeri',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.gym.imageUrls.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: widget.gym.imageUrls[index],
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                width: 120,
                                height: 120,
                                color: Colors.grey[50],
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text('Foto lainnya',
                      style: TextStyle(fontSize: 12, color: Colors.black54)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

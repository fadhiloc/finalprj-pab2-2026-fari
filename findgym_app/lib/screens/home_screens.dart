import 'package:flutter/material.dart';
import 'package:aplikasi_gym_palembang/data/gym_data.dart';
import 'package:aplikasi_gym_palembang/Models/Gym.dart';
import 'package:aplikasi_gym_palembang/widgets/item_card.dart';

enum GymSort {
  topRating,
  mostReviews,
  nameAZ,
  newest,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchCtrl = TextEditingController();

  String _query = '';
  String _selectedType = 'Semua';
  GymSort _sort = GymSort.topRating;

  List<String> get _types {
    final set = <String>{};

    for (final g in gymList) {
      final t1 = g.type.trim();
      if (t1.isNotEmpty) set.add(t1);

      final t2 = (g.secondaryType ?? '').trim();
      if (t2.isNotEmpty) set.add(t2);
    }

    final list = set.toList()..sort();
    return ['Semua', ...list];
  }

  List<Gym> get _filteredGyms {
    final filtered = gymList.where((g) {
      final q = _query.toLowerCase();

      final matchQuery = _query.isEmpty ||
          g.name.toLowerCase().contains(q) ||
          g.location.toLowerCase().contains(q);

      final selected = _selectedType.trim();
      final type1 = g.type.trim();
      final type2 = (g.secondaryType ?? '').trim();

      final matchType = selected == 'Semua' ||
          type1 == selected ||
          type2 == selected;

      return matchQuery && matchType;
    }).toList();

    filtered.sort((a, b) {
      switch (_sort) {
        case GymSort.topRating:
          final byRating = b.rating.compareTo(a.rating);
          if (byRating != 0) return byRating;
          return b.ratingCount.compareTo(a.ratingCount);

        case GymSort.mostReviews:
          final byCount = b.ratingCount.compareTo(a.ratingCount);
          if (byCount != 0) return byCount;
          return b.rating.compareTo(a.rating);

        case GymSort.nameAZ:
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());

        case GymSort.newest:
          final ai = int.tryParse(a.built) ?? 0;
          final bi = int.tryParse(b.built) ?? 0;
          return bi.compareTo(ai);
      }
    });

    return filtered;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  String _sortLabel(GymSort s) {
    switch (s) {
      case GymSort.topRating:
        return 'Top Rating';
      case GymSort.mostReviews:
        return 'Banyak Review';
      case GymSort.nameAZ:
        return 'Nama A-Z';
      case GymSort.newest:
        return 'Terbaru';
    }
  }

  @override
  Widget build(BuildContext context) {
    final gyms = _filteredGyms;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF1F2937),
                        Color(0xFF0F766E),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.10),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Aplikasi Gym Palembang',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'List lokasi gym yang trending di kota palembang • ${gymList.length} lokasi tersedia',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.18),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.25),
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.local_fire_department,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Rekomendasi Hari Ini',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.25),
                          ),
                        ),
                        child: const Icon(
                          Icons.fitness_center,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 14,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _types.map((t) {
                    final selected = t == _selectedType;

                    return ChoiceChip(
                      selected: selected,
                      label: Text(
                        t,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onSelected: (_) => setState(() => _selectedType = t),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: selected ? Colors.white : Colors.blueGrey[700],
                      ),
                      selectedColor: const Color(0xFF2563EB),
                      backgroundColor: Colors.white,
                      shape: StadiumBorder(
                        side: BorderSide(
                          color: selected
                              ? Colors.transparent
                              : Colors.blueGrey.withOpacity(0.15),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.sort, size: 18, color: Colors.blueGrey[700]),
                      const SizedBox(width: 8),
                      Text(
                        'Urutkan:',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Colors.blueGrey[800],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<GymSort>(
                            value: _sort,
                            isExpanded: true,
                            items: GymSort.values.map((s) {
                              return DropdownMenuItem(
                                value: s,
                                child: Text(_sortLabel(s)),
                              );
                            }).toList(),
                            onChanged: (v) {
                              if (v == null) return;
                              setState(() => _sort = v);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${gyms.length} hasil',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blueGrey[600],
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final gym = gyms[index];

                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 16,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: ItemCard(gym: gym),
                      ),
                    );
                  },
                  childCount: gyms.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.80,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

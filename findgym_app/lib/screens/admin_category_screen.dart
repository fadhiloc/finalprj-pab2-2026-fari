import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminCategoryScreen
    extends StatefulWidget {
  const AdminCategoryScreen({
    super.key,
  });

  @override
  State<AdminCategoryScreen>
      createState() =>
          _AdminCategoryScreenState();
}

class _AdminCategoryScreenState
    extends State<
        AdminCategoryScreen> {
  final TextEditingController
      _controller =
      TextEditingController();

  final FirebaseFirestore
      _firestore =
      FirebaseFirestore.instance;

  Future<void> addCategory() async {
    final name =
        _controller.text.trim();

    if (name.isEmpty) return;

    final existing =
        await _firestore
            .collection('gym_types')
            .where(
              'name',
              isEqualTo: name,
            )
            .get();

    if (existing.docs.isNotEmpty) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            'Kategori sudah ada',
          ),
        ),
      );

      return;
    }

    await _firestore
        .collection('gym_types')
        .add({
      'name': name,
      'createdAt' : FieldValue.serverTimestamp(),
    });

    _controller.clear();

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      const SnackBar(
        content: Text(
          'Kategori berhasil ditambahkan',
        ),
      ),
    );
  }

  Future<void> deleteCategory(
    String id,
  ) async {
    await _firestore
        .collection('gym_types')
        .doc(id)
        .delete();
  }

  Future<void> editCategory(
    String id,
    String oldName,
  ) async {
    final controller =
        TextEditingController(
      text: oldName,
    );

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(
            "Edit Kategori",
          ),

          content: TextField(
            controller: controller,
            decoration:
                const InputDecoration(
              border:
                  OutlineInputBorder(),
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                );
              },
              child: const Text(
                "Batal",
              ),
            ),

            ElevatedButton(
              onPressed: () async {
                await _firestore
                    .collection(
                      'gym_types',
                    )
                    .doc(id)
                    .update({
                  'name': controller
                      .text
                      .trim(),
                });

                if (!mounted) return;

                Navigator.pop(
                  context,
                );
              },
              child: const Text(
                "Simpan",
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            const Color(0xFF7C3AED),
        foregroundColor:
            Colors.white,
        title: const Text(
          "Tipe Gym",
        ),
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(16),

        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller:
                        _controller,

                    decoration:
                        const InputDecoration(
                      labelText:
                          "Kategori Baru",
                      border:
                          OutlineInputBorder(),
                    ),
                  ),
                ),

                const SizedBox(
                  width: 8,
                ),

                ElevatedButton(
                  onPressed:
                      addCategory,

                  child: const Icon(
                    Icons.add,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 20,
            ),

            Expanded(
              child:
                  StreamBuilder<
                      QuerySnapshot>(
                stream:
                    _firestore
                        .collection(
                          'gym_types',
                        )
                        .orderBy('name')
                        .snapshots(),

                builder: (
                  context,
                  snapshot,
                ) {
                  if (!snapshot
                      .hasData) {
                    return const Center(
                      child:
                          CircularProgressIndicator(),
                    );
                  }

                  final docs =
                      snapshot
                          .data!
                          .docs;

                  if (docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "Belum ada kategori",
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount:
                        docs.length,

                    itemBuilder:
                        (
                          context,
                          index,
                        ) {
                      final doc =
                          docs[index];

                      final data =
                          doc.data()
                              as Map<
                                String,
                                dynamic
                              >;

                      return Card(
                        elevation: 3,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(16),
                        ),

                        child:
                            ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                const Color(0xFFEDE9FE),
                            child: const Icon(
                              Icons.fitness_center,
                              color: Color(0xFF7C3AED),
                            ),
                          ),

                          title: Text(
                            data['name'] ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          trailing:
                              Row(
                            mainAxisSize:
                                MainAxisSize
                                    .min,

                            children: [
                              IconButton(
                                icon:
                                    const Icon(
                                  Icons
                                      .edit,
                                  color: const Color(0xFF7C3AED)
                                ),

                                onPressed:
                                    () {
                                  editCategory(
                                    doc.id,
                                    data['name'],
                                  );
                                },
                              ),

                              IconButton(
                                icon:
                                    const Icon(
                                  Icons
                                      .delete,
                                  color:
                                      Colors.red,
                                ),

                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text(
                                        'Hapus Kategori',
                                      ),
                                      content: Text(
                                        'Yakin ingin menghapus kategori ${data['name']}?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(
                                                context,
                                                false,
                                              ),
                                          child: const Text(
                                            'Batal',
                                          ),
                                        ),

                                        ElevatedButton(
                                          style:
                                              ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.red,
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(
                                                context,
                                                true,
                                              ),
                                          child: const Text(
                                            'Hapus',
                                          ),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirm == true) {
                                    deleteCategory(doc.id);
                                  }

                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
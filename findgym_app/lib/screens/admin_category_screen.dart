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

    await _firestore
        .collection('gym_types')
        .add({
      'name': name,
    });

    _controller.clear();
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
        title: const Text(
          "Kelola Kategori Gym",
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
                        child:
                            ListTile(
                          title: Text(
                            data['name'] ??
                                '',
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
                                  color:
                                      Colors.orange,
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

                                onPressed:
                                    () {
                                  deleteCategory(
                                    doc.id,
                                  );
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
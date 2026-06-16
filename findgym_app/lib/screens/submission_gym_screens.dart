import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'map_picker.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:typed_data';
import '../services/notification_service.dart';


class SubmissionGymScreen extends StatefulWidget {
  const SubmissionGymScreen({super.key});

  @override
  State<SubmissionGymScreen> createState() =>
      _SubmissionGymScreenState();
}

class _SubmissionGymScreenState
    extends State<SubmissionGymScreen> {

    final NotificationService _notificationService =
      NotificationService();


    List<String> selectedImages = [];
      
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController =
      TextEditingController();

  final TextEditingController
      _locationController =
      TextEditingController();

  final TextEditingController
      _descriptionController =
      TextEditingController();

  LatLng? selectedLocation;

  List<String> gymTypes = [];

  List<String> selectedTypes = [];

  TimeOfDay? openTime;
  TimeOfDay? closeTime;

  final TextEditingController
    _contactController =
        TextEditingController();

  final TextEditingController
    _instagramController =
        TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadGymTypes();
  }

  Future<void> loadGymTypes() async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('gym_types')
            .orderBy('name')
            .get();

    setState(() {
      gymTypes =
          snapshot.docs.map((e) {
        return e['name'] as String;
      }).toList();
    });
  }

  Future<void> pickLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const MapPickerScreen(),
      ),
    );

    if (result != null &&
        result is LatLng) {
      setState(() {
        selectedLocation = result;
      });
    }
  }

  Future<void> pickOpenTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime:
          openTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        openTime = picked;
      });
    }
  }

  Future<void> pickCloseTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime:
          closeTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        closeTime = picked;
      });
    }
  }

  Future<void> pickImages() async {
  final picker = ImagePicker();

  final images =
      await picker.pickMultiImage();

  if (images.isNotEmpty) {
      List<String> temp = [];

      for (var image in images) {
        final bytes =
            await image.readAsBytes();

        temp.add(
          base64Encode(bytes),
        );
      }

      setState(() {
        selectedImages = temp;
      });
    }
  }

  Future<void> submitGym() async {

    if (selectedImages.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Minimal 1 foto gym',
          ),
        ),
      );
      return;
    }

    if (!_formKey.currentState!
        .validate()) {
      return;
    }

    if (selectedLocation == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
              Text('Pilih lokasi gym'),
        ),
      );
      return;
    }

    if (selectedTypes.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Pilih minimal satu kategori',
          ),
        ),
      );
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      final user =
          FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance
          .collection('gyms')
          .add({
            
        'name':
            _nameController.text.trim(),

        'location':
            _locationController.text
                .trim(),

        'description':
            _descriptionController.text
                .trim(),

        'latitude':
            selectedLocation!.latitude,

        'longitude':
            selectedLocation!.longitude,

        'types': selectedTypes,

        'imageUrls': selectedImages,

        'openTime':
            openTime == null
                ? ''
                : openTime!.format(context),

        'closeTime':
            closeTime == null
                ? ''
                : closeTime!.format(context),

        'contact':
            _contactController.text.trim(),

        'instagram':
            _instagramController.text.trim(),

        'rating': 0.0,

        'ratingCount': 0,

        'submittedBy':
            user?.uid,

        'ownerId': FirebaseAuth.instance.currentUser!.uid,

        'status': 'pending',

        'createdAt':
            FieldValue.serverTimestamp(),


      });
      await _notificationService.createNotification(
        userId: 'phUPkGNvxdhqhLJQg0VayLmS2k63', // UID admin
        title: 'Pengajuan Gym Baru',
        body:
            '${_nameController.text} menunggu approval.',
        type: 'submit',
      );

      await _notificationService.createNotification(
        userId: user!.uid,
        title: 'Pengajuan Dikirim',
        body:
            'Gym Anda sedang menunggu persetujuan admin.',
        type: 'submit',
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Gym berhasil dikirim dan menunggu persetujuan admin',
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Error: $e',
          ),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _contactController.dispose();
    _instagramController.dispose();

    super.dispose();
  }

  @override
  Widget build(
      BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Submit Gym"),
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(16),

        child: Form(
          key: _formKey,

          child: Column(
            children: [
              TextFormField(
                controller:
                    _nameController,
                decoration:
                    const InputDecoration(
                  labelText:
                      "Nama Gym",
                  border:
                      OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty) {
                    return 'Nama gym wajib diisi';
                  }
                  return null;
                },
              ),

              const SizedBox(
                  height: 16),

              TextFormField(
                controller:
                    _locationController,
                decoration:
                    const InputDecoration(
                  labelText:
                      "Alamat Gym",
                  border:
                      OutlineInputBorder(),
                ),
              ),

              const SizedBox(
                  height: 16),

              Align(
                alignment:
                    Alignment.centerLeft,
                child: Text(
                  "Kategori Gym",
                  style:
                      Theme.of(context)
                          .textTheme
                          .titleMedium,
                ),
              ),

              const SizedBox(
                  height: 10),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    gymTypes.map((type) {
                  return FilterChip(
                    label:
                        Text(type),

                    selected:
                        selectedTypes
                            .contains(
                      type,
                    ),

                    selectedColor: const Color(0xFFD8B4FE),

                    side: BorderSide(
                      color: Colors.grey.shade300,
                    ),

                    onSelected:
                        (selected) {
                      setState(() {
                        if (selected && !selectedTypes.contains(type)) {
                          selectedTypes.add(type);
                        } else {
                          selectedTypes
                              .remove(
                                  type);
                        }
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(
                  height: 16),

              TextFormField(
                controller:
                    _descriptionController,
                maxLines: 4,
                decoration:
                    const InputDecoration(
                  labelText:
                      "Deskripsi",
                  border:
                      OutlineInputBorder(),
                ),
              ),

              const SizedBox(
                  height: 20),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: pickOpenTime,
                      icon: const Icon(
                        Icons.access_time,
                      ),
                      label: Text(
                        openTime == null
                            ? 'Jam Buka'
                            : openTime!.format(
                                context,
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: pickCloseTime,
                      icon: const Icon(
                        Icons.timer_off,
                      ),
                      label: Text(
                        closeTime == null
                            ? 'Jam Tutup'
                            : closeTime!.format(
                                context,
                              ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: _contactController,
                keyboardType:
                    TextInputType.phone,
                decoration:
                    const InputDecoration(
                  labelText: "Kontak Gym",
                  hintText: "08xxxxxxxxxx",
                  border:
                      OutlineInputBorder(),
                  prefixIcon:
                      Icon(Icons.phone),
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _instagramController,
                decoration: const InputDecoration(
                  labelText: "Instagram",
                  hintText: "@namagym",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.alternate_email),
                ),
              ),

              SizedBox(
                width:
                    double.infinity,
                child:
                    ElevatedButton.icon(
                  onPressed:
                      pickLocation,
                  icon:
                      const Icon(
                    Icons.map,
                  ),
                  label: Text(
                    selectedLocation ==
                            null
                        ? "Pilih Lokasi"
                        : "Lokasi Dipilih",
                  ),
                ),
              ),

              if (selectedLocation !=
                  null)
                Padding(
                  padding:
                      const EdgeInsets.only(
                    top: 12,
                  ),
                  child: Text(
                    "Lat: ${selectedLocation!.latitude}\nLng: ${selectedLocation!.longitude}",
                    textAlign:
                        TextAlign.center,
                  ),
                ),
        
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: pickImages,
                  icon: const Icon(
                    Icons.photo_library,
                  ),
                  label: const Text(
                    'Pilih Foto Gym',
                  ),
                ),
              ),
              if (selectedImages.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(
                    top: 12,
                  ),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        selectedImages.map(
                      (image) {
                        return ClipRRect(
                          borderRadius:
                              BorderRadius.circular(
                            12,
                          ),
                          child: Image.memory(
                            base64Decode(image),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),

              const SizedBox(
                  height: 20),

              SizedBox(
                width:
                    double.infinity,
                child:
                    ElevatedButton.icon(
                  onPressed:
                      isLoading
                          ? null
                          : submitGym,
                  icon:
                      const Icon(
                    Icons.send,
                  ),
                  label: isLoading
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                      : const Text(
                          "Kirim Gym",
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
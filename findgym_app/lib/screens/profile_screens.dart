import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {
  bool isSignedIn = false;

  String fullName = '-';
  String email = '-';
  String role = 'user';

  int favoriteGymCount = 0;

  String? _avatarBase64;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) {
      if (!mounted) return;

      setState(() {
        isSignedIn = false;
        fullName = '-';
        email = '-';
        role = 'user';
      });

      return;
    }

    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      final data = doc.data();

      if (!mounted) return;

      setState(() {
        isSignedIn = true;

        fullName =
            data?['name'] ?? 'No Name';

        email =
            data?['email'] ??
            user.email ??
            '-';

        role =
            data?['role'] ?? 'user';
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _pickImage() async {
    if (!isSignedIn) return;

    final picker = ImagePicker();

    final XFile? image =
        await picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 60,
        );

    if (image == null) return;

    final bytes =
        await image.readAsBytes();

    if (!mounted) return;

    setState(() {
      _avatarBase64 =
          base64Encode(bytes);
    });

    // Nanti bisa disimpan ke Firebase Storage
  }

  void _goSignIn() {
    Navigator.pushNamed(
      context,
      '/signin',
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance
        .signOut();

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/signin',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPadding =
        MediaQuery.of(
          context,
        ).padding.top;

    return Scaffold(
      backgroundColor:
          const Color(0xFFF6F7FB),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: topPadding + 18,
                bottom: 22,
              ),
              decoration:
                  const BoxDecoration(
                    gradient:
                        LinearGradient(
                          colors: [
                            Color(
                              0xFF1E88E5,
                            ),
                            Color(
                              0xFF42A5F5,
                            ),
                          ],
                          begin:
                              Alignment
                                  .topLeft,
                          end:
                              Alignment
                                  .bottomRight,
                        ),
                    borderRadius:
                        BorderRadius.only(
                          bottomLeft:
                              Radius.circular(
                                26,
                              ),
                          bottomRight:
                              Radius.circular(
                                26,
                              ),
                        ),
                  ),

              child: Column(
                children: [
                  const Text(
                    'Profile',
                    style: TextStyle(
                      color:
                          Colors.white,
                      fontSize: 18,
                      fontWeight:
                          FontWeight
                              .w700,
                    ),
                  ),

                  const SizedBox(
                    height: 14,
                  ),

                  Stack(
                    alignment:
                        Alignment
                            .bottomRight,

                    children: [
                      Container(
                        padding:
                            const EdgeInsets.all(
                              3,
                            ),
                        decoration:
                            BoxDecoration(
                              color: Colors
                                  .white,
                              shape:
                                  BoxShape
                                      .circle,
                            ),
                        child:
                            CircleAvatar(
                              radius: 44,
                              backgroundColor:
                                  Colors
                                      .grey
                                      .shade200,

                              backgroundImage:
                                  _avatarBase64 !=
                                          null
                                      ? MemoryImage(
                                          base64Decode(
                                            _avatarBase64!,
                                          ),
                                        )
                                      : null,

                              child:
                                  _avatarBase64 ==
                                          null
                                      ? const Icon(
                                          Icons
                                              .person,
                                          size:
                                              45,
                                        )
                                      : null,
                            ),
                      ),

                      if (isSignedIn)
                        InkWell(
                          onTap:
                              _pickImage,

                          child:
                              Container(
                                padding:
                                    const EdgeInsets.all(
                                      8,
                                    ),
                                decoration:
                                    const BoxDecoration(
                                      color:
                                          Colors
                                              .white,
                                      shape:
                                          BoxShape
                                              .circle,
                                    ),
                                child:
                                    const Icon(
                                      Icons
                                          .camera_alt,
                                      size:
                                          18,
                                    ),
                              ),
                        ),
                    ],
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  Text(
                    isSignedIn
                        ? fullName
                        : 'Guest',

                    style:
                        const TextStyle(
                          color:
                              Colors
                                  .white,
                          fontSize: 18,
                          fontWeight:
                              FontWeight
                                  .w800,
                        ),
                  ),

                  const SizedBox(
                    height: 4,
                  ),

                  Text(
                    isSignedIn
                        ? '$email • $role'
                        : 'Silakan login',

                    style: TextStyle(
                      color: Colors
                          .white
                          .withOpacity(
                            0.9,
                          ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            Padding(
              padding:
                  const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),

              child: Column(
                children: [
                  _InfoCard(
                    icon:
                        Icons.person,
                    iconColor:
                        Colors.orange,
                    title:
                        'Nama',
                    value:
                        fullName,
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  _InfoCard(
                    icon:
                        Icons.email,
                    iconColor:
                        Colors.blue,
                    title:
                        'Email',
                    value:
                        email,
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  _InfoCard(
                    icon:
                        Icons.admin_panel_settings,
                    iconColor:
                        Colors.green,
                    title:
                        'Role',
                    value:
                        role,
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  
                  if (isSignedIn && role == 'admin') ...[
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/adminapproval',
                          );
                        },
                        icon: const Icon(
                          Icons.admin_panel_settings,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Kelola Pengajuan Gym',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),
                  ],

                  SizedBox(
                    width:
                        double.infinity,
                    height: 48,

                    child:
                        ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(
                                backgroundColor:
                                    isSignedIn
                                        ? Colors
                                            .red
                                        : Colors
                                            .blue,
                              ),

                          onPressed:
                              isSignedIn
                                  ? _signOut
                                  : _goSignIn,

                          child: Text(
                            isSignedIn
                                ? 'Sign Out'
                                : 'Sign In',

                            style:
                                const TextStyle(
                                  color:
                                      Colors
                                          .white,
                                ),
                          ),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
              16,
            ),

        boxShadow: const [
          BoxShadow(
            blurRadius: 14,
            color: Color(
              0x12000000,
            ),
            offset: Offset(
              0,
              8,
            ),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,

            decoration:
                BoxDecoration(
                  color: iconColor
                      .withOpacity(
                        0.12,
                      ),

                  borderRadius:
                      BorderRadius.circular(
                        12,
                      ),
                ),

            child: Icon(
              icon,
              color:
                  iconColor,
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          Expanded(
            child: Text(
              title,

              style:
                  const TextStyle(
                    fontWeight:
                        FontWeight
                            .w700,
                  ),
            ),
          ),

          Flexible(
            child: Text(
              value,
              overflow:
                  TextOverflow
                      .ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:image_picker/image_picker.dart';

import 'package:aplikasi_gym_palembang/data/gym_data.dart';
import 'package:aplikasi_gym_palembang/screens/signIn_screens.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isSignedIn = false;
  String fullName = '-';
  String userName = '-';
  int favoriteGymCount = 0;

  // avatar base64 (disimpan di SharedPreferences)
  String? _avatarBase64;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    final signedIn = prefs.getBool('isSignedIn') ?? false;

    String decryptedFullName = '-';
    String decryptedUserName = '-';

    // ambil avatar
    final avatar = prefs.getString('avatarBase64');

    // hitung favorit pakai sistem yang kamu pakai di DetailScreen:
    // key = favorite_<gym.name>
    final favCount = gymList.where((gym) {
      final key = 'favorite_${gym.name}';
      return prefs.getBool(key) ?? false;
    }).length;

    if (signedIn) {
      // decrypt aman (tidak crash kalau data belum lengkap)
      final encryptedFullName = prefs.getString('fullname') ?? '';
      final encryptedUserName = prefs.getString('username') ?? '';
      final keyString = prefs.getString('key') ?? '';
      final ivString = prefs.getString('iv') ?? '';

      if (encryptedFullName.isNotEmpty &&
          encryptedUserName.isNotEmpty &&
          keyString.isNotEmpty &&
          ivString.isNotEmpty) {
        try {
          final key = encrypt.Key.fromBase64(keyString);
          final iv = encrypt.IV.fromBase64(ivString);
          final encrypter = encrypt.Encrypter(encrypt.AES(key));

          decryptedFullName = encrypter.decrypt64(encryptedFullName, iv: iv);
          decryptedUserName = encrypter.decrypt64(encryptedUserName, iv: iv);
        } catch (_) {
          // kalau ada mismatch key/iv/format, jangan crash
          decryptedFullName = '-';
          decryptedUserName = '-';
        }
      }
    }

    if (!mounted) return;
    setState(() {
      isSignedIn = signedIn;
      fullName = signedIn ? decryptedFullName : '-';
      userName = signedIn ? decryptedUserName : '-';
      favoriteGymCount = favCount;
      _avatarBase64 = avatar;
    });
  }

  Future<void> _pickImage() async {
    if (!isSignedIn) return;

    final picker = ImagePicker();

    // Lebih aman untuk banyak device: gallery (camera kadang bermasalah di web)
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 60, // kompres agar ringan
    );

    if (image == null) return;

    final bytes = await image.readAsBytes();
    final b64 = base64Encode(bytes);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('avatarBase64', b64);

    if (!mounted) return;
    setState(() {
      _avatarBase64 = b64;
    });
  }

  void _goSignIn() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SignInScreen()),
    );
    // setelah balik, reload status
    _loadProfile();
  }

  Future<void> _signOut() async {
    final prefs = await SharedPreferences.getInstance();

    // ⚠️ Jangan prefs.clear() karena itu akan menghapus akun & favorit juga.
    // Logout cukup hapus status login saja.
    await prefs.setBool('isSignedIn', false);

    if (!mounted) return;
    setState(() {
      isSignedIn = false;
      fullName = '-';
      userName = '-';
      _avatarBase64 = null;
      // favorite tetap disimpan (supaya user tidak hilang favoritnya)
    });

    _loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ===== HEADER BERWARNA =====
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: topPadding + 18, bottom: 22),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(26),
                  bottomRight: Radius.circular(26),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // ===== AVATAR =====
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 44,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: _avatarBase64 != null
                              ? MemoryImage(base64Decode(_avatarBase64!))
                              : const AssetImage('images/placeholder_image.png')
                                  as ImageProvider,
                        ),
                      ),
                      if (isSignedIn)
                        InkWell(
                          onTap: _pickImage,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 10,
                                  color: Colors.black12,
                                )
                              ],
                            ),
                            child: const Icon(Icons.camera_alt, size: 18),
                          ),
                        )
                    ],
                  ),

                  const SizedBox(height: 10),

                  Text(
                    isSignedIn ? fullName : 'Guest',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isSignedIn ? '@$userName' : 'Silakan login untuk akses fitur',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ===== CARD INFO =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _InfoCard(
                    icon: Icons.person,
                    iconColor: Colors.orange,
                    title: 'Nama',
                    value: fullName,
                  ),
                  const SizedBox(height: 12),
                  _InfoCard(
                    icon: Icons.lock,
                    iconColor: Colors.blueAccent,
                    title: 'Pengguna',
                    value: userName,
                  ),
                  const SizedBox(height: 12),

                  // favorit count
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 14,
                          color: Color(0x12000000),
                          offset: Offset(0, 8),
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE8EC),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.favorite, color: Colors.red),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Total Favorit',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          '$favoriteGymCount',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ===== BUTTON LOGIN / LOGOUT =====
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isSignedIn ? const Color(0xFFE53935) : const Color(0xFF1E88E5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      onPressed: isSignedIn ? _signOut : _goSignIn,
                      child: Text(
                        isSignedIn ? 'Sign Out' : 'Sign In',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            blurRadius: 14,
            color: Color(0x12000000),
            offset: Offset(0, 8),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

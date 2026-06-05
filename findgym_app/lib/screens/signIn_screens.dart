import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _errorText = '';
  bool _obscurePassword = true;

  Future<Map<String, String>?> _retrieveAndDecrypt() async {
    final prefs = await SharedPreferences.getInstance();

    final encryptedUsername = prefs.getString('username') ?? '';
    final encryptedPassword = prefs.getString('password') ?? '';
    final keyString = prefs.getString('key') ?? '';
    final ivString = prefs.getString('iv') ?? '';

    if (encryptedUsername.isEmpty ||
        encryptedPassword.isEmpty ||
        keyString.isEmpty ||
        ivString.isEmpty) {
      return null;
    }

    try {
      final key = encrypt.Key.fromBase64(keyString);
      final iv = encrypt.IV.fromBase64(ivString);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));

      final decryptedUsername =
          encrypter.decrypt64(encryptedUsername, iv: iv);
      final decryptedPassword =
          encrypter.decrypt64(encryptedPassword, iv: iv);

      return {'username': decryptedUsername, 'password': decryptedPassword};
    } catch (e) {
      return null;
    }
  }

  Future<void> signIn() async {
    final prefs = await SharedPreferences.getInstance();

    final enteredUsername = _usernameController.text.trim();
    final enteredPassword = _passwordController.text.trim();

    final decryptedData = await _retrieveAndDecrypt();

    if (decryptedData == null) {
      setState(() {
        _errorText = 'Data akun tidak ditemukan/korup. Silakan Sign Up ulang.';
      });
      return;
    }

    final savedUsername = decryptedData['username'] ?? '';
    final savedPassword = decryptedData['password'] ?? '';

    if (enteredUsername == savedUsername && enteredPassword == savedPassword) {
      await prefs.setBool('isSignedIn', true);

      await prefs.setString('currentUser', savedUsername);

      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } else {
      setState(() {
        _errorText = 'Nama pengguna atau kata sandi salah.';
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: "Nama Pengguna",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: "Kata Sandi",
                    errorText: _errorText.isNotEmpty ? _errorText : null,
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() {
                        _obscurePassword = !_obscurePassword;
                      }),
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                  ),
                  obscureText: _obscurePassword,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: signIn,
                  child: const Text('Sign In'),
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    text: 'Belum punya akun? ',
                    style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
                    children: [
                      TextSpan(
                        text: 'Daftar di sini.',
                        style: const TextStyle(
                          color: Colors.grey,
                          decoration: TextDecoration.underline,
                          fontSize: 16,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, '/signup');
                          },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() =>
      _SignInScreenState();
}

class _SignInScreenState
    extends State<SignInScreen> {
  final AuthService _authService =
      AuthService();

  final TextEditingController
      _usernameController =
      TextEditingController();

  final TextEditingController
      _passwordController =
      TextEditingController();

  bool _obscurePassword = true;

  bool _isLoading = false;

  String _errorText = '';

  Future<void> signIn() async {
    final email =
        _usernameController.text.trim();

    final password =
        _passwordController.text.trim();

    if (email.isEmpty ||
        password.isEmpty) {
      setState(() {
        _errorText =
            'Email dan password wajib diisi';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = '';
    });

    try {
      await _authService.signIn(
        email: email,
        password: password,
      );

      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/',
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorText =
            e.message ??
            'Login gagal';
      });
    } catch (e) {
      setState(() {
        _errorText =
            'Terjadi kesalahan';
      });
    }

    setState(() {
      _isLoading = false;
    });
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
      appBar: AppBar(
        title: const Text(
          'Sign In',
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  controller:
                      _usernameController,
                  decoration:
                      const InputDecoration(
                    labelText: "Email",
                    border:
                        OutlineInputBorder(),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                TextFormField(
                  controller:
                      _passwordController,
                  obscureText:
                      _obscurePassword,
                  decoration:
                      InputDecoration(
                    labelText:
                        "Password",
                    border:
                        const OutlineInputBorder(),
                    errorText:
                        _errorText
                                .isNotEmpty
                            ? _errorText
                            : null,
                    suffixIcon:
                        IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword =
                              !_obscurePassword;
                        });
                      },
                      icon: Icon(
                        _obscurePassword
                            ? Icons
                                .visibility_off
                            : Icons
                                .visibility,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                SizedBox(
                  width:
                      double.infinity,
                  child:
                      ElevatedButton(
                    onPressed:
                        _isLoading
                            ? null
                            : signIn,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            'Sign In',
                          ),
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                RichText(
                  text: TextSpan(
                    text:
                        'Belum punya akun? ',
                    style:
                        const TextStyle(
                      color:
                          Colors.black87,
                      fontSize: 16,
                    ),
                    children: [
                      TextSpan(
                        text:
                            'Daftar di sini',
                        style:
                            const TextStyle(
                          color:
                              Colors.blue,
                          decoration:
                              TextDecoration
                                  .underline,
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(
                                  context,
                                  '/signup',
                                );
                              },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
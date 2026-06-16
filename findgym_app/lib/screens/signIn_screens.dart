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
            e.message ?? 'Login gagal';
      });
    } catch (e) {
      setState(() {
        _errorText =
            'Terjadi kesalahan';
      });
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
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
      body: Container(
        width: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF7C3AED),
              Color(0xFFF5F3FF),
            ],
          ),
        ),

        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.all(24),

              child: Card(
                elevation: 10,

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    24,
                  ),
                ),

                child: Padding(
                  padding:
                      const EdgeInsets.all(
                    24,
                  ),

                  child: Column(
                    mainAxisSize:
                        MainAxisSize.min,

                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor:
                            Color(
                          0xFF7C3AED,
                        ),

                        child: Icon(
                          Icons
                              .fitness_center,
                          size: 40,
                          color:
                              Colors.white,
                        ),
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      const Text(
                        'FindMyGym',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight:
                              FontWeight.bold,
                          color: Color(
                            0xFF7C3AED,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      const Text(
                        'Temukan gym terbaik di kota Anda',
                        textAlign:
                            TextAlign.center,
                        style: TextStyle(
                          color:
                              Colors.grey,
                        ),
                      ),

                      const SizedBox(
                        height: 30,
                      ),

                      TextFormField(
                        controller:
                            _usernameController,

                        decoration:
                            const InputDecoration(
                          labelText:
                              'Email',
                          prefixIcon:
                              Icon(
                            Icons.email,
                          ),
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
                              'Password',

                          prefixIcon:
                              const Icon(
                            Icons.lock,
                          ),

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
                        height: 24,
                      ),

                      SizedBox(
                        width:
                            double.infinity,
                        height: 50,

                        child:
                            ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(
                              0xFF7C3AED,
                            ),

                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                15,
                              ),
                            ),
                          ),

                          onPressed:
                              _isLoading
                                  ? null
                                  : signIn,

                          child:
                              _isLoading
                                  ? const CircularProgressIndicator(
                                      color:
                                          Colors.white,
                                    )
                                  : const Text(
                                      'Sign In',
                                      style:
                                          TextStyle(
                                        color:
                                            Colors.white,
                                        fontSize:
                                            16,
                                      ),
                                    ),
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      RichText(
                        text: TextSpan(
                          text:
                              'Belum punya akun? ',

                          style:
                              const TextStyle(
                            color:
                                Colors.black87,
                            fontSize: 15,
                          ),

                          children: [
                            TextSpan(
                              text:
                                  'Daftar di sini',

                              style:
                                  const TextStyle(
                                color:
                                    Color(
                                  0xFF7C3AED,
                                ),

                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),

                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap =
                                        () {
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
          ),
        ),
      ),
    );
  }
}
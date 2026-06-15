import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() =>
      _SignUpScreenState();
}

class _SignUpScreenState
    extends State<SignUpScreen> {
  final AuthService _authService =
      AuthService();

  final TextEditingController
      _fullnameController =
      TextEditingController();

  final TextEditingController
      _usernameController =
      TextEditingController();

  final TextEditingController
      _passwordController =
      TextEditingController();

  bool _obscurePassword = true;

  String _errorText = '';

  bool _isLoading = false;

  bool _isValidPassword(
    String password,
  ) {
    return password.length >= 6;
  }

  Future<void> _signUp() async {
    final fullName =
        _fullnameController.text.trim();

    final email =
        _usernameController.text.trim();

    final password =
        _passwordController.text.trim();

    if (fullName.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      setState(() {
        _errorText =
            'Semua field wajib diisi';
      });
      return;
    }

    if (!_isValidPassword(password)) {
      setState(() {
        _errorText =
            'Password minimal 6 karakter';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = '';
    });

    try {
      await _authService.signUp(
        fullName: fullName,
        email: email,
        password: password,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Registrasi berhasil',
          ),
        ),
      );

      Navigator.pushReplacementNamed(
        context,
        '/signin',
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorText =
            e.message ??
            'Terjadi kesalahan';
      });
    } catch (e) {
      setState(() {
        _errorText = e.toString();
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 30),

              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blueGrey,
                child: const Icon(
                  Icons.fitness_center,
                  color: Colors.white,
                  size: 50,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Aplikasi Gym Palembang",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Buat akun baru",
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 30),

              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20),
                ),

                child: Padding(
                  padding:
                      const EdgeInsets.all(20),

                  child: Column(
                    children: [

                      TextField(
                        controller:
                            _fullnameController,

                        decoration:
                            InputDecoration(
                          labelText:
                              "Nama Lengkap",

                          prefixIcon:
                              const Icon(
                            Icons.person,
                          ),

                          border:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(
                                    12),
                          ),
                        ),
                      ),

                      const SizedBox(
                          height: 16),

                      TextField(
                        controller:
                            _usernameController,

                        decoration:
                            InputDecoration(
                          labelText:
                              "Email",

                          prefixIcon:
                              const Icon(
                            Icons.email,
                          ),

                          border:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(
                                    12),
                          ),
                        ),
                      ),

                      const SizedBox(
                          height: 16),

                      TextField(
                        controller:
                            _passwordController,

                        obscureText:
                            _obscurePassword,

                        decoration:
                            InputDecoration(
                          labelText:
                              "Password",

                          prefixIcon:
                              const Icon(
                            Icons.lock,
                          ),

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
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),

                          border:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(
                                    12),
                          ),
                        ),
                      ),

                      if (_errorText
                          .isNotEmpty)
                        Padding(
                          padding:
                              const EdgeInsets.only(
                                  top: 10),
                          child: Text(
                            _errorText,
                            style:
                                const TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),

                      const SizedBox(
                          height: 24),

                      SizedBox(
                        width:
                            double.infinity,

                        height: 50,

                        child:
                            ElevatedButton(
                          onPressed:
                              _isLoading
                                  ? null
                                  : _signUp,

                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.blueGrey,

                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                      12),
                            ),
                          ),

                          child:
                              _isLoading
                                  ? const CircularProgressIndicator(
                                      color:
                                          Colors.white,
                                    )
                                  : const Text(
                                      "Sign Up",
                                      style:
                                          TextStyle(
                                        color:
                                            Colors
                                                .white,
                                        fontSize:
                                            16,
                                      ),
                                    ),
                        ),
                      ),

                      const SizedBox(
                          height: 16),

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .center,

                        children: [
                          const Text(
                            "Sudah punya akun?",
                          ),

                          TextButton(
                            onPressed: () {
                              Navigator.pop(
                                  context);
                            },

                            child:
                                const Text(
                              "Sign In",
                            ),
                          ),
                        ],
                      ),
                    ],
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
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:heylex/core/theme/theme_constants.dart';
import 'package:heylex/features/auth/components/auth_button.dart';
import 'package:heylex/features/auth/components/auth_textfield.dart';
import 'package:heylex/features/auth/service/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    // Validate inputs
    if (_emailController.text.trim().isEmpty) {
      _showError("Lütfen email adresinizi girin");
      return;
    }

    if (_passwordController.text.isEmpty) {
      _showError("Lütfen şifrenizi girin");
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showError("Şifreler eşleşmiyor");
      return;
    }

    if (_passwordController.text.length < 6) {
      _showError("Şifre en az 6 karakter olmalıdır");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _authService.signUpWithEmailPassword(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (response.user != null) {
          _showSuccess("Kayıt başarılı! Email adresinizi kontrol edin.");
          Navigator.pop(context);
        } else {
          _showError("Kayıt başarısız oldu");
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showError("Hata: ${e.toString()}");
        log("Hata kayıt olurken: $e");
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: ThemeConstants.darkGreyColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.chevron_left),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  SizedBox(
                    width: 160,
                    child: Image.asset('assets/images/logo.png'),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "HeyLex",
                    style: TextStyle(
                      fontFamily: 'OpenDyslexic',
                      color: ThemeConstants.creamColor,
                      fontSize: 26,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: AuthTextfield(
                      hintText: "Email",
                      prefixIcon: Icons.email,
                      controller: _emailController,
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: AuthTextfield(
                      hintText: "Şifre",
                      prefixIcon: Icons.lock,
                      controller: _passwordController,
                      obscureText: true,
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: AuthTextfield(
                      hintText: "Şifreni Onayla",
                      prefixIcon: Icons.lock,
                      controller: _confirmPasswordController,
                      obscureText: true,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: AuthButton(
                  label: _isLoading ? "Kayıt Olunuyor..." : "Kayıt Ol",
                  onPressed: _isLoading ? null : _handleRegister,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

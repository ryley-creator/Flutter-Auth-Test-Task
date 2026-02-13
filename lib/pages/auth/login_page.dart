import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:task/pages/auth/confirm_page.dart';
import 'package:task/pages/auth/widgets/auth_textfield.dart';
import 'package:task/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final AuthService authService = AuthService();
  bool isLoading = false;

  Future<void> sendCode() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      showError('Please provide email!');
      return;
    }
    if (!authService.isValidEmail(email)) {
      showError('Email format is not valid please try again');
      return;
    }
    try {
      setState(() => isLoading = true);
      await authService.sendCode(email);
      setState(() => isLoading = false);
      if (!mounted) return;
      showSuccess('Verification code has been sent to your email!');
      Navigator.push(context, MaterialPageRoute(builder: (context) => ConfirmPage(email: email)));
    } catch (error) {
      setState(() => isLoading = false);
      String errorMessage = 'Email is wrong';
      if (error is DioException) {
        final data = error.response?.data;
        if (data != null && data['error'] != null) {
          errorMessage = data['error'];
        }
      }
      showError(errorMessage);
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
  }

  void showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.green));
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(Icons.lock_outline, size: 80, color: Colors.green.shade700),
                SizedBox(height: 24),
                Text(
                  'Verify',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Enter email to get verification code',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                AuthTextfield(
                  fontSize: 15,
                  textAlign: TextAlign.left,
                  hintText: 'exmaple@gmail.com',
                  controller: emailController,
                  isLoading: isLoading,
                  sendCode: sendCode,
                  buttonText: 'Get Code',
                  labelText: 'Email',
                  textInputType: TextInputType.emailAddress,
                  icon: Icons.email,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

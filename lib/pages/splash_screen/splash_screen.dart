import 'package:flutter/material.dart';
import 'package:task/pages/auth/login_page.dart';
import 'package:task/pages/home/home_page.dart';
import 'package:task/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      final userId = await authService.getValidUserId();
      if (!mounted) return;
      if (userId != null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen(userId: userId)));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: CircularProgressIndicator(color: Colors.green.shade700)),
    );
  }
}

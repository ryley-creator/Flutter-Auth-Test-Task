import 'package:flutter/material.dart';
import 'package:task/pages/auth/login_page.dart';
import 'package:task/services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  final String userId;

  HomeScreen({super.key, required this.userId});

  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Home Page'), backgroundColor: Colors.white),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              SizedBox(height: 40),
              Text('Authorized!', style: TextStyle(fontSize: 25)),
              SizedBox(height: 40),
              Text('User ID:', style: TextStyle(fontSize: 25)),
              Text(userId, style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
              SizedBox(height: 100),
              TextButton(
                onPressed: () async {
                  await authService.logout();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                },
                child: Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

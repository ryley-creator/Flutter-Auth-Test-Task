import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final storage = const FlutterSecureStorage();

  Future<void> saveTokens(Map<String, dynamic> tokens) async {
    if (tokens['jwt'] != null) {
      await storage.write(key: 'jwt', value: tokens['jwt']);
    }
    if (tokens['refresh_token'] != null) {
      await storage.write(key: 'refresh_token', value: tokens['refresh_token']);
    }
  }

  Future<String?> getJwt() async {
    return await storage.read(key: 'jwt');
  }

  Future<void> saveRefreshToken(String token) async {
    await storage.write(key: 'refresh_token', value: token);
  }

  Future<String?> getRefreshToken() async {
    return await storage.read(key: 'refresh_token');
  }

  Future<void> clear() async {
    await storage.deleteAll();
  }
}

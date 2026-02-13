import 'package:dio/dio.dart';
import 'package:task/services/token_storage.dart';

class AuthService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://d5dsstfjsletfcftjn3b.apigw.yandexcloud.net",
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
    ),
  );
  final TokenStorage tokenStorage = TokenStorage();

  bool isValidEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  Future<void> sendCode(String email) async {
    await dio.post('/login', data: {'email': email});
  }

  Future<Map<String, dynamic>> confirmCode(String email, String code) async {
    final response = await dio.post('/confirm_code', data: {"email": email, "code": int.parse(code)});
    return response.data;
  }

  Future<Map<String, dynamic>?> refreshTokens(String refreshToken) async {
    try {
      final response = await dio.post('/refresh_token', data: {'token': refreshToken});
      return response.data;
    } catch (error) {
      return null;
    }
  }

  Future<String> getUserId(String jwt) async {
    final response = await dio.get('/auth', options: Options(headers: {'Auth': 'Bearer $jwt'}));
    return response.data['user_id'];
  }

  Future<void> testRefreshToken() async {
    final rt = await tokenStorage.getRefreshToken();
    if (rt != null) {
      final newTokens = await refreshTokens(rt);
      if (newTokens != null) {
        await tokenStorage.saveTokens(newTokens);
      }
    }
  }

  Future<String?> getValidUserId() async {
    try {
      String? jwt = await tokenStorage.getJwt();

      if (jwt == null) {
        return null;
      }
      try {
        final userId = await getUserId(jwt);
        return userId;
      } catch (e) {
        if (e is DioException && e.response?.statusCode == 403) {
          String? rt = await tokenStorage.getRefreshToken();

          if (rt != null) {
            final newTokens = await refreshTokens(rt);

            if (newTokens != null) {
              await tokenStorage.saveTokens(newTokens);

              final userId = await getUserId(newTokens['jwt']);
              return userId;
            }
          }
        }
        throw Exception(e);
      }
    } catch (e) {
      await tokenStorage.clear();
      return null;
    }
  }

  Future<void> logout() async {
    await tokenStorage.clear();
  }
}

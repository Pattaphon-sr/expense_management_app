import '../core/http/http_helpers.dart';

class AuthApi {
  // add function login()
  Future<Map<String, dynamic>> login(String username, String password) async {
    final res = await postJson(
      '/login',
      data: {'username': username, 'password': password},
    );
    return res as Map<String, dynamic>;
  }
}

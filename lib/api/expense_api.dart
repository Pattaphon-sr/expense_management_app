import '../core/http/http_helpers.dart';
import '../core/http/http_client.dart';

class ExpenseApi {
  // 1) All expenses all(userId)  

  // 2) Today expense today(userId)
  Future<List<dynamic>> todayExpenses({required int userId}) async {
  final res = await httpc.requestJson(
    '/api/expenses/today',
    method: HttpMethod.get,
    query: {'userId': userId.toString()},
  );
  return res as List<dynamic>;
}

  // 3) Search expense search(userId, keyword)
  Future<List<dynamic>> search({
    required int userId,
    required String name,
  }) async {
    final res = await postJson(
      '/api/expenses/search',
      data: {'userId': userId, 'name': name},
    );
    return res as List<dynamic>;
  }
  // 4) Add new expense create(userId, item, paid)

  // 5) Delete expense by id remove(id)
  Future<void> remove(int id, int userId) async {
    await httpc.requestJson(
      '/api/expenses/$id',
      method: HttpMethod.delete,
      data: {'userId': userId},
    );
  }
}

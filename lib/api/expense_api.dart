import '../core/http/http_helpers.dart';

class ExpenseApi {
  // 1) All expenses all(userId)

  // 2) Today expense today(userId)

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
}

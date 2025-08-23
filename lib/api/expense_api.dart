import '../core/http/http_helpers.dart';
import '../core/http/http_client.dart';

class ExpenseApi {
  // 1) All expenses all(userId)

  // 2) Today expense today(userId)

  // 3) Search expense search(userId, keyword)

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

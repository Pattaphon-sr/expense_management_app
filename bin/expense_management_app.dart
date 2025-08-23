import 'dart:io';
import 'dart:convert';
import '../lib/api/auth_api.dart';
import '../lib/api/expense_api.dart';
import '../lib/util/date_util.dart';

Future<void> main() async {
  // login
  final user = await _login();
  // main manu
  await _mainLoop(userId: user['id'], username: user['username']);
}

// Function to handle user login
Future<Map<String, dynamic>> _login() async {
  final authApi = AuthApi();

  while (true) {
    stdout.writeln("===== Login =====");

    // username
    String? username;
    do {
      stdout.write("Username: ");
      username = stdin.readLineSync();
      if (username == null || username.trim().isEmpty) {
        print("Please enter a username.");
      }
    } while (username == null || username.trim().isEmpty);

    // password
    String? password;
    do {
      stdout.write("Password: ");
      password = stdin.readLineSync();
      if (password == null || password.trim().isEmpty) {
        print("Please enter a password.");
      }
    } while (password == null || password.trim().isEmpty);

    // Call login function from AuthApi
    try {
      final user = await authApi.login(username, password);
      return user;
    } catch (e) {
      print("Login failed: $e");
      continue; // Retry login on failure
    }
  }
}

void _printMenu(String username) {
  print("========= Expense Tracking App =========");
  print("Welcome $username");
  print("1. All expenses");
  print("2. Today's expense");
  print("3. Search expense");
  print("4. Add new expense");
  print("5. Delete an expense");
  print("6. Exit");
  stdout.write("Choose...");
}

// Funtion mainloop
Future<void> _mainLoop({required int userId, required String username}) async {
  final api = ExpenseApi();

  while (true) {
    _printMenu(username);
    String? choice = stdin.readLineSync();

    if (choice == null || choice.isEmpty) {
      print('Please select a choice.');
      continue;
    }

    switch (choice) {
      case '1':
        // Call function to show all expenses
        await _showAllExpenses(api, userId);
        break;

      case '2':
        // Call function to show today's expense
        await _showTodayExpense(api, userId);
        break;

      case '3':
        // Call function to search expense
        await _searchExpense(api, userId);
        break;

      case '4':
        // Call function to add new expense
        await _addNewExpense(api, userId);
        break;

      case '5':
        // Call function to delete an expense
        await _deleteExpense(api, userId);
        break;

      case '6':
        print("----- Bye -------");
        exit(0);

      default:
        print("Invalid choice. Please try again.");
    }
  }
}

// function to show all expenses
Future<void> _showAllExpenses(ExpenseApi api, int userId) async {}

// function to show today's expense
Future<void> _showTodayExpense(ExpenseApi api, int userId) async {}

// function to search expense
Future<void> _searchExpense(ExpenseApi api, int userId) async {
  // Search item in db by user id and name of item from expenses table in db
  stdout.write("Item to search: ");
  String? itemName = stdin.readLineSync();
  if (itemName == null || itemName.trim().isEmpty) {
    print("Item name cannot be empty.");
    return;
  }
  try {
    final expenses = await api.search(userId: userId, name: itemName);
    if (expenses.isEmpty) {
      print("No expenses found for item: $itemName");
    } else {
      for (var expense in expenses) {
        final id = expense['id'] ?? '';
        final item = expense['item'] ?? '';
        final paid = expense['paid'] ?? '';
        var date = expense['date'] ?? '';

         // ใช้ util format date
        final formattedDate = DateUtil.formatDate(date);

        print("$id. $item : ${paid}฿ : $formattedDate");
      }
    }
  } catch (e) {
    print("Error searching expenses: $e");
  }
}

// function to add new expense
Future<void> _addNewExpense(ExpenseApi api, int userId) async {
  print("==== Add new item ====");
  // item
  String? item;
  do {
    stdout.write("Item: ");
    item = stdin.readLineSync();
    if (item == null || item.trim().isEmpty) {
      print("Item cannot be empty.");
    }
  } while (item == null || item.trim().isEmpty);
  // paid
  double? paid;
  do {
    stdout.write("Paid: ");
    String? paidInput = stdin.readLineSync();
    if (paidInput == null || paidInput.trim().isEmpty) {
      print("Paid amount cannot be empty.");
      continue;
    }
    paid = double.tryParse(paidInput);
    if (paid == null) {
      print("Invalid amount. Please enter a valid number.");
    }
  } while (paid == null);

  // userId must be passed in from main loop
  try {
    await api.create(userId: userId, item: item, paid: paid);
    print("Iserted!");
  } catch (e) {
    print("Failed to add expense: $e");
  }
}

// function to delete an expense
Future<void> _deleteExpense(ExpenseApi api, int userId) async {
  print("==== Delete an item ====");
  stdout.write("Item id: ");
  String? idInput = stdin.readLineSync();
  if (idInput == null || idInput.trim().isEmpty) {
    print("Expense ID cannot be empty.");
    return;
  }
  int? id = int.tryParse(idInput);
  if (id == null) {
    print("Invalid expense ID.");
    return;
  }

  // userId must be passed in from main loop
  try {
    await api.remove(id, userId);
    print("Deleted!");
  } catch (e) {
    print("Failed to delete expense: $e");
  }
}

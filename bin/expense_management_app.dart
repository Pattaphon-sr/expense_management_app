import 'dart:io';
import 'dart:convert';
import '../lib/api/auth_api.dart';

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
        
        break;
      case '2':
        // Call function to show today's expense
        
        break;
      case '3':
        // Call function to search expense
        
        break;
      case '4':
        // Call function to add new expense
        
        break;
      case '5':
        // Call function to delete an expense
        
        break;
      case '6':
        print("----- Bye -------");
        exit(0); 
      default:
        print("Invalid choice. Please try again.");
    }
  }
}

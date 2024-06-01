import 'package:chat_app/core/models/user_model.dart';
import 'package:chat_app/core/services/DB_helper/database_helper.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<User> _users = [];

  List<User> get users => _users;

  UserProvider() {
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    _users = await _databaseHelper.getUsers();
    notifyListeners();
  }

  Future<void> addUser(User user) async {
    await _databaseHelper.insertUser(user);
    await fetchUsers();
  }

  Future<void> updateUser(User user) async {
    await _databaseHelper.updateUser(user);
    await fetchUsers();
  }

  Future<void> deleteUser(int id) async {
    await _databaseHelper.deleteUser(id);
    await fetchUsers();
  }
}

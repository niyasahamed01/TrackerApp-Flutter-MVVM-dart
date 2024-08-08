import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';

class UserViewModel with ChangeNotifier {

  List<User> _users = [];
  bool _isLoading = false;
  int _page = 1;

  List<User> get users => _users;
  bool get isLoading => _isLoading;

  Future<void> fetchUsers({bool isRefresh = false}) async {

    if (isRefresh) {
      _page = 1;
      _users = [];
    }

    _isLoading = true;
    notifyListeners();

    final response = await http.get(Uri.parse('https://randomuser.me/api/?page=$_page&results=25'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<User> fetchedUsers = (data['results'] as List).map((user) => User.fromJson(user)).toList();
      _users.addAll(fetchedUsers);
      _page++;
    } else {
      throw Exception('Failed to load users');
    }

    _isLoading = false;
    notifyListeners();
  }
}
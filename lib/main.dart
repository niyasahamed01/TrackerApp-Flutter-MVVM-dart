
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'component/ProfilePage.dart';
import 'component/DetailPage.dart';
import 'component/EmployeePage.dart';
import 'viewmodel/user_viewmodel.dart';
import 'list/user_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserViewModel(), // Providing the UserViewModel
      child: MaterialApp(
        title: 'Random User App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false, // Remove the debug banner
        home: const MainPage(), // MainPage with bottom navigation
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const UserListPage(),
    const EmployeePage(),
    const DetailPage(name: '', address: '', details: '', image: null),
    const ProfilePage(),
  ];

  final List<String> _titles = [
    'User List',
    'Employee',
    'Detail',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]), // Dynamic title
        backgroundColor: Colors.blue, // Custom color
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.grey[800], // Background color of the bottom navigation bar
        selectedItemColor: Colors.black, // Color for the selected item
        unselectedItemColor: Colors.grey[600], // Color for unselected items
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_on),
            label: 'Employee',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.details),
            label: 'Detail',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
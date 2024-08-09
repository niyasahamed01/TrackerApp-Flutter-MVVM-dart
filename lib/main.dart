import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'component/data_entry_page.dart';
import 'component/profile_page.dart';
import 'component/employee_page.dart';
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
    const DataEntryPage(showTitle: false),
    const ProfilePage(),
  ];

  final List<String> _titles = [
    'User List',
    'Employee',
    'Data Entry',
    'Profile',
  ];

  void _showAddNewItemDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Item'),
          content: const Text('Would you like to add a new item?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _navigateToDataEntryPage(
                    showTitle: true); // Pass true to show title
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToDataEntryPage({required bool showTitle}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DataEntryPage(showTitle: showTitle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]), // Dynamic title
        backgroundColor: Colors.blue, // Custom color
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Colors.grey[800],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildBottomNavItem(Icons.home, _titles[0], 0),
                  _buildBottomNavItem(Icons.grid_on, _titles[1], 1),
                ],
              ),
            ),
            const SizedBox(width: 20), // Spacing between the two sides
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildBottomNavItem(
                      Icons.create_new_folder_outlined, _titles[2], 2),
                  _buildBottomNavItem(Icons.person, _titles[3], 3),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Transform.translate(
        offset: const Offset(0, -5), // Move the button up by 5 dp
        child: FloatingActionButton(
          onPressed: _showAddNewItemDialog,
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBottomNavItem(IconData icon, String label, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: SizedBox(
        width: 60, // Adjust width as necessary
        height: 50, // Adjust height to fit within BottomAppBar
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24, // Adjust icon size as necessary
              color: _currentIndex == index ? Colors.blue : Colors.grey[400],
            ),
            const SizedBox(height: 4), // Add spacing between icon and text
            Text(
              label,
              style: TextStyle(
                fontSize: 12, // Adjust font size as necessary
                color: _currentIndex == index ? Colors.blue : Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

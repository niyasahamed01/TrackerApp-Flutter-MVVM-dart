import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/user_detail_page.dart';
import '../viewmodel/user_viewmodel.dart';

class EmployeePage extends StatefulWidget {
  const EmployeePage({super.key});

  @override
  _EmployeePageState createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    userViewModel.fetchUsers();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !userViewModel.isLoading) {
        userViewModel.fetchUsers();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);

    return Scaffold(
      body: userViewModel.isLoading && userViewModel.users.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : userViewModel.users.isEmpty && !userViewModel.isLoading
              ? const Center(
                  child: Text(
                    'No data found',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                )
              : GridView.builder(
                  controller: _scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Adjust the number of columns
                  ),
                  padding: const EdgeInsets.all(8),
                  itemCount: userViewModel.users.length +
                      (userViewModel.isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == userViewModel.users.length) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final user = userViewModel.users[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserDetailPage(user: user),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        // Adjust the corner radius
                        child: Card(
                          color: Colors.blueGrey[50],
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10), // Adjust the corner radius
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.all(8), // Reduce the padding
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.network(
                                  user.pictureLarge,
                                  width: 80,
                                  // Adjust width
                                  height: 80,
                                  // Adjust height
                                  fit: BoxFit.cover,
                                  // Adjust how the image fits
                                  loadingBuilder: (context, child, progress) {
                                    if (progress == null) {
                                      return child;
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: progress.expectedTotalBytes !=
                                                  null
                                              ? progress.cumulativeBytesLoaded /
                                                  (progress
                                                          .expectedTotalBytes ??
                                                      1)
                                              : null,
                                        ),
                                      );
                                    }
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    print('Error loading image: $error');
                                    return Icon(
                                      Icons.person, // Default icon
                                      size: 80, // Adjust size
                                      color: Colors.grey[400],
                                    );
                                  },
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${user.firstName} ${user.lastName}',
                                  style: const TextStyle(
                                    fontSize: 16, // Adjust the font size
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                    height: 4), // Reduce space below name
                                Text(
                                  user.email,
                                  style: const TextStyle(
                                    fontSize: 14, // Adjust the font size
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

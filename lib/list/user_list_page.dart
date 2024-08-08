import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/user_detail_page.dart';
import '../viewmodel/user_viewmodel.dart';


class UserListPage extends StatefulWidget {

  const UserListPage({super.key});

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    userViewModel.fetchUsers();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !userViewModel.isLoading) {
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
          : ListView.builder(
        controller: _scrollController,
        itemCount: userViewModel.users.length + (userViewModel.isLoading ? 1 : 0),
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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: Colors.blueGrey[50],
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(user.pictureLarge),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              '${user.title} ${user.firstName} ${user.lastName}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Email: ${user.email}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Location: ${user.streetNumber} ${user.streetName}, ${user.city}, ${user.state}, ${user.country} ${user.postcode}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Phone:', style: TextStyle(fontSize: 16)),
                          Text(user.phone, style: const TextStyle(fontSize: 16)),
                          const SizedBox(width: 20), // Space between phone and cell
                          const Text('Cell:', style: TextStyle(fontSize: 16)),
                          Text(user.cell, style: const TextStyle(fontSize: 16)),
                        ],
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
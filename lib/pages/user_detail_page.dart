import 'package:flutter/material.dart';
import '../models/user.dart';

class UserDetailPage extends StatelessWidget {

  final User user;

  const UserDetailPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('${user.firstName} ${user.lastName}'),
        backgroundColor: Colors.blue, // Custom color
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: NetworkImage(user.pictureLarge),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Name: ${user.title} ${user.firstName} ${user.lastName}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Divider(height: 32, color: Colors.grey),
              const SizedBox(height: 8),
              Text(
                'Email: ${user.email}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'Age: ${user.dobAge}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              const Text(
                'Address:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(height: 32, color: Colors.grey),
              Text(
                '${user.streetNumber} ${user.streetName}',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                '${user.city}, ${user.state}, ${user.country} ${user.postcode}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(
                'Phone: ${user.phone}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'Cell: ${user.cell}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'Date of Birth: ${user.dobDate}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'Registered: ${user.registeredDate}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'Nationality: ${user.salt}',
                style: const TextStyle(fontSize: 18),
              ),
              const Divider(height: 32, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'Login Details:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(height: 32, color: Colors.grey),
              const SizedBox(height: 4),
              Text(
                'Username: ${user.username}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 4),
              Text(
                'UUID: ${user.uuid}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 4),
              Text(
                'Password: ${user.password}',  // Note: Displaying password in plain text is not secure and should be avoided in real applications
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 4),
              Text(
                'Salt: ${user.salt}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 4),
              Text(
                'MD5: ${user.md5}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 4),
              Text(
                'SHA1: ${user.sha1}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 4),
              Text(
                'SHA256: ${user.sha256}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 4),
              const Divider(height: 32, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
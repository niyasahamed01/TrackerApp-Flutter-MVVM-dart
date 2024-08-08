import 'dart:io';

import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final String name;
  final String address;
  final String details;
  final File? image;

  const DetailPage({
    Key? key,
    this.name = '',
    this.address = '',
    this.details = '',
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: image == null
                  ? CircleAvatar(
                radius: 80,
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.camera_alt, size: 50, color: Colors.grey[600]),
              )
                  : CircleAvatar(
                radius: 80,
                backgroundImage: FileImage(image!),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Name: $name',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Address: $address',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Details: $details',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.pop(context);
            //   },
            //   child: const Text('Back'),
            // ),
          ],
        ),
      ),
    );
  }
}
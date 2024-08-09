import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackapp/component/detail_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('name') ?? '';
      _addressController.text = prefs.getString('address') ?? '';
      _detailsController.text = prefs.getString('details') ?? '';
      // Load image if stored as a path
      final imagePath = prefs.getString('imagePath');
      if (imagePath != null) {
        _image = File(imagePath);
      }
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text);
    await prefs.setString('address', _addressController.text);
    await prefs.setString('details', _detailsController.text);
    // Save image path if needed
    if (_image != null) {
      await prefs.setString('imagePath', _image!.path);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    PermissionStatus permissionStatus;

    if (source == ImageSource.camera) {
      permissionStatus = await Permission.camera.request();
    } else if (source == ImageSource.gallery) {
      permissionStatus = await Permission.photos.request();
    } else {
      return;
    }

    if (permissionStatus.isGranted) {
      try {
        final pickedImage = await _picker.pickImage(source: source);
        if (pickedImage != null) {
          setState(() {
            _image = File(pickedImage.path);
          });
        }
      } catch (e) {
        print("Error picking image: $e");
      }
    } else if (permissionStatus.isDenied) {
      _showPermissionDeniedDialog();
    } else if (permissionStatus.isPermanentlyDenied) {
      _showPermissionDeniedDialog(permanentlyDenied: true);
    }
  }

  void _showPermissionDeniedDialog({bool permanentlyDenied = false}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Denied'),
        content: Text(permanentlyDenied
            ? 'Permission has been permanently denied. Please grant it in the settings.'
            : 'Please grant the necessary permissions to proceed.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (permanentlyDenied) {
                openAppSettings();
              }
            },
            child: Text(permanentlyDenied ? 'Settings' : 'OK'),
          ),
        ],
      ),
    );
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _pickImage(ImageSource.camera);
            },
            child: const Text('Camera'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _pickImage(ImageSource.gallery);
            },
            child: const Text('Gallery'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _navigateToSearchPage() {
    _savePreferences().then((_) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailPage(
            name: _nameController.text,
            address: _addressController.text,
            details: _detailsController.text,
            image: _image, // Pass the image file
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: _image == null
                    ? CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.grey[300],
                        child: Icon(Icons.camera_alt,
                            size: 50, color: Colors.grey[600]),
                      )
                    : CircleAvatar(
                        radius: 80,
                        backgroundImage: FileImage(_image!),
                      ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _showImageSourceDialog(),
                child: const Text('Pick Image'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _detailsController,
                decoration: const InputDecoration(
                  labelText: 'Details',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _navigateToSearchPage,
                child: const Text('Send to Detail Page'),
              ),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset:
          true, // Ensures the content adjusts when keyboard appears
    );
  }
}

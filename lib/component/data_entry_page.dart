import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:trackapp/component/data_list_page.dart';

class DataEntryPage extends StatefulWidget {
  final bool showTitle;

  const DataEntryPage({super.key, required this.showTitle});

  @override
  _DataEntryPageState createState() => _DataEntryPageState();
}

class _DataEntryPageState extends State<DataEntryPage> {
  final TextEditingController _nameController = TextEditingController();
  bool _isChecked = false;
  TimeOfDay _selectedTime = TimeOfDay.now();
  Database? _database;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'data.db');

    _database = await openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE Data(id INTEGER PRIMARY KEY, name TEXT, time TEXT, isChecked INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<void> _insertData(String name, String time, bool isChecked) async {
    try {
      await _database?.insert(
        'Data',
        {
          'name': name,
          'time': time,
          'isChecked': isChecked ? 1 : 0,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error inserting data: $e');
    }
  }

  Future<List<Map<String, dynamic>>> _getDataList() async {
    try {
      return await _database?.query('Data') ?? [];
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _submitData(BuildContext context) async {
    final String name = _nameController.text;
    final String time = _selectedTime.format(context);
    final bool isChecked = _isChecked;

    if (name.isNotEmpty) {
      await _insertData(name, time, isChecked);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data saved successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a name')),
      );
    }
  }

  Future<void> _navigateToDataListPage(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FutureBuilder<List<Map<String, dynamic>>>(
          future: _getDataList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                appBar: AppBar(title: const Text('Data List')),
                body: const Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError) {
              return Scaffold(
                appBar: AppBar(title: const Text('Data List')),
                body: Center(child: Text('Error: ${snapshot.error}')),
              );
            } else if (snapshot.hasData) {
              return DataListPage(initialDataList: snapshot.data!);
            } else {
              return Scaffold(
                appBar: AppBar(title: const Text('Data List')),
                body: const Center(child: Text('No data found')),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _database?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showTitle
          ? AppBar(
              title: const Text("Data Entry"),
              backgroundColor: Colors.blue,
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Time: ${_selectedTime.format(context)}'),
                ElevatedButton(
                  onPressed: () => _pickTime(context),
                  child: const Text('Pick Time'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _isChecked,
                  onChanged: (value) {
                    setState(() {
                      _isChecked = value ?? false;
                    });
                  },
                ),
                const Text('Checked'),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () => _submitData(context),
                child: const Text('Submit'),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () => _navigateToDataListPage(context),
                child: const Text('View Data List'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

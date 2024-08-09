import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataListPage extends StatefulWidget {
  final List<Map<String, dynamic>> initialDataList;

  const DataListPage({super.key, required this.initialDataList});

  @override
  _DataListPageState createState() => _DataListPageState();
}

class _DataListPageState extends State<DataListPage> {
  late List<Map<String, dynamic>> _dataList;

  @override
  void initState() {
    super.initState();
    _dataList = widget.initialDataList;
  }

  Future<void> _deleteData(BuildContext context, int id) async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'data.db');

    final database = await openDatabase(path);

    try {
      await database.delete(
        'Data',
        where: 'id = ?',
        whereArgs: [id],
      );

      // Remove the item from the list and update the state
      setState(() {
        _dataList.removeWhere((item) => item['id'] == id);
      });

      // Use ScaffoldMessenger to show the SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data deleted successfully!')),
      );
    } catch (e) {
      print('Error deleting data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error deleting data')),
      );
    } finally {
      // Close the current screen
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data List'),
        backgroundColor: Colors.blue,
      ),
      body: _dataList.isEmpty
          ? const Center(
              child: Text(
                'No data found',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            )
          : ListView.separated(
              itemCount: _dataList.length,
              separatorBuilder: (context, index) => const Divider(
                color: Colors.black,
                height: 1,
              ),
              itemBuilder: (context, index) {
                final item = _dataList[index];
                return ListTile(
                  title: Text(item['name']),
                  subtitle: Text('Time: ${item['time']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item['isChecked'] == 1
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color:
                            item['isChecked'] == 1 ? Colors.green : Colors.red,
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteData(context, item['id']),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

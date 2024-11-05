import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'buat_data.dart'; 

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref('messages/');
  List<Message> _messages = [];
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _messageController = TextEditingController();
  String _selectedId = '';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    _database.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      setState(() {
        _messages = (data?.entries
                .map((entry) => Message.fromMap(entry.key, entry.value))
                .toList()) ??
            [];
      });
    });
  }

  void _deleteData(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Delete"),
        content: Text("Are you sure you want to delete this data?"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _database.child(id).remove();
              },
              child: Text("Yes")),
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("No")),
        ],
      ),
    );
  }

  void _openSlideBox(Message message) {
    _selectedId = message.id;
    _nameController.text = message.name;
    _emailController.text = message.email;
    _messageController.text = message.message;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Update Data"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: "Nama"),
                ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: "Email"),
                ),
                TextField(
                  controller: _messageController,
                  decoration: InputDecoration(labelText: "Pesan"),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _handleUpdate();
                Navigator.of(context).pop();
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _handleUpdate() {
    final updatedData = {
      'name': _nameController.text,
      'email': _emailController.text,
      'message': _messageController.text,
    };
    _database.child(_selectedId).update(updatedData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Tugas: Mobile & Web Service Kelas E", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text("Nama: Bambang Permadi, Npm: 5220411425", style: TextStyle(fontSize: 14)),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 4,
                    child: ListTile(
                      title: Text(msg.name, style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("${msg.email}\n${msg.message}", style: TextStyle(color: Colors.black54)),
                      isThreeLine: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _openSlideBox(msg),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteData(msg.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BuatData()),
                );
              },
              child: Text("Buat Data Baru"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Message {
  final String id;
  final String name;
  final String email;
  final String message;

  Message({required this.id, required this.name, required this.email, required this.message});

  factory Message.fromMap(String id, Map<dynamic, dynamic> data) {
    return Message(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      message: data['message'] ?? '',
    );
  }
}

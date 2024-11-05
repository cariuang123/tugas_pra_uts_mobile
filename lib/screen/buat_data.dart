import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'home.dart'; 


const String databaseURL = "https://latihan1-1b180-default-rtdb.asia-southeast1.firebasedatabase.app";

class BuatData extends StatefulWidget {
  @override
  _BuatDataState createState() => _BuatDataState();
}

class _BuatDataState extends State<BuatData> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  final DatabaseReference _database = FirebaseDatabase.instance.ref('messages/');

  void _sendData() {
    String name = _nameController.text;
    String email = _emailController.text;
    String message = _messageController.text;

    if (name.isEmpty || email.isEmpty || message.isEmpty) {
      _showAlert('All fields are required!');
      return;
    }

    // Sending data to Firebase
    _database.push().set({
      'name': name,
      'email': email,
      'message': message,
    }).then((_) {
      _showAlert('Data sent successfully!');
      _nameController.clear();
      _emailController.clear();
      _messageController.clear();
    }).catchError((error) {
      _showAlert('Failed to send data: $error');
    });
  }

  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buat Data Baru"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nama", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(hintText: "masukan namamu"),
            ),
            SizedBox(height: 16),
            Text("Email", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(hintText: "masukan emailmu"),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            Text("Pesan", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(hintText: "masukan pesan"),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendData,
              child: Text("Submit"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()), 
                );
              },
              child: Text("Kembali ke Home"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey, 
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

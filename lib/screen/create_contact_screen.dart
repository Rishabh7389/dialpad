import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart'; // Import to handle contacts

class CreateContactScreen extends StatefulWidget {
  @override
  _CreateContactScreenState createState() => _CreateContactScreenState();
}

class _CreateContactScreenState extends State<CreateContactScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  void _saveContact() {
    String name = _nameController.text;
    String phone = _phoneController.text;

    if (name.isNotEmpty && phone.isNotEmpty) {
      // Create a new Contact object
      Contact newContact = Contact()
        ..displayName = name
        ..phones = [Phone(phone)];

      // Pass the new contact back to the ContactsScreen
      Navigator.pop(context, newContact);
    } else {
      // Show an error message if fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill out both fields")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Contact"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: "Phone Number"),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveContact,
              child: Text("Save Contact"),
            ),
          ],
        ),
      ),
    );
  }
}

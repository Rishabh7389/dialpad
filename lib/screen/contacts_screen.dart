import 'dart:developer';

import 'package:dialpad/services/call_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'create_contact_screen.dart'; // Import CreateContactScreen

class ContactsScreen extends StatefulWidget {
  const ContactsScreen();

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final List<Contact> _contacts = [];
  final List<Contact> _filteredContacts = [];
  bool _isLoading = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchContacts(); // Automatically fetch contacts when the screen loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'), // Change title to Contacts
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search bar moved here
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: TextField(
                autofocus: true,
                onChanged: _searchContacts,
                decoration: InputDecoration(
                  hintText: 'Search contacts...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                ),
              ),
            ),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: _filteredContacts.isEmpty
                        ? const Center(
                            child: Text('No contacts',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          )
                        : ListView.builder(
                            itemCount: _filteredContacts.length,
                            itemBuilder: (context, index) {
                              Contact contact = _filteredContacts[index];
                              final List<Phone> phones = contact.phones;
                              return ListTile(
                                onTap: () {
                                  CallServices()
                                      .onCallPressed(phones[0].number, context);
                                },
                                leading: CircleAvatar(
                                  radius: 25,
                                  backgroundColor:
                                      const Color.fromARGB(255, 209, 93, 248),
                                  child: Icon(Icons.person,
                                      size: 30, color: Colors.white),
                                ),
                                title: Text(
                                  contact.displayName,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  phones.isEmpty
                                      ? "No phone number"
                                      : '${phones[0].label} ${phones[0].number}',
                                  style: TextStyle(fontSize: 14),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 16),
                              );
                            },
                          ),
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToCreateContact();
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.person_add),
      ),
    );
  }

  Future<void> _fetchContacts() async {
    if (_isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final PermissionStatus permissionStatus =
          await Permission.contacts.request();

      if (permissionStatus == PermissionStatus.granted) {
        List<Contact> contacts =
            await FlutterContacts.getContacts(withProperties: true);
        setState(() {
          _contacts.clear();
          _contacts.addAll(contacts); // Add the fetched contacts to the list
          _filteredContacts.clear();
          _filteredContacts.addAll(_contacts); // Initially, show all contacts
        });
      } else {
        _showPermissionDeniedDialog();
      }
    } on Exception catch (e) {
      _showErrorDialog('Error fetching contacts: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToCreateContact() async {
    final newContact = await Navigator.push<Contact>(
      context,
      MaterialPageRoute(
        builder: (context) => CreateContactScreen(),
      ),
    );

    if (newContact != null) {
      setState(() {
        _contacts.add(newContact); // Add the new contact to the list
        _filteredContacts
            .add(newContact); // Add the new contact to the filtered list
      });
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
          'Contacts permission is required to fetch contacts. '
          'Please enable it in settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Method to handle the search functionality
  void _searchContacts(String query) {
    log("called");
    setState(() {
      _searchQuery = query;
      log(_searchQuery);
      _filteredContacts.clear();
      if (query.isEmpty) {
        // If search is empty, show all contacts
        _filteredContacts.addAll(_contacts);
      } else {
        // Filter contacts based on name or phone number

        _filteredContacts.addAll(_contacts.where((contact) {
          final name = contact.displayName.toLowerCase();
          return name.contains(query.toLowerCase());
        }));
        // _filteredContacts.add(_contacts[0]);
      }
    });
    log("filttered: ${_filteredContacts.toList()}");
  }
}

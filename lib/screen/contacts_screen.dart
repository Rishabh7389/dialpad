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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchContacts(); // Automatically fetch contacts when the screen loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              _navigateToCreateContact();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: _contacts.isEmpty
                        ? const Center(
                            child: Text('No contacts'),
                          )
                        : ListView.builder(
                            itemCount: _contacts.length,
                            itemBuilder: (context, index) {
                              Contact contact = _contacts[index];
                              final List<Phone> phones = contact.phones;
                              return ListTile(
                                leading: const CircleAvatar(
                                  child: Icon(Icons.person),
                                ),
                                title: Text(contact.displayName),
                                subtitle: Text(
                                  phones.isEmpty
                                      ? "No phone number"
                                      : '${phones[0].label} ${phones[0].number}',
                                ),
                              );
                            },
                          ),
                  ),
          ],
        ),
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
        final contacts =
            await FlutterContacts.getContacts(withProperties: true);
        setState(() {
          _contacts.clear();
          _contacts.addAll(contacts); // Add the fetched contacts to the list
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
}

// lib/screens/contacts_importer_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:wa_sender_pro/screens/manual_input_screen.dart';

class ContactsImporterScreen extends StatefulWidget {
  const ContactsImporterScreen({super.key});

  @override
  State<ContactsImporterScreen> createState() => _ContactsImporterScreenState();
}

class _ContactsImporterScreenState extends State<ContactsImporterScreen> {
  List<Contact>? _contacts;
  final List<Contact> _selectedContacts = [];
  bool _isLoading = true;
  String _statusMessage = 'Loading contacts...';

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future<void> _fetchContacts() async {
    // First, ask for permission
    if (!await FlutterContacts.requestPermission()) {
      setState(() {
        _isLoading = false;
        _statusMessage = 'Permission denied. Please enable contacts permission in your phone settings.';
      });
      return;
    }
    
    // If permission is granted, fetch the contacts
    final contacts = await FlutterContacts.getContacts(withProperties: true); // withProperties is needed to get phone numbers
    setState(() {
      _contacts = contacts;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Import from Contacts'),
        actions: [
          if (_selectedContacts.isNotEmpty)
            TextButton(
              onPressed: () {
                final selectedNumbers = _selectedContacts
                    .map((c) => c.phones.isNotEmpty ? c.phones.first.number : null)
                    .where((p) => p != null)
                    .cast<String>()
                    .toList();

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManualInputScreen(
                      initialNumbers: selectedNumbers,
                    ),
                  ),
                );
              },
              child: Text('Next (${_selectedContacts.length})'),
            )
        ],
      ),
      body: _isLoading
          ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [const CircularProgressIndicator(), const SizedBox(height: 16), Text(_statusMessage)]))
          : _contacts == null || _contacts!.isEmpty
              ? Center(child: Text(_statusMessage))
              : ListView.builder(
                  itemCount: _contacts!.length,
                  itemBuilder: (context, index) {
                    final contact = _contacts![index];
                    if (contact.phones.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    final isSelected = _selectedContacts.contains(contact);
                    return ListTile(
                      leading: Checkbox(
                        value: isSelected,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              _selectedContacts.add(contact);
                            } else {
                              _selectedContacts.remove(contact);
                            }
                          });
                        },
                      ),
                      title: Text(contact.displayName),
                      subtitle: Text(contact.phones.first.number),
                    );
                  },
                ),
    );
  }
}
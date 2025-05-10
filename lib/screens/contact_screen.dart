import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../database/database_helper.dart';

class ContactScreen extends StatefulWidget {
  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  late List<Contact> _contacts;

  @override
  void initState() {
    super.initState();
    _contacts = [];
    _loadContacts();
  }

  // Load contacts from the database
  _loadContacts() async {
    List<Contact> contacts = await _databaseHelper.getContacts();
    setState(() {
      _contacts = contacts;
    });
  }

  // Add a new contact
  _addContact(String name, String phone) async {
    Contact contact = Contact(name: name, phone: phone);
    await _databaseHelper.insertContact(contact);
    _loadContacts(); // Reload contacts after insertion
  }

  // Delete a contact
  _deleteContact(int id) async {
    await _databaseHelper.deleteContact(id);
    _loadContacts(); // Reload contacts after deletion
  }

  // Show dialog to add a new contact
  _showAddContactDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Contact'),
          content: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                String name = nameController.text;
                String phone = phoneController.text;
                if (name.isNotEmpty && phone.isNotEmpty) {
                  _addContact(name, phone);
                  Navigator.pop(context);
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contact List')),
      body: ListView.builder(
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          Contact contact = _contacts[index];
          return ListTile(
            title: Text(contact.name),
            subtitle: Text(contact.phone),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteContact(contact.id!),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddContactDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}

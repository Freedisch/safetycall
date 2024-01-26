import 'package:flutter/material.dart';
import 'package:safetycare/widget/appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  late SharedPreferences _prefs;

  final List<ContactModel> contacts = [];

  List<String> roleOptions = ["Doctor", "Neighbor", "Friend", "Parent", "Relative"];
  String selectedRole = "Doctor";

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    _prefs = await SharedPreferences.getInstance();
    final savedContacts = _prefs.getStringList('contacts');
    
    if (savedContacts != null) {
      setState(() {
        contacts.clear();
        for (var contactData in savedContacts) {
          final contactInfo = contactData.split(',');
          contacts.add(ContactModel(contactInfo[0], contactInfo[1], contactInfo[2]));
        }
      });
    }
  }

  Future<void> _saveContacts() async {
    final contactsData = contacts.map((contact) => '${contact.name},${contact.phoneNumber},${contact.role}').toList();
    await _prefs.setStringList('contacts', contactsData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SafetyCallAppBar(appBarTitle: "Emergency Contacts"),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show the add contact dialog
          _showAddContactDialog();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(color: Colors.grey.shade300),
        ),
        margin: EdgeInsets.all(10.0),
        child: ListView.separated(
          itemCount: contacts.length,
          separatorBuilder: (context, index) =>
              Divider(color: Colors.grey.shade300),
          itemBuilder: (context, index) {
            final contact = contacts[index];
            return ContactListItem(
              contact: contact,
              onDismissed: () {
                setState(() {
                  contacts.removeAt(index);
                  _saveContacts(); // Save contacts after removing one
                });
              },
            );
          },
        ),
      ),
    );
  }

  void _showAddContactDialog() {
    String name = "";
    String phoneNumber = "";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Contact"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) => name = value,
                decoration: InputDecoration(labelText: "Name"),
              ),
              TextField(
                onChanged: (value) => phoneNumber = value,
                decoration: InputDecoration(labelText: "Phone Number"),
              ),
              DropdownButton<String>(
                hint: Text("Select Role"),
                value: selectedRole,
                onChanged: (value) {
                  setState(() {
                    selectedRole = value!;
                  });
                },
                items: roleOptions.map((role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (name.isNotEmpty && phoneNumber.isNotEmpty && selectedRole.isNotEmpty) {
                  // Add the contact to the list
                  setState(() {
                    contacts.add(ContactModel(name, phoneNumber, selectedRole));
                    _saveContacts(); // Save contacts after adding one
                  });
                  Navigator.of(context).pop();
                } else {
                  // Show an error message if required fields are not filled
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Please fill in the required fields."),
                    ),
                  );
                }
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }
}

class ContactModel {
  final String name;
  final String phoneNumber;
  final String role;

  ContactModel(this.name, this.phoneNumber, this.role);
}

class ContactListItem extends StatelessWidget {
  final ContactModel contact;
  final VoidCallback? onDismissed;

  const ContactListItem({Key? key, required this.contact, this.onDismissed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(contact.name),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 16.0),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        onDismissed?.call();
      },
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Text(
            contact.name[0],
            style: TextStyle(color: Colors.white),
          ),
        ),
        title: Text(contact.name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Row(
          children: [
            Text(contact.phoneNumber),
            Spacer(),
            Text(contact.role),
          ],
        ),
      ),
    );
  }
}


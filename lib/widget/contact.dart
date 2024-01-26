import 'package:flutter/material.dart';
import 'package:safetycare/widget/appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  late SharedPreferences _prefs;

  final List<ContactModel> contacts = [];

  List<String> relationshipOptions = [
    "Doctor",
    "Neighbor",
    "Friend",
    "Parent",
    "Relative"
  ];
  String selectedrelationship = "Doctor";

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
          contacts.add(
              ContactModel(contactInfo[0], contactInfo[1], contactInfo[2]));
        }
      });
    }
  }

  Future<void> _saveContacts() async {
    final contactsData = contacts
        .map((contact) =>
            '${contact.name},${contact.phoneNumber},${contact.relationship}')
        .toList();
    await _prefs.setStringList('contacts', contactsData);
    // add the contact to supabase table
    print("==================================================================");
    print(contacts.last);
    print("================================================================");
    print(contactToJson(contacts.last));
    print("==================================================================");
    try {
      await Supabase.instance.client
          .from('contacts')
          .upsert(contactToJson(contacts.last));
    } catch (e) {
      print("========================here is the supabase error");
      print(e);
      print("===================================");
    }
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
                hint: Text("Select relationship"),
                value: selectedrelationship,
                onChanged: (value) {
                  setState(() {
                    selectedrelationship = value!;
                  });
                },
                items: relationshipOptions.map((relationship) {
                  return DropdownMenuItem<String>(
                    value: relationship,
                    child: Text(relationship),
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
                if (name.isNotEmpty &&
                    phoneNumber.isNotEmpty &&
                    selectedrelationship.isNotEmpty) {
                  // Add the contact to the list
                  setState(() {
                    contacts.add(
                        ContactModel(name, phoneNumber, selectedrelationship));
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
  final String relationship;

  ContactModel(this.name, this.phoneNumber, this.relationship);
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
        title:
            Text(contact.name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Row(
          children: [
            Text(contact.phoneNumber),
            Spacer(),
            Text(contact.relationship),
          ],
        ),
      ),
    );
  }
}

Map<String, dynamic> contactToJson(ContactModel contact) {
  dynamic data = {
    'name': contact.name,
    'phone_number': contact.phoneNumber,
    'relationship': contact.relationship,
  };

  return data;
}

// create a function to add the contact data to supabase table
Future<void> addContactToSupabase(ContactModel contact) async {
  await Supabase.instance.client
      .from('contacts')
      .upsert(contactToJson(contact));
}

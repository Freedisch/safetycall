import 'package:flutter/material.dart';
import 'package:safetycare/widget/appbar.dart';

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  // Dummy list of contacts for demonstration
  final List<ContactModel> contacts = [
    ContactModel("John Doe", "Emergency Responder"),
    ContactModel("Alice Smith", "Medical Professional"),
    // Add more contacts as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SafetyCallAppBar(appBarTitle: "Emergency Contacts"),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your action here when the button is pressed
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue, // Customize the button color
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
          separatorBuilder: (context, index) => Divider(color: Colors.grey.shade300),
          itemBuilder: (context, index) {
            final contact = contacts[index];
            return ContactListItem(
              contact: contact,
              onDismissed: () {
                // Remove the dismissed item from the list
                setState(() {
                  contacts.removeAt(index);
                });
              },
            );
          },
        ),
      ),
    );
  }
}

class ContactModel {
  final String name;
  final String role;

  ContactModel(this.name, this.role);
}

class ContactListItem extends StatelessWidget {
  final ContactModel contact;
  final VoidCallback? onDismissed;

  const ContactListItem({Key? key, required this.contact, this.onDismissed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(contact.name), // Unique key for each Dismissible widget
      background: Container(
        color: Colors.red, // Background color when swiping to delete
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 16.0),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        // Triggered when the item is dismissed (swiped away)
        onDismissed?.call();
      },
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        leading: CircleAvatar(
          backgroundColor: Colors.blue, // Customize the avatar color
          child: Text(
            contact.name[0],
            style: TextStyle(color: Colors.white),
          ),
        ),
        title: Text(contact.name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          contact.role,
          style: TextStyle(fontSize: 12.0),
        ),
      ),
    );
  }
}

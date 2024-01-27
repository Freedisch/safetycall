import 'package:flutter/material.dart';
import 'package:safetycare/theme.dart';
import 'package:safetycare/widget/appbar.dart';
import 'package:safetycare/widget/privacy.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool callingSwitchValue = true;
  bool messagingSwitchValue = true;
  int delayBeforeCalling = 1;
  int delayBeforeMessaging = 1;

  Future<void> _showDelayDialog(
      String title, int currentValue, ValueChanged<int> onChanged) async {
    final TextEditingController controller = TextEditingController();
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Enter delay time in minutes",
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                int? newValue = int.tryParse(controller.text);
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SafetyCallAppBar(appBarTitle: "Settings"),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Edit Personal Info'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditPersonalInfoPage()),
              );
            },
          ),
          SwitchListTile(
            activeColor: themeColor,
            title: Text('Calling'),
            value: callingSwitchValue,
            onChanged: (bool value) {
              setState(() {
                callingSwitchValue = value;
              });
            },
          ),
          SwitchListTile(
            activeColor: themeColor,
            title: Text('Messaging'),
            value: messagingSwitchValue,
            onChanged: (bool value) {
              setState(() {
                messagingSwitchValue = value;
              });
            },
          ),
          ListTile(
            title: Text('Delay before Calling'),
            subtitle: Text('$delayBeforeCalling min'),
            onTap: () {
              _showDelayDialog('Delay before Calling', delayBeforeCalling,
                  (value) {
                setState(() {
                  delayBeforeCalling = value;
                });
              });
            },
          ),
          ListTile(
            title: Text('Delay before Messaging'),
            subtitle: Text('$delayBeforeMessaging min'),
            onTap: () {
              _showDelayDialog('Delay before Messaging', delayBeforeMessaging,
                  (value) {
                setState(() {
                  delayBeforeMessaging = value;
                });
              });
            },
          ),
          ListTile(
            title: Text('About Us'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutUsPage()),
              );
            },
          ),
          ListTile(
            title: Text('Privacy Policy'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrivacyPolicyPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class EditPersonalInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Personal Info'),
      ),
      body: Center(
        child: Text('Page for editing personal info'),
      ),
    );
  }
}

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: Center(
        child: Text('About Us page content'),
      ),
    );
  }
}

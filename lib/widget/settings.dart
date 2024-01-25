import 'package:flutter/material.dart';
import 'package:safetycare/widget/appbar.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SafetyCallAppBar(appBarTitle: "Settings"),
    );
  }
}

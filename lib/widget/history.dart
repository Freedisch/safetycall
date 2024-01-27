import 'package:flutter/material.dart';
import 'package:safetycare/widget/appbar.dart';

class Hitory extends StatefulWidget {
  const Hitory({super.key});

  @override
  State<Hitory> createState() => _HitoryState();
}

class _HitoryState extends State<Hitory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SafetyCallAppBar(appBarTitle: "History"),
    );
  }
}

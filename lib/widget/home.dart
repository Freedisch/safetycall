import 'package:flutter/material.dart';
import 'package:safetycare/widget/appbar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SafetyCallAppBar(appBarTitle: "Safety Call"),
    );
  }
}

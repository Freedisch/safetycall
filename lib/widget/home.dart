import 'package:flutter/material.dart';
import 'package:safetycare/theme.dart';
import 'package:safetycare/widget/appbar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isEmergency = false;
  Color backgroundColor = Colors.white;
  Color textColor = Colors.black;

  void blinkBackground() async {
    while (isEmergency) {
      await Future.delayed(Duration(seconds: 1));
      if (mounted) {
        setState(() {
          backgroundColor =
              backgroundColor == Colors.white ? Colors.red : Colors.white;
          textColor =
              backgroundColor == Colors.red ? Colors.white : Colors.black;
        });
      }
    }
    if (!isEmergency && mounted) {
      setState(() {
        backgroundColor = Colors.white;
        textColor = Colors.black;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SafetyCallAppBar(appBarTitle: "Safety Call"),
      backgroundColor: backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Status: ${isEmergency ? "Emergency" : "OK"}',
                style: TextStyle(fontSize: 24, color: textColor),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: themeColor,
                child: IconButton(
                  icon: Icon(isEmergency ? Icons.warning : Icons.call),
                  color: Colors.white,
                  onPressed: () {
                    setState(() {
                      isEmergency = !isEmergency;
                    });
                    if (isEmergency) {
                      // Start siren sound
                      blinkBackground();
                    } else {
                      // Stop siren sound
                      backgroundColor = Colors.white;
                      textColor = Colors.black;
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safetycare/widget/bottom_navigator.dart';
import 'package:safetycare/widget/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_DB_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(SafetyCall());
}

class SafetyCall extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      routes: {
        '/': (context) => CameraIdInput(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Recorder',
      theme: ThemeData(),
    );
  }
}

class CameraIdInput extends StatefulWidget {
  @override
  _CameraIdInputState createState() => _CameraIdInputState();
}

class _CameraIdInputState extends State<CameraIdInput> {
  final _formKey = GlobalKey<FormState>();
  String? _cameraId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => _showDialog());
  }

  void _showDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Camera Id'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Camera ID';
                } else if (value != '2016') {
                  return 'ID not correct! Please contact admins to\ncalibrate the app with your Camera.';
                }
                return null;
              },
              onSaved: (value) => _cameraId = value,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => BottomNavBarNavigator(),
                    ),
                  );
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
    return Container();
  }
}

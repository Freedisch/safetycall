import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safetycare/widget/bottom_navigator.dart';
import 'package:safetycare/widget/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  // await dotenv.load(fileName: 'assets/.env');
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    // this keys will be removed later: this is just for trial
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
        '/': (context) => BottomNavBarNavigator(),
        // '/home': (context) => HomePage(
        //     // htmlFilePath: 'path_to_your_html_file.html',
        //     // topicTitle: 'Topic Title'),
        // ),
        // '/main': (context) => Home(),
        // '/contact': (context) => ContactPage(),
        // '/history': (context) => History(),
        // '/setting': (context) => SettingsPage(),
      },
      // remove debug banner
      debugShowCheckedModeBanner: false,

      title: 'Recorder',
      theme: ThemeData(),
      // home: SplashScreen(),
    );
  }
}

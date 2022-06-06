import 'package:flutter/material.dart';
import 'package:sam/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';

Future main() async {
//set shared preferences to not show intro again
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final showHome = prefs.getBool('showHome') ?? false;
  runApp(MyApp(showHome: showHome));
}

class MyApp extends StatelessWidget {
  final bool showHome;

  const MyApp({Key? key, required this.showHome,}) : super (key: key);

  @override
  Widget build(BuildContext context) =>
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: showHome ? HomePage() : OnBoardingScreen(),
      );
}


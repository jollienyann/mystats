import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sam/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'helper/theme_provider.dart';
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
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    builder: (context, _) {
      final themeProvider = Provider.of<ThemeProvider>(context);

      return MaterialApp(
        themeMode: themeProvider.themeMode,
        theme: MyThemes.lightTheme,
        darkTheme: MyThemes.darkTheme,
        home: showHome ? HomePage() : OnBoardingScreen(),
      );
    },
  );
}


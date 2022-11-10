import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sam/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'helper/theme_provider.dart';
import 'home_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final showHome = prefs.getBool('showHome') ?? false;
  SharedPreferences.getInstance().then((prefs) {
    var isDarkTheme = prefs.getBool("darkTheme") ?? false;
    return runApp(
      ChangeNotifierProvider<ThemeProvider>(
        child: MyApp(showHome: showHome),
        create: (BuildContext context) {
          return ThemeProvider(isDarkTheme);
        },
      ),
    );
  });

}

class MyApp extends StatelessWidget {
  final bool showHome;


  const MyApp({Key? key, required this.showHome,}) : super (key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = new ThemeData();
    return Consumer<ThemeProvider>(
      builder: (context, value, child) {
        themeData = value.getTheme()!;
        return MaterialApp(
          title: 'Flutter Demo',
          theme: themeData,
          home: showHome ? HomePage() : OnBoardingScreen(),
        );
      },
    );
  }
}


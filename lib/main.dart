import 'package:flutter/material.dart';
import 'package:quizmaker/helper/functions.dart';
import 'package:quizmaker/views/home.dart';
import 'package:quizmaker/views/signin.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

const MaterialColor myColor =
    const MaterialColor(0xFFE75D2E, const <int, Color>{
  50: Color(0xFFE75D2E),
  100: Color(0xFFE75D2E),
  200: Color(0xFFE75D2E),
  300: Color(0xFFE75D2E),
  400: Color(0xFFE75D2E),
  500: Color(0xFFE75D2E),
  600: Color(0xFFE75D2E),
  700: Color(0xFFE75D2E),
  800: Color(0xFFE75D2E),
  900: Color(0xFFE75D2E),
});

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;
  @override
  void initState() {
    checkUserLoggedInStatus();
    super.initState();
  }

  checkUserLoggedInStatus() async {
    _isLoggedIn = await HelperFunctions.getUserLoggedInDetails();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: myColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _isLoggedIn ? HomePage() : SignIn(),
    );
  }
}

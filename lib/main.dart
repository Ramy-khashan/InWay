import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:zezo/screens/flashpage/view.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.blueGrey.shade400,
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent, elevation: 0),
        scaffoldBackgroundColor: Theme.of(context).cardColor,
        primarySwatch: Colors.blue,
      ),
      home: const FlashScreen(),
    );
  }
}

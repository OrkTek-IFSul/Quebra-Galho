import 'package:flutter/material.dart';
import 'package:flutter_quebragalho/views/screens/HomePage.dart';
import 'package:flutter_quebragalho/views/screens/SplashScreen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textTheme: Theme.of(context).textTheme.apply(
          fontFamily: 'Inter',
        ),
      ),
      home: SplashScreen(),
    );
  }
}

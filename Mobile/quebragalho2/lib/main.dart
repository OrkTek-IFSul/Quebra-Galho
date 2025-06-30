import 'package:flutter/material.dart';
import 'package:quebragalho2/views/moderador/moderador_page.dart';
import 'package:quebragalho2/views/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Arquivo gerado automaticamente

void main() async {
  ;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      theme: ThemeData(fontFamily: 'Manrope'),
    );
  }
}

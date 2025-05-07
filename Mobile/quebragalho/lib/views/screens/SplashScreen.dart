import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_quebragalho/views/screens/LoginPage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animationOpacity;
  late Animation<double> _animationScale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    _animationOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _animationScale = Tween<double>(begin: 0.4, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();

    Timer(Duration(seconds: 6), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage()),
      ); // Define tua rota
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      body: Center(
        child: FadeTransition(
          opacity: _animationOpacity,
          child: ScaleTransition(
            scale: _animationScale,
            child: Image.asset(
              'assets/logo.png', // Troca pro caminho do teu logo
              width: 150,
              height: 150,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

const String appKey = 'easemob#easeim';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
    startShowTimer();
  }

  void startShowTimer() async {
    await Future.delayed(const Duration(seconds: 2)).then((value) {
      if (ChatUIKit.instance.isLogged()) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Welcome!'),
      ),
    );
  }
}

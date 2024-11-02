import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  Widget createAppBar(String message) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: Text(message,
          style: const TextStyle(color: Colors.white, fontSize: 40)),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: Icon(
            Icons.settings,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.blueGrey.shade300, Colors.black],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0.1, 0.3])),
      child: Column(
        children: [createAppBar('Welcome!'), const SizedBox(height: 5)],
      ),
    ));
  }
}

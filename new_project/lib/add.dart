import 'package:flutter/material.dart';

class Add extends StatelessWidget {
  const Add({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Text(
        'Add', 
        style: TextStyle(fontSize: 40, color: Colors.yellow)));
  }
}
import 'package:flutter/material.dart';

class Library extends StatelessWidget {
  const Library({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
        child: Text('Library',
            style: TextStyle(fontSize: 40, color: Colors.yellow)));
  }
}

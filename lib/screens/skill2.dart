import 'package:flutter/material.dart';

class Skill2Screen extends StatelessWidget {
  const Skill2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Skill 2')),
      body: Center(child: Image.asset('assets/pages_items/skill2.png')),
    );
  }
}
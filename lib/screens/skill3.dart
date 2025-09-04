import 'package:flutter/material.dart';

class Skill3Screen extends StatelessWidget {
  const Skill3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Skill 3')),
      body: Center(child: Image.asset('assets/pages_items/skill3.png')),
    );
  }
}
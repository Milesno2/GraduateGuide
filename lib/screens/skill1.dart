import 'package:flutter/material.dart';

class Skill1Screen extends StatelessWidget {
  const Skill1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Skill 1')),
      body: Center(child: Image.asset('assets/pages_items/skill1.png')),
    );
  }
}
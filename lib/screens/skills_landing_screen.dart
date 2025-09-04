import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SkillsLandingScreen extends StatelessWidget {
  const SkillsLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text('Skills', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w600)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _buildSkillCard(context, 'assets/pages_items/skill1.png', 'Skill 1', '/skill1'),
            _buildSkillCard(context, 'assets/pages_items/skill2.png', 'Skill 2', '/skill2'),
            _buildSkillCard(context, 'assets/pages_items/skill3.png', 'Skill 3', '/skill3'),
            _buildSkillCard(context, 'assets/pages_items/skill1.png', 'More', '/skill1'),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillCard(BuildContext context, String asset, String label, String route) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Image.asset(asset, fit: BoxFit.contain)),
            const SizedBox(height: 8),
            Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
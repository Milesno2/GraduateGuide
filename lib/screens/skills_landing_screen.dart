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
        title: Text('Acquire Skill', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset('assets/pages_assets/Skills.png', fit: BoxFit.cover),
              ),
              const SizedBox(height: 16),
              Text('Popular Tracks', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 18)),
              const SizedBox(height: 12),
              _SkillTile(
                asset: 'assets/pages_items/skill1.png',
                title: 'Skill 1',
                onTap: () => Navigator.pushNamed(context, '/skill1'),
              ),
              const SizedBox(height: 12),
              _SkillTile(
                asset: 'assets/pages_items/skill2.png',
                title: 'Skill 2',
                onTap: () => Navigator.pushNamed(context, '/skill2'),
              ),
              const SizedBox(height: 12),
              _SkillTile(
                asset: 'assets/pages_items/skill3.png',
                title: 'Skill 3',
                onTap: () => Navigator.pushNamed(context, '/skill3'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkillTile extends StatelessWidget {
  final String asset;
  final String title;
  final VoidCallback onTap;
  const _SkillTile({required this.asset, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(asset, width: 72, height: 72, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16)),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
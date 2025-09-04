import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class SkillsLandingScreen extends StatefulWidget {
  const SkillsLandingScreen({super.key});

  @override
  State<SkillsLandingScreen> createState() => _SkillsLandingScreenState();
}

class _SkillsLandingScreenState extends State<SkillsLandingScreen> {
  final TextEditingController _search = TextEditingController();
  final List<Map<String, String>> items = const [
    {'title': 'Skill 1', 'asset': 'assets/pages_items/skill1.png', 'route': '/skill1'},
    {'title': 'Skill 2', 'asset': 'assets/pages_items/skill2.png', 'route': '/skill2'},
    {'title': 'Skill 3', 'asset': 'assets/pages_items/skill3.png', 'route': '/skill3'},
  ];

  String _q = '';

  List<Map<String, String>> get filtered =>
      items.where((e) => e['title']!.toLowerCase().contains(_q.toLowerCase())).toList();

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Explore providers', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  Row(children: [
                    TextButton(onPressed: () => _open('https://www.udemy.com/'), child: const Text('Udemy')),
                    TextButton(onPressed: () => _open('https://www.coursera.org/'), child: const Text('Coursera')),
                    TextButton(onPressed: () => _open('https://www.edx.org/'), child: const Text('edX')),
                  ])
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _search,
                onChanged: (v) => setState(() => _q = v.trim()),
                decoration: InputDecoration(
                  hintText: 'Search skills...',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),
              Text('Popular Tracks', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 18)),
              const SizedBox(height: 12),
              ...filtered.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _SkillTile(
                      asset: e['asset']!,
                      title: e['title']!,
                      onTap: () => Navigator.pushNamed(context, e['route']!),
                    ),
                  )),
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
            Expanded(child: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16))),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class NyscGuidelinesScreen extends StatelessWidget {
  const NyscGuidelinesScreen({super.key});

  final Color deepPurple = const Color(0xFF6C2786);

  Future<void> _openExternal(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    final leave = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Leave Graduate Guide?',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text(
            'You are about to leave the Graduate Guide app and visit an external website. Continue?',
            style: GoogleFonts.poppins()),
        actions: [
          TextButton(
            child:
                Text('Cancel', style: GoogleFonts.poppins(color: Colors.grey)),
            onPressed: () => Navigator.pop(ctx, false),
          ),
          TextButton(
            child:
                Text('Continue', style: GoogleFonts.poppins(color: deepPurple)),
            onPressed: () => Navigator.pop(ctx, true),
          ),
        ],
      ),
    );
    if (leave == true) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: deepPurple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'NYSC Guidelines',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('National Youth Service Corps (NYSC)',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: deepPurple)),
            const SizedBox(height: 12),
            Text(
              'Get official information, requirements, and tips for NYSC registration and service year. Use the links below for more details.',
              style: GoogleFonts.poppins(fontSize: 15),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: Image.asset('assets/pages_items/nysc_logo.png',
                  width: 40, height: 40),
              title: Text('NYSC Official Portal',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              subtitle: Text(
                  'Visit the official NYSC portal for registration, guidelines, and updates.',
                  style: GoogleFonts.poppins(fontSize: 13)),
              trailing: const Icon(Icons.open_in_new, color: Colors.green),
              onTap: () =>
                  _openExternal(context, 'https://portal.nysc.org.ng/nysc1/'),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.orange),
              title: Text('NYSC Requirements',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              subtitle: Text(
                  'See eligibility, documents, and step-by-step process.',
                  style: GoogleFonts.poppins(fontSize: 13)),
              trailing: const Icon(Icons.open_in_new, color: Colors.orange),
              onTap: () => _openExternal(context, 'https://www.nysc.gov.ng/'),
            ),
            ListTile(
              leading: const Icon(Icons.school, color: deepPurple),
              title: Text('NYSC Orientation Camp Tips',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              subtitle: Text(
                  'Read tips and advice for a successful camp experience.',
                  style: GoogleFonts.poppins(fontSize: 13)),
              trailing: const Icon(Icons.open_in_new, color: deepPurple),
              onTap: () => _openExternal(
                  context, 'https://www.nysc.gov.ng/orientation-camp.html'),
            ),
          ],
        ),
      ),
    );
  }
}

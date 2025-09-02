import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ResumeBuilderScreen extends StatelessWidget {
  const ResumeBuilderScreen({super.key});

  final Color deepPurple = const Color(0xFF6C2786);

  Future<void> _openResumeSite(BuildContext context) async {
    final uri = Uri.parse('https://www.canva.com/create/resumes/');
    final leave = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Leave Graduate Guide?',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text(
            'You are about to leave the Graduate Guide app and visit a free resume builder website. Continue?',
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
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Resume Builder',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  color: Colors.grey.shade100,
                ),
                child: Image.asset(
                  'assets/pages_items/resume.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Make your professional resume in minutes',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: deepPurple,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'From generating bullet points to automatic formatting, our resume builder will help you make a professional resume quickly and effortlessly.',
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _openResumeSite(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: deepPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      'Build My Resume Now',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // TODO: Upload resume action
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: deepPurple, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      'Upload My Existing Resume',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: deepPurple,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Features
            _featureTitle('Leverage the latest AI tech'),
            _featureText(
                'Our resume builder lets you make a fully customized resume in minutes. Use our software to your advantage & apply for jobs faster.'),
            const SizedBox(height: 18),
            _featureTitle('Generate bullet points'),
            _featureText(
                'Your resume’s experience section is what employers care about most. Use AI to autogenerate experience bullet points that prove your on-the-job skills.'),
            const SizedBox(height: 18),
            _featureTitle('Auto-format each section'),
            _featureText(
                'Formatting can be time-consuming. Don’t let margins & spacing slow you down – put in your details and the resume maker does the rest.'),
            const SizedBox(height: 18),
            _featureTitle('Instantly download your resume'),
            _featureText(
                'Easily download your resume as a PDF, for Word, or in text format. Use the dashboard to test different templates to see what works best for you.'),
            const SizedBox(height: 18),
            _featureTitle('Find industry-specific skills'),
            _featureText(
                'Enter your job title and our software uses AI to provide you with targeted skills suggestions.'),
            const SizedBox(height: 18),
            _featureTitle('Launch your job hunt'),
            _featureText(
                'Equipped with your perfected resume, you’re ready to take on the job market. Get more job interviews & earn better job offers.'),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _featureTitle(String title) => Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.black,
        ),
      );

  Widget _featureText(String text) => Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.grey[800],
        ),
      );
}

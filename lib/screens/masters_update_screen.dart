import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class MastersUpdateScreen extends StatefulWidget {
  const MastersUpdateScreen({super.key});

  @override
  State<MastersUpdateScreen> createState() => _MastersUpdateScreenState();
}

class _MastersUpdateScreenState extends State<MastersUpdateScreen> {
  final Color deepPurple = const Color(0xFF6C2786);

  Future<void> _openExternal(String url) async {
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
            child: Text('Cancel', style: GoogleFonts.poppins(color: Colors.grey)),
            onPressed: () => Navigator.pop(ctx, false),
          ),
          TextButton(
            child: Text('Continue', style: GoogleFonts.poppins(color: deepPurple)),
            onPressed: () => Navigator.pop(ctx, true),
          ),
        ],
      ),
    );
    if (leave == true) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Widget _buildUniversityCard({
    required String name,
    required String location,
    required String description,
    required List<String> programs,
    required String applicationDeadline,
    required String website,
    required String logo,
    bool isFeatured = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: deepPurple.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(
                      logo,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          if (isFeatured)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Featured',
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        location,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: deepPurple,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Deadline: $applicationDeadline',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: deepPurple,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Available Programs',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: deepPurple,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: programs.map((program) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: deepPurple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: deepPurple.withOpacity(0.3)),
                      ),
                      child: Text(
                        program,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: deepPurple,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _openExternal(website),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: deepPurple,
                          side: BorderSide(color: deepPurple),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Visit Website',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _showApplicationGuide(name),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: deepPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Apply Now',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showApplicationGuide(String universityName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Application Guide',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Steps to apply for $universityName:',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            _buildStepItem('1', 'Visit the university website'),
            _buildStepItem('2', 'Create an account on the portal'),
            _buildStepItem('3', 'Fill in your personal information'),
            _buildStepItem('4', 'Upload required documents'),
            _buildStepItem('5', 'Pay application fee'),
            _buildStepItem('6', 'Submit your application'),
            const SizedBox(height: 16),
            Text(
              'Required Documents:',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            _buildDocumentItem('Bachelor\'s degree certificate'),
            _buildDocumentItem('Academic transcripts'),
            _buildDocumentItem('CV/Resume'),
            _buildDocumentItem('Statement of purpose'),
            _buildDocumentItem('Letters of recommendation'),
            _buildDocumentItem('Valid ID card'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: deepPurple,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                number,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentItem(String document) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 16, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              document,
              style: GoogleFonts.poppins(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: deepPurple,
        title: Row(
          children: [
            Image.asset(
              'assets/pages_items/masters.png',
              width: 24,
              height: 24,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              'Masters Programs',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: deepPurple,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Image.asset(
                    'assets/pages_items/masters.png',
                    width: 64,
                    height: 64,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Postgraduate Programs',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Discover opportunities for advanced education and career growth',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Quick Stats
            Row(
              children: [
                Expanded(
                  child: _buildStatCard('Active Programs', '50+', Icons.school),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard('Universities', '25+', Icons.account_balance),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard('Deadlines', 'This Month', Icons.schedule),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Featured Universities
            Text(
              'Featured Universities',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: deepPurple,
              ),
            ),
            const SizedBox(height: 16),
            _buildUniversityCard(
              name: 'University of Lagos (UNILAG)',
              location: 'Lagos, Nigeria',
              description: 'One of Nigeria\'s premier universities offering world-class postgraduate programs in various fields.',
              programs: ['MBA', 'MSc Computer Science', 'MSc Economics', 'MA English'],
              applicationDeadline: 'March 15, 2024',
              website: 'https://unilag.edu.ng',
              logo: 'assets/pages_items/masters.png',
              isFeatured: true,
            ),
            _buildUniversityCard(
              name: 'Obafemi Awolowo University (OAU)',
              location: 'Ile-Ife, Nigeria',
              description: 'Renowned for its academic excellence and research contributions in various disciplines.',
              programs: ['MSc Engineering', 'MSc Agriculture', 'MA History', 'MSc Chemistry'],
              applicationDeadline: 'March 30, 2024',
              website: 'https://oauife.edu.ng',
              logo: 'assets/pages_items/masters.png',
              isFeatured: true,
            ),
            _buildUniversityCard(
              name: 'University of Ibadan (UI)',
              location: 'Ibadan, Nigeria',
              description: 'Nigeria\'s first university with a rich history of academic excellence and research.',
              programs: ['MSc Medicine', 'MSc Law', 'MA Literature', 'MSc Physics'],
              applicationDeadline: 'April 10, 2024',
              website: 'https://ui.edu.ng',
              logo: 'assets/pages_items/masters.png',
            ),
            _buildUniversityCard(
              name: 'Covenant University',
              location: 'Ota, Nigeria',
              description: 'Private university known for its innovative programs and modern facilities.',
              programs: ['MBA', 'MSc Architecture', 'MSc Business', 'MA Communication'],
              applicationDeadline: 'March 25, 2024',
              website: 'https://covenantuniversity.edu.ng',
              logo: 'assets/pages_items/masters.png',
            ),
            const SizedBox(height: 24),

            // Application Tips
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb, color: Colors.amber, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          'Application Tips',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.amber[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTipItem('Start early - applications can take time to complete'),
                    _buildTipItem('Research programs thoroughly before applying'),
                    _buildTipItem('Prepare a strong statement of purpose'),
                    _buildTipItem('Get recommendation letters from professors'),
                    _buildTipItem('Ensure all documents are properly certified'),
                    _buildTipItem('Keep track of application deadlines'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Quick Links
            Text(
              'Quick Links',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: deepPurple,
              ),
            ),
            const SizedBox(height: 16),
            _buildQuickLinkCard(
              'Scholarship Opportunities',
              'Find funding for your postgraduate studies',
              Icons.monetization_on,
              Colors.green,
              () => _openExternal('https://scholarships.gov.ng'),
            ),
            _buildQuickLinkCard(
              'Research Grants',
              'Explore research funding opportunities',
              Icons.science,
              Colors.blue,
              () => _openExternal('https://research.gov.ng'),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: deepPurple, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: deepPurple,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, size: 16, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              tip,
              style: GoogleFonts.poppins(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickLinkCard(String title, String description, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          description,
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600]),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
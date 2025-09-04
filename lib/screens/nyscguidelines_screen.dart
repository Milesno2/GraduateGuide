import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class NYSCGuidelinesScreen extends StatefulWidget {
  const NYSCGuidelinesScreen({super.key});

  @override
  State<NYSCGuidelinesScreen> createState() => _NYSCGuidelinesScreenState();
}

class _NYSCGuidelinesScreenState extends State<NYSCGuidelinesScreen> {
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

  Widget _buildInfoCard({
    required String title,
    required String content,
    required IconData icon,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: (iconColor ?? deepPurple).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor ?? deepPurple, size: 24),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            content,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ),
        trailing: onTap != null
            ? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey)
            : null,
        onTap: onTap,
      ),
    );
  }

  Widget _buildStepCard({
    required int stepNumber,
    required String title,
    required String description,
    required List<String> requirements,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: deepPurple,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      stepNumber.toString(),
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Requirements:',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: deepPurple,
              ),
            ),
            const SizedBox(height: 8),
            ...requirements.map((req) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle, size: 16, color: Colors.green),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      req,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
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
              'assets/pages_items/nysc_logo.png',
              width: 24,
              height: 24,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              'NYSC Guidelines',
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
                    'assets/pages_items/nysc_logo.png',
                    width: 64,
                    height: 64,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'National Youth Service Corps',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Mandatory one-year service for Nigerian graduates',
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

            // Quick Links Section
            Text(
              'Quick Links',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: deepPurple,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              title: 'NYSC Official Portal',
              content: 'Register, check status, and access official services',
              icon: Icons.language,
              iconColor: Colors.blue,
              onTap: () => _openExternal('https://portal.nysc.org.ng/nysc1/'),
            ),
            _buildInfoCard(
              title: 'NYSC Requirements',
              content: 'Eligibility criteria and required documents',
              icon: Icons.info_outline,
              iconColor: Colors.orange,
              onTap: () => _openExternal('https://www.nysc.gov.ng/'),
            ),
            _buildInfoCard(
              title: 'Orientation Camp Guide',
              content: 'Tips and information for camp experience',
              icon: Icons.cabin,
              iconColor: Colors.green,
              onTap: () => _openExternal('https://www.nysc.gov.ng/orientation-camp.html'),
            ),
            const SizedBox(height: 24),

            // Registration Steps
            Text(
              'Registration Process',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: deepPurple,
              ),
            ),
            const SizedBox(height: 16),
            _buildStepCard(
              stepNumber: 1,
              title: 'Eligibility Check',
              description: 'Ensure you meet the basic requirements for NYSC registration.',
              requirements: [
                'Must be a Nigerian citizen',
                'Must have graduated from an accredited institution',
                'Must be under 30 years of age',
                'Must have completed your degree program',
              ],
            ),
            _buildStepCard(
              stepNumber: 2,
              title: 'Document Preparation',
              description: 'Gather all required documents for registration.',
              requirements: [
                'Valid email address',
                'Valid phone number',
                'Recent passport photograph',
                'Academic credentials (degree certificate)',
                'Local government identification letter',
              ],
            ),
            _buildStepCard(
              stepNumber: 3,
              title: 'Online Registration',
              description: 'Complete the registration process on the NYSC portal.',
              requirements: [
                'Visit portal.nysc.org.ng',
                'Create an account with valid email',
                'Fill in personal and academic details',
                'Upload required documents',
                'Submit and print registration slip',
              ],
            ),
            _buildStepCard(
              stepNumber: 4,
              title: 'Physical Verification',
              description: 'Visit your institution for document verification.',
              requirements: [
                'Print registration slip',
                'Bring original documents',
                'Visit your institution\'s NYSC office',
                'Complete verification process',
              ],
            ),
            _buildStepCard(
              stepNumber: 5,
              title: 'Camp Deployment',
              description: 'Receive deployment letter and prepare for orientation camp.',
              requirements: [
                'Check deployment status online',
                'Print call-up letter',
                'Prepare for camp requirements',
                'Travel to assigned camp location',
              ],
            ),
            const SizedBox(height: 24),

            // Important Information
            Text(
              'Important Information',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: deepPurple,
              ),
            ),
            const SizedBox(height: 16),
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
                        Icon(Icons.warning, color: Colors.orange, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          'Important Notes',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildInfoItem('Registration is free on the official portal'),
                    _buildInfoItem('Beware of fake websites and scammers'),
                    _buildInfoItem('Keep your login credentials safe'),
                    _buildInfoItem('Regularly check for updates and announcements'),
                    _buildInfoItem('Contact NYSC support for technical issues'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Contact Information
            Text(
              'Contact & Support',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: deepPurple,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              title: 'NYSC Support',
              content: 'Get help with registration and technical issues',
              icon: Icons.support_agent,
              iconColor: Colors.teal,
              onTap: () => _openExternal('https://www.nysc.gov.ng/contact-us'),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, size: 16, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

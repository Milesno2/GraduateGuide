import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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

  Widget _buildGridItem(String asset, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.12),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset(asset, fit: BoxFit.contain),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildArrowItem() {
    return Center(
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.12),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: const Icon(Icons.arrow_forward_ios, size: 32, color: Colors.grey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              decoration: BoxDecoration(
                color: deepPurple,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 22,
                        backgroundImage: AssetImage('assets/pages_assets/profile.png'),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Welcome back',
                              style: GoogleFonts.poppins(color: Colors.white, fontSize: 13)),
                          Text('Graduate',
                              style: GoogleFonts.poppins(
                                  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                      const Spacer(),
                      Image.asset('assets/pages_assets/support.png', width: 28, height: 28, fit: BoxFit.contain),
                      const SizedBox(width: 16),
                      Image.asset('assets/pages_items/Bell.png', width: 28, height: 28, fit: BoxFit.contain),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: Text(
                      'Graduate Guide',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 0.95,
                children: [
                  GestureDetector(
                    onTap: () => _openExternal(context, 'https://portal.nysc.org.ng/nysc1/'),
                    child: _buildGridItem('assets/pages_items/nysc_logo.png', 'Nysc Reg.\nGuidelines'),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/resume-builder'),
                    child: _buildGridItem('assets/pages_items/resume.png', 'Resume Builder'),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/skills'),
                    child: _buildGridItem('assets/pages_items/task.png', 'Acquire Skill'),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/masters-update'),
                    child: _buildGridItem('assets/pages_items/masters.png', 'Masters Update'),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/jobs'),
                    child: _buildGridItem('assets/pages_items/job.png', 'Job Offer'),
                  ),
                  _buildArrowItem(),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text('Campus News',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold, fontSize: 18, color: deepPurple)),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: Text('See all >', style: GoogleFonts.poppins(color: deepPurple)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: Image.asset('assets/pages_items/fmn_logo.png', width: 48, height: 48, fit: BoxFit.contain),
                  title: Text('Lautech Student Emerge as the best in the FMN Competition',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 14)),
                  subtitle: Text('Posted 30 min ago',
                      style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('NYSC Quick Links',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold, fontSize: 18, color: deepPurple)),
                  const SizedBox(height: 12),
                  ListTile(
                    leading: Image.asset('assets/pages_items/nysc_logo.png', width: 36, height: 36),
                    title: Text('NYSC Official Portal',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    subtitle: Text('Registration, guidelines, and updates.',
                        style: GoogleFonts.poppins(fontSize: 13)),
                    trailing: const Icon(Icons.open_in_new, color: Colors.green),
                    onTap: () => _openExternal(context, 'https://portal.nysc.org.ng/nysc1/'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.info_outline, color: Colors.orange),
                    title: Text('NYSC Requirements',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    subtitle: Text('Eligibility, documents, and step-by-step process.',
                        style: GoogleFonts.poppins(fontSize: 13)),
                    trailing: const Icon(Icons.open_in_new, color: Colors.orange),
                    onTap: () => _openExternal(context, 'https://www.nysc.gov.ng/'),
                  ),
                  ListTile(
                    leading: Icon(Icons.school, color: deepPurple),
                    title: Text('NYSC Orientation Camp Tips',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    subtitle: Text('Advice for a successful camp experience.',
                        style: GoogleFonts.poppins(fontSize: 13)),
                    trailing: Icon(Icons.open_in_new, color: deepPurple),
                    onTap: () => _openExternal(context, 'https://www.nysc.gov.ng/orientation-camp.html'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context, deepPurple),
    );
  }

  Widget _buildBottomNavBar(BuildContext context, Color deepPurple) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, -2))
      ]),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: deepPurple,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(
              icon: Image.asset('assets/pages_assets/Home (1).png', width: 22, height: 22), label: 'Home'),
          BottomNavigationBarItem(
              icon: Image.asset('assets/pages_assets/Annotation.png', width: 22, height: 22), label: 'Messages'),
          BottomNavigationBarItem(
              icon: Image.asset('assets/pages_assets/Speakerphone.png', width: 22, height: 22), label: 'Updates'),
          BottomNavigationBarItem(
              icon: Image.asset('assets/pages_assets/UserCircle.png', width: 22, height: 22), label: 'Me'),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.pushNamed(context, '/messages');
              break;
            case 2:
              Navigator.pushNamed(context, '/updates');
              break;
            case 3:
              Navigator.pushNamed(context, '/user');
              break;
          }
        },
      ),
    );
  }
}
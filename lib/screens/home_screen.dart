import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color deepPurple = const Color(0xFF6C2786);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Curved header
            Stack(
              children: [
                ClipPath(
                  clipper: CurvedHeaderClipper(),
                  child: Container(
                    height: 220,
                    color: deepPurple,
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 24,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundImage: AssetImage(
                            'assets/preloader_assets/charco_education.png'),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            'DADA TIMILEHIN S.',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 24,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Image.asset('assets/pages_items/support.png',
                            width: 28, height: 28),
                        onPressed: () =>
                            Navigator.pushNamed(context, '/customer-care'),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Image.asset('assets/pages_items/Bell.png',
                            width: 24, height: 24),
                        onPressed: () =>
                            Navigator.pushNamed(context, '/updates'),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 120,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      'Graduate Guide',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Main grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: _buildGridItem(
                            'assets/pages_items/nysc_logo.png',
                            'Nysc Reg.\nGuidelines'),
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, '/resume-builder'),
                        child: _buildGridItem(
                            'assets/pages_items/resume.png', 'Resume Builder'),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/skills'),
                        child: _buildGridItem(
                            'assets/pages_items/task.png', 'Acquire Skill'),
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, '/masters-update'),
                        child: _buildGridItem(
                            'assets/pages_items/masters.png', 'Masters Update'),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/jobs'),
                        child: _buildGridItem(
                            'assets/pages_items/job.png', 'Job Offer'),
                      ),
                      _buildArrowItem(),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Campus News',
                        style: GoogleFonts.poppins(
                          color: deepPurple,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'See all >',
                        style: GoogleFonts.poppins(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Image.asset(
                        'assets/pages_items/skill1.png',
                        width: 48,
                        height: 48,
                      ),
                      title: Text(
                        'Lautech Student Emerge as the best in the FMN Competition',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        'Posted 30 min ago',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: deepPurple,
        onPressed: () => Navigator.pushNamed(context, '/post'),
        child: Image.asset('assets/pages_assets/Message.png',
            width: 22, height: 22),
      ),
      bottomNavigationBar: _buildBottomNavBar(context, deepPurple),
    );
  }

  Widget _buildGridItem(String asset, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
        child:
            const Icon(Icons.arrow_forward_ios, size: 32, color: Colors.grey),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context, Color deepPurple) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2))
      ]),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: deepPurple,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(
              icon: Image.asset('assets/pages_assets/Home (1).png',
                  width: 22, height: 22),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Image.asset('assets/pages_assets/Annotation.png',
                  width: 22, height: 22),
              label: 'Messages'),
          BottomNavigationBarItem(
              icon: Image.asset('assets/pages_assets/Speakerphone.png',
                  width: 22, height: 22),
              label: 'Updates'),
          BottomNavigationBarItem(
              icon: Image.asset('assets/pages_assets/UserCircle.png',
                  width: 22, height: 22),
              label: 'Me'),
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
              Navigator.pushNamed(context, '/me');
              break;
          }
        },
      ),
    );
  }
}

// Curved header clipper
class CurvedHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 60,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

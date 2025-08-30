import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SkillScreen extends StatefulWidget {
  const SkillScreen({super.key});

  @override
  State<SkillScreen> createState() => _SkillScreenState();
}

class _SkillScreenState extends State<SkillScreen> {
  final Color deepPurple = const Color(0xFF6C2786);
  int selectedTab = 0;
  String searchText = '';

  final List<String> tabs = ['General', 'Udemy', 'Cousera', 'Alison'];

  final List<Map<String, dynamic>> allSkills = [
    {
      'img': 'assets/pages_items/skill1.png',
      'title': 'Front End Dev.',
      'desc':
          'Learn Front End Design from scratch both online and onsite and kickstart your tech career',
      'duration': '6 Weeks',
      'mode': 'Online & Onsite',
      'tab': 'General',
    },
    {
      'img': 'assets/pages_assets/skill2.png',
      'title': 'Graphic Design',
      'desc':
          'Learn Graphic Design from scratch both online and onsite and kickstart your tech career',
      'duration': '6 Weeks',
      'mode': 'Online & Onsite',
      'tab': 'Udemy',
    },
    {
      'img': 'assets/pages_assets/skill3.png',
      'title': 'Interior Decoration',
      'desc':
          'Learn Interior Design from scratch both online and onsite and kickstart your tech career',
      'duration': '15 Weeks',
      'mode': 'Online & Onsite',
      'tab': 'Cousera',
    },
  ];

  List<Map<String, dynamic>> get filteredSkills {
    final tabName = tabs[selectedTab];
    return allSkills.where((skill) {
      final matchesTab = skill['tab'] == tabName;
      final matchesSearch = searchText.isEmpty ||
          skill['title']
              .toString()
              .toLowerCase()
              .contains(searchText.toLowerCase()) ||
          skill['desc']
              .toString()
              .toLowerCase()
              .contains(searchText.toLowerCase());
      return matchesTab && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Avatar and Bell
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundImage: AssetImage(
                          'assets/preloader_assets/charco_education.png'),
                    ),
                    Image.asset('assets/pages_assets/Bell.png',
                        width: 28, height: 28),
                  ],
                ),
                const SizedBox(height: 18),
                // Search Bar
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 4)
                          ],
                        ),
                        child: TextField(
                          onChanged: (val) => setState(() => searchText = val),
                          decoration: InputDecoration(
                            hintText: 'Search Courses',
                            hintStyle: GoogleFonts.poppins(
                                color: Colors.grey, fontSize: 15),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 4)
                        ],
                      ),
                      child: const Icon(Icons.search,
                          color: Colors.grey, size: 28),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Greeting
                Text(
                  'Good  day friend!\nTime to Add new Skill',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 18),
                // Tabs
                Row(
                  children: List.generate(tabs.length, (i) {
                    final isSelected = selectedTab == i;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ChoiceChip(
                        label: Text(
                          tabs[i],
                          style: GoogleFonts.poppins(
                            color: isSelected ? Colors.white : Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: deepPurple,
                        backgroundColor: Colors.grey[200],
                        onSelected: (_) => setState(() => selectedTab = i),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 18),
                // Skill Cards (filtered)
                ...filteredSkills.map((skill) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildSkillCard(
                        skill['img'],
                        skill['title'],
                        skill['desc'],
                        skill['duration'],
                        skill['mode'],
                      ),
                    )),
                if (filteredSkills.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text(
                        'No skills found!',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                Center(
                  child: Text(
                    'More Skills Coming soon!',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context, deepPurple),
    );
  }

  Widget _buildSkillCard(
      String img, String title, String desc, String duration, String mode) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: const Color(0xFFF8F6FF),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(img, width: 80, height: 80, fit: BoxFit.cover),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(desc,
                      style: GoogleFonts.poppins(
                          fontSize: 13, color: Colors.grey[700])),
                  const SizedBox(height: 8),
                  Text('Duration : $duration',
                      style: GoogleFonts.poppins(
                          fontSize: 13, fontWeight: FontWeight.w500)),
                  Text('Mode: $mode',
                      style: GoogleFonts.poppins(
                          fontSize: 13, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ],
        ),
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
        currentIndex: 3,
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
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/messages');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/updates');
              break;
            case 3:
              break;
          }
        },
      ),
    );
  }
}

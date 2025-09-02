import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UpdatesScreen extends StatefulWidget {
  const UpdatesScreen({super.key});

  @override
  State<UpdatesScreen> createState() => _UpdatesScreenState();
}

class _UpdatesScreenState extends State<UpdatesScreen> {
  final Color deepPurple = const Color(0xFF6C2786);

  final List<Map<String, String>> updates = [
    {
      'title': 'Vacancy: Project Manager',
      'company': 'Becon Grace Limited',
      'location': 'Abuja, Onsite',
      'experience': '3 years',
      'mode':
          'Send your cv to our email becongrace@gmail.com or send us a message via this App',
      'active': 'true',
    },
    {
      'title': 'Skill Aquisition: Web Development',
      'company': 'Buggybillion',
      'location': 'Ogbomoso, Oyo State, Onsite',
      'requirement': 'A Good System and Strong Internet',
      'how':
          'Send us a message to us via this app to get the registration link.',
      'active': 'true',
    },
    {
      'title': 'Vacancy: Project Manager',
      'company': 'Becon Grace Limited',
      'location': 'Abuja, Onsite',
      'experience': '3 years',
      'mode':
          'Send your cv to our email becongrace@gmail.com or send us a message via this App',
      'active': 'true',
    },
    {
      'title': 'Vacancy: Project Manager',
      'company': 'Becon Grace Limited',
      'location': 'Abuja, Onsite',
      'experience': '3 years',
      'mode':
          'Send your cv to our email becongrace@gmail.com or send us a message via this App',
      'active': 'true',
    },
    {
      'title': 'Vacancy: Project Manager',
      'company': 'Becon Grace Limited',
      'location': 'Abuja, Onsite',
      'experience': '3 years',
      'mode':
          'Send your cv to our email becongrace@gmail.com or send us a message via this App',
      'active': 'false',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Image.asset('assets/pages_assets/ChevronLeftOutline.png',
                width: 24, height: 24),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Text(
            'Updates',
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Image.asset('assets/pages_assets/Bell.png',
                  width: 26, height: 26),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/post'),
                  child: Row(
                    children: [
                      Text(
                        'Add post',
                        style: GoogleFonts.poppins(
                          color: deepPurple,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        icon: Image.asset(
                            'assets/pages_assets/Speakerphone.png',
                            width: 8,
                            height: 8),
                        onPressed: () =>
                            Navigator.pushNamed(context, '/updates'),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: updates.length,
                itemBuilder: (context, index) {
                  final item = updates[index];
                  return _buildUpdateCard(item, deepPurple, context);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context, deepPurple),
    );
  }

  Widget _buildUpdateCard(
      Map<String, String> item, Color deepPurple, BuildContext context) {
    final bool isActive = item['active'] == 'true';
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: isActive ? deepPurple : Colors.grey.shade300,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item['title'] ?? '',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isActive ? deepPurple : Colors.grey,
            ),
          ),
          if (item.containsKey('company'))
            Text(
              'Company: ${item['company']}',
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[800]),
            ),
          if (item.containsKey('location'))
            Text(
              'Location: ${item['location']}',
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[800]),
            ),
          if (item.containsKey('experience'))
            Text(
              'Experience: ${item['experience']}',
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[800]),
            ),
          if (item.containsKey('requirement'))
            Text(
              'Requirement: ${item['requirement']}',
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[800]),
            ),
          if (item.containsKey('how'))
            Text(
              'How to Register: ${item['how']}',
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[800]),
            ),
          if (item.containsKey('mode'))
            Text(
              'Mode of Application: ${item['mode']}',
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[800]),
            ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: isActive ? deepPurple : Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/messages_screen');
              },
              icon: const Icon(Icons.message, color: Colors.white, size: 18),
              label: Text(
                'Message',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
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
        currentIndex: 2,
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
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/me');
              break;
          }
        },
      ),
    );
  }
}

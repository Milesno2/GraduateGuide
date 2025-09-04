import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color deepPurple = const Color(0xFF6C2786);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: deepPurple,
        title: Text('Notifications',
            style: GoogleFonts.poppins(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: Icon(Icons.notifications, color: deepPurple),
              title: Text('Welcome to Graduate Guide!',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              subtitle: Text('Your account was created successfully.',
                  style: GoogleFonts.poppins()),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.notifications, color: deepPurple),
              title: Text('Campus News Update',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              subtitle: Text(
                  'Lautech Student Emerge as the best in the FMN Competition.',
                  style: GoogleFonts.poppins()),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.notifications, color: deepPurple),
              title: Text('Skill Progress',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              subtitle: Text('You have completed 2 new skills this week.',
                  style: GoogleFonts.poppins()),
            ),
          ),
        ],
      ),
    );
  }
}

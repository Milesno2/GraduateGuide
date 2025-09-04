import 'package:flutter/material.dart';
import 'package:newly_graduate_hub/services/supabase_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:google_fonts/google_fonts.dart';
import 'package:newly_graduate_hub/screens/edit_profile_screen.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header image mirroring pages_assets/Me.png style
            SizedBox(
              width: double.infinity,
              height: 160,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset('assets/pages_assets/Me.png', fit: BoxFit.cover),
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: _supabaseService.getCurrentUser(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final user = snapshot.data;
                  if (user == null) {
                    return const Center(child: Text('User not found'));
                  }
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildProfileSection(user),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final updated = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                              );
                              if (updated == true && mounted) setState(() {});
                            },
                            icon: const Icon(Icons.edit),
                            label: Text('Edit Profile', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildSettingsSection(),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: user.userMetadata?['profile_image'] != null
                      ? NetworkImage(user.userMetadata!['profile_image'])
                      : null,
                  child: user.userMetadata?['profile_image'] == null
                      ? Text(user.email?[0].toUpperCase() ?? 'U', style: const TextStyle(fontSize: 32))
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                    child: IconButton(onPressed: _pickImage, icon: const Icon(Icons.camera_alt, color: Colors.white)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(user.userMetadata?['name'] ?? user.email ?? 'User',
                style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(user.email ?? '', style: GoogleFonts.poppins(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Card(
      child: Column(
        children: [
          ListTile(leading: const Icon(Icons.notifications), title: const Text('Notifications'), onTap: () {}),
          ListTile(leading: const Icon(Icons.security), title: const Text('Privacy & Security'), onTap: () {}),
          ListTile(leading: const Icon(Icons.help), title: const Text('Help & Support'), onTap: () {}),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Sign Out', style: TextStyle(color: Colors.red)),
            onTap: _signOut,
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      setState(() => _isLoading = true);
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final user = await _supabaseService.getCurrentUser();
      if (user == null) return;
      final bytes = await image.readAsBytes();
      final String? publicUrl = await SupabaseService().uploadProfileImage(user.id, bytes);
      if (!mounted) return;
      if (publicUrl != null) {
        await SupabaseService().updateUserProfile(user.id, {'profile_image': publicUrl});
        setState(() {});
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Profile image updated successfully!')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating profile image: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signOut() async {
    try {
      await _supabaseService.signOut();
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error signing out: $e')));
    }
  }
}

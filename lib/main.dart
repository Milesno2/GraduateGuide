import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'screens/skill_screen.dart';
import 'screens/preloader_screen_1.dart';
import 'screens/preloader_screen_2.dart';
import 'screens/preloader_screen_3.dart';
import 'screens/preloader_screen_4.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/customer_care_screen.dart';
import 'screens/messages_screen.dart';
import 'screens/resume_builder_screen.dart';
import 'screens/updates_screen.dart';
import 'screens/user_screen.dart';
import 'screens/notification_screen.dart';
import 'screens/career_assistant_screen.dart';
import 'screens/nyscguidelines_screen.dart';
import 'screens/jobs_screen.dart';
import 'screens/masters_update_screen.dart';
import 'screens/skill_progress_screen.dart';
import 'services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService().initialize();
  runApp(const NewlyGraduateHub());
}

class NewlyGraduateHub extends StatelessWidget {
  const NewlyGraduateHub({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Newly Graduate Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          primary: Colors.purple.shade800,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.purple.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.purple.shade600, width: 2),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      initialRoute: '/onboarding',
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/customer-care': (context) => const CustomerCareScreen(),
        '/messages': (context) => const MessagesScreen(),
        '/resume-builder': (context) => const ResumeBuilderScreen(),
        '/updates': (context) => const UpdatesScreen(),
        '/skills': (context) => const SkillsScreen(),
        '/jobs': (context) => const JobsScreen(),
        '/skill-progress': (context) => const SkillProgressScreen(),
        '/tasks': (context) => const TasksScreen(),
        '/masters-update': (context) => const MastersUpdateScreen(),
        '/me': (context) => const UserScreen(),
        '/post': (context) => const PostScreen(),
        '/career-assistant': (context) => const CareerAssistantScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/nysc-guidelines': (context) => const NYSCGuidelinesScreen(),
      },
    );
  }
}

// HomeScreen class moved to home_screen.dart

// Placeholder classes removed - proper screen files are used instead

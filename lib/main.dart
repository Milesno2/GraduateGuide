import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:newly_graduate_hub/services/supabase_service.dart';
import 'package:newly_graduate_hub/screens/home_screen.dart';
import 'package:newly_graduate_hub/screens/login_screen.dart';
import 'package:newly_graduate_hub/screens/register_screen.dart';
import 'package:newly_graduate_hub/screens/messages_screen.dart';
import 'package:newly_graduate_hub/screens/user_screen.dart';
import 'package:newly_graduate_hub/screens/skills_screen.dart';
import 'package:newly_graduate_hub/screens/masters_screen.dart';
import 'package:newly_graduate_hub/screens/jobs_screen.dart';
import 'package:newly_graduate_hub/screens/career_assistant_screen.dart';
import 'package:newly_graduate_hub/screens/nyscguidelines_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Load environment variables
    await dotenv.load(fileName: ".env");
    
    // Initialize Supabase
    await SupabaseService().initialize();
  } catch (e) {
    print('Initialization error: $e');
    // Continue with default values
  }
  
  runApp(const NewlyGraduateHub());
}

class NewlyGraduateHub extends StatelessWidget {
  const NewlyGraduateHub({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: dotenv.env['APP_NAME'] ?? 'Graduate Assistant Hub',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/messages': (context) => const MessagesScreen(),
        '/user': (context) => const UserScreen(),
        '/skills': (context) => const SkillsScreen(),
        '/masters': (context) => const MastersScreen(),
        '/jobs': (context) => const JobsScreen(),
        '/career-assistant': (context) => const CareerAssistantScreen(),
        '/nysc-guidelines': (context) => const NYSCGuidelinesScreen(),
        '/tasks': (context) => const TasksScreen(),
        '/post': (context) => const PostScreen(),
      },
    );
  }
}

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      body: const Center(child: Text('Tasks Screen - Coming Soon')),
    );
  }
}

class PostScreen extends StatelessWidget {
  const PostScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post')),
      body: const Center(child: Text('Post Screen - Coming Soon')),
    );
  }
}

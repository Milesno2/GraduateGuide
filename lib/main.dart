import 'package:flutter/material.dart';
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

  // Global error reporting to avoid blank screens
  FlutterError.onError = (FlutterErrorDetails details) {
    debugPrint('FlutterError: \n${details.exceptionAsString()}');
    FlutterError.presentError(details);
  };

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'A runtime error occurred. Please check the console logs.\n\n${details.exceptionAsString()}',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  };

  try {
    // Initialize Supabase
    await SupabaseService().initialize();
  } catch (e) {
    debugPrint('Initialization error: $e');
  }

  runApp(const NewlyGraduateHub());
}

class NewlyGraduateHub extends StatelessWidget {
  const NewlyGraduateHub({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: const String.fromEnvironment('APP_NAME', defaultValue: 'Graduate Assistant Hub'),
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

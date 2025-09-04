import 'dart:async';
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

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    debugPrint('FlutterError: ${details.exceptionAsString()}');
    FlutterError.presentError(details);
  };

  runZonedGuarded(() {
    runApp(const NewlyGraduateHub());
  }, (error, stack) {
    debugPrint('Zone error: $error');
  });
}

class NewlyGraduateHub extends StatefulWidget {
  const NewlyGraduateHub({super.key});

  @override
  State<NewlyGraduateHub> createState() => _NewlyGraduateHubState();
}

class _NewlyGraduateHubState extends State<NewlyGraduateHub> {
  late final Future<void> _initFuture;
  Object? _initError;

  @override
  void initState() {
    super.initState();
    _initFuture = _initialize();
  }

  Future<void> _initialize() async {
    try {
      await SupabaseService().initialize();
    } catch (e) {
      _initError = e;
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text('Loading...'),
                  ],
                ),
              ),
            ),
          );
        }
        if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Initialization error. Please retry later.\n\n${_initError ?? snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );
        }

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

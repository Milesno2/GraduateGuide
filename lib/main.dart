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
    debugPrint('[FlutterError] ${details.exceptionAsString()}');
    FlutterError.presentError(details);
  };

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      color: Colors.white,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'An error occurred. Please refresh or try again later.\n\n${details.exceptionAsString()}',
              style: const TextStyle(color: Colors.red, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  };

  runZonedGuarded(() {
    runApp(const NewlyGraduateHub());
  }, (error, stack) {
    debugPrint('[ZoneError] $error');
  });
}

class NewlyGraduateHub extends StatefulWidget {
  const NewlyGraduateHub({super.key});

  @override
  State<NewlyGraduateHub> createState() => _NewlyGraduateHubState();
}

class _NewlyGraduateHubState extends State<NewlyGraduateHub> {
  late Future<void> _initFuture = _initialize();
  Object? _initError;

  Future<void> _initialize() async {
    try {
      await SupabaseService().initialize();
    } catch (e) {
      _initError = e;
      rethrow;
    }
  }

  void _retryInit() {
    setState(() {
      _initError = null;
      _initFuture = _initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text('Loading...')
                  ],
                ),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          final message = (_initError ?? snapshot.error).toString();
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              appBar: AppBar(title: const Text('Initialization Error')),
              body: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'The app failed to start. Please check configuration.',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          message,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _retryInit,
                          child: const Text('Retry'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: const String.fromEnvironment('APP_NAME', defaultValue: 'Graduate Assistant Hub'),
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          // Use home instead of initialRoute to avoid route resolution issues on web
          home: const LoginScreen(),
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

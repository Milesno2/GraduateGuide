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
import 'package:newly_graduate_hub/screens/onboarding_screen.dart';
import 'package:newly_graduate_hub/screens/preloader_screen_1.dart';
import 'package:newly_graduate_hub/utils/log_console.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final log = LogConsoleService();
  debugPrint = (String? message, {int? wrapWidth}) {
    if (message != null) log.add(message);
    // Also forward to default stdout
    // ignore: avoid_print
    print(message);
  };

  FlutterError.onError = (FlutterErrorDetails details) {
    log.add('[FlutterError] ${details.exceptionAsString()}');
    FlutterError.presentError(details);
  };

  runZonedGuarded(() {
    runApp(const NewlyGraduateHub());
  }, (error, stack) {
    log.add('[ZoneError] $error');
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
      LogConsoleService().add('Initializing Supabase...');
      await SupabaseService().initialize();
      LogConsoleService().add('Supabase initialized');
    } catch (e) {
      _initError = e;
      LogConsoleService().add('Init error: $e');
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
        Widget child;
        if (snapshot.connectionState == ConnectionState.waiting) {
          child = const _SplashScreen(title: 'Loading...');
        } else if (snapshot.hasError) {
          final message = (_initError ?? snapshot.error).toString();
          child = Scaffold(
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
                      ElevatedButton(onPressed: _retryInit, child: const Text('Retry')),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          child = const RootRouter();
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: const String.fromEnvironment('APP_NAME', defaultValue: 'Graduate Assistant Hub'),
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: Stack(
            children: [
              child,
              const Positioned.fill(child: IgnorePointer(ignoring: true, child: SizedBox.shrink())),
              const LogConsoleOverlay(),
            ],
          ),
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
            '/onboarding': (context) => const OnboardingScreen(),
            '/preload-1': (context) => const PreloaderScreen1(),
          },
        );
      },
    );
  }
}

class RootRouter extends StatefulWidget {
  const RootRouter({super.key});

  @override
  State<RootRouter> createState() => _RootRouterState();
}

class _RootRouterState extends State<RootRouter> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      LogConsoleService().add('Routing to onboarding...');
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/onboarding');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const _SplashScreen(title: 'Starting...');
  }
}

class _SplashScreen extends StatelessWidget {
  final String title;
  const _SplashScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 42, height: 42, child: CircularProgressIndicator()),
            const SizedBox(height: 12),
            Text(title),
          ],
        ),
      ),
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

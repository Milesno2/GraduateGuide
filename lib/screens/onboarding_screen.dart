import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final Color deepPurple = const Color(0xFF6C2786);

  final List<_OnboardingPageData> _pages = [
    _OnboardingPageData(
      image: 'assets/preloader_assets/fresh_folk_teaching.png',
      description:
          'With graduate guide you get to know the necessary documents needed to further yourself into Master program.',
      button: 'NEXT',
    ),
    _OnboardingPageData(
      image: 'assets/preloader_assets/charco_education.png',
      description:
          'Graduate guide is an application design to assist graduate to navigate their next stage of their life.',
      button: 'NEXT',
    ),
    _OnboardingPageData(
      image: 'assets/preloader_assets/happy_bunch_chat.png',
      description:
          'With Graduate guide you get to have available information on the available job offers.',
      button: 'NEXT',
    ),
    _OnboardingPageData(
      image: 'assets/preloader_assets/ola_playing_video_games.png',
      description:
          'With Graduate guide you get to have access to a guide o how to build a solid and standard resume.',
      button: 'REGISTER',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/register');
    }
  }

  void _skipToRegister() {
    Navigator.pushReplacementNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 16, right: 24),
                child: GestureDetector(
                  onTap: _skipToRegister,
                  child: Text(
                    'Skip',
                    style: GoogleFonts.poppins(
                      color: deepPurple,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        // Illustration
                        Center(
                          child: Image.asset(
                            page.image,
                            width: 220,
                            height: 220,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Description
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            page.description,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        const Spacer(),
                        // Progress indicator
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _pages.length,
                            (dotIndex) => _buildDot(dotIndex == _currentPage),
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Next/Register button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: deepPurple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            onPressed: _nextPage,
                            child: Text(
                              page.button,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
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

  Widget _buildDot(bool isActive) {
    final Color deepPurple = const Color(0xFF6C2786);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 32 : 16,
      height: 6,
      decoration: BoxDecoration(
        color: isActive ? deepPurple : deepPurple.withOpacity(0.15),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class _OnboardingPageData {
  final String image;
  final String description;
  final String button;

  _OnboardingPageData({
    required this.image,
    required this.description,
    required this.button,
  });
}

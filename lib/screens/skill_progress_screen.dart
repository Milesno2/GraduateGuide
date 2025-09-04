import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newly_graduate_hub/services/supabase_service.dart';

class SkillProgressScreen extends StatefulWidget {
  const SkillProgressScreen({super.key});

  @override
  State<SkillProgressScreen> createState() => _SkillProgressScreenState();
}

class _SkillProgressScreenState extends State<SkillProgressScreen> {
  final Color deepPurple = const Color(0xFF6C2786);
  final SupabaseService _supabaseService = SupabaseService();
  
  List<Map<String, dynamic>> _skills = [];
  bool _isLoading = true;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadSkills();
  }

  Future<void> _loadSkills() async {
    setState(() {
      _isLoading = true;
    });

    final user = _supabaseService.getCurrentUser();
    if (user != null) {
      _currentUserId = user.id;
    }

    // Mock skill data - in real app, this would come from backend
    await Future.delayed(const Duration(milliseconds: 800));
    
    setState(() {
      _skills = [
        {
          'id': '1',
          'name': 'Flutter Development',
          'category': 'Programming',
          'progress': 75,
          'level': 'Intermediate',
          'description': 'Mobile app development with Flutter framework',
          'icon': Icons.phone_android,
          'color': Colors.blue,
          'completed_lessons': 15,
          'total_lessons': 20,
          'last_activity': DateTime.now().subtract(const Duration(days: 2)),
          'certificate_earned': false,
          'next_milestone': 'Complete Advanced Flutter Concepts',
        },
        {
          'id': '2',
          'name': 'UI/UX Design',
          'category': 'Design',
          'progress': 45,
          'level': 'Beginner',
          'description': 'User interface and user experience design',
          'icon': Icons.design_services,
          'color': Colors.purple,
          'completed_lessons': 9,
          'total_lessons': 20,
          'last_activity': DateTime.now().subtract(const Duration(days: 5)),
          'certificate_earned': false,
          'next_milestone': 'Complete Design Fundamentals',
        },
        {
          'id': '3',
          'name': 'Data Analysis',
          'category': 'Analytics',
          'progress': 90,
          'level': 'Advanced',
          'description': 'Data analysis and visualization techniques',
          'icon': Icons.analytics,
          'color': Colors.green,
          'completed_lessons': 18,
          'total_lessons': 20,
          'last_activity': DateTime.now().subtract(const Duration(hours: 6)),
          'certificate_earned': true,
          'next_milestone': 'Earn Advanced Certification',
        },
        {
          'id': '4',
          'name': 'Project Management',
          'category': 'Business',
          'progress': 60,
          'level': 'Intermediate',
          'description': 'Project planning and management methodologies',
          'icon': Icons.assignment,
          'color': Colors.orange,
          'completed_lessons': 12,
          'total_lessons': 20,
          'last_activity': DateTime.now().subtract(const Duration(days: 1)),
          'certificate_earned': false,
          'next_milestone': 'Complete PMP Preparation',
        },
        {
          'id': '5',
          'name': 'Digital Marketing',
          'category': 'Marketing',
          'progress': 30,
          'level': 'Beginner',
          'description': 'Digital marketing strategies and tools',
          'icon': Icons.trending_up,
          'color': Colors.red,
          'completed_lessons': 6,
          'total_lessons': 20,
          'last_activity': DateTime.now().subtract(const Duration(days: 7)),
          'certificate_earned': false,
          'next_milestone': 'Complete Basic Marketing Course',
        },
      ];
      _isLoading = false;
    });
  }

  String _getTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  Color _getProgressColor(int progress) {
    if (progress >= 80) return Colors.green;
    if (progress >= 60) return Colors.orange;
    if (progress >= 40) return Colors.blue;
    return Colors.red;
  }

  Widget _buildSkillCard(Map<String, dynamic> skill) {
    final progress = skill['progress'] as int;
    final progressColor = _getProgressColor(progress);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with skill info
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: skill['color'].withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: skill['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    skill['icon'],
                    color: skill['color'],
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              skill['name'],
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          if (skill['certificate_earned'])
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'CERTIFIED',
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        skill['category'],
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: skill['color'],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: skill['color'].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: skill['color'].withOpacity(0.3)),
                        ),
                        child: Text(
                          skill['level'],
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: skill['color'],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Progress section
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  skill['description'],
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 20),
                
                // Progress stats
                Row(
                  children: [
                    Expanded(
                      child: _buildProgressStat('Progress', '$progress%', progressColor),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildProgressStat('Lessons', '${skill['completed_lessons']}/${skill['total_lessons']}', deepPurple),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildProgressStat('Last Activity', _getTimeAgo(skill['last_activity']), Colors.grey[600]!),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Progress bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Course Progress',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: deepPurple,
                          ),
                        ),
                        Text(
                          '$progress%',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: progressColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: progress / 100,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Next milestone
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.amber[700], size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Next Milestone',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: Colors.amber[700],
                              ),
                            ),
                            Text(
                              skill['next_milestone'],
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _continueLearning(skill),
                        icon: Icon(Icons.play_arrow, size: 16),
                        label: Text('Continue', style: GoogleFonts.poppins(fontSize: 12)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: deepPurple,
                          side: BorderSide(color: deepPurple),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _takeAssessment(skill),
                        icon: Icon(Icons.quiz, size: 16),
                        label: Text('Assessment', style: GoogleFonts.poppins(fontSize: 12)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: deepPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _continueLearning(Map<String, dynamic> skill) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Continuing ${skill['name']} lessons...',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: deepPurple,
      ),
    );
  }

  void _takeAssessment(Map<String, dynamic> skill) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Starting ${skill['name']} assessment...',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: deepPurple,
        title: Row(
          children: [
            Image.asset(
              'assets/pages_assets/skill Progress.png',
              width: 24,
              height: 24,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              'Skill Progress',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _skills.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/pages_assets/skill Progress.png',
                        width: 120,
                        height: 120,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No skills in progress',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Start learning new skills to track your progress',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, '/skills'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: deepPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Explore Skills',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadSkills,
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      // Header Section
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: deepPurple,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/pages_assets/skill Progress.png',
                              width: 80,
                              height: 80,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Your Learning Journey',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Track your progress and continue building your career',
                              style: GoogleFonts.poppins(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Skills List
                      ..._skills.map((skill) => _buildSkillCard(skill)),
                      
                      const SizedBox(height: 24),

                      // Quick Actions
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Quick Actions',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: deepPurple,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () => Navigator.pushNamed(context, '/skills'),
                                    icon: Icon(Icons.add, size: 16),
                                    label: Text('Add Skill', style: GoogleFonts.poppins(fontSize: 12)),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: deepPurple,
                                      side: BorderSide(color: deepPurple),
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => _loadSkills(),
                                    icon: Icon(Icons.refresh, size: 16),
                                    label: Text('Refresh', style: GoogleFonts.poppins(fontSize: 12)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: deepPurple,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
    );
  }
}
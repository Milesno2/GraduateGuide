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
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: skill['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    skill['icon'],
                    color: skill['color'],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        skill['name'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        skill['category'],
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
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
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: skill['color'],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _showSkillDetails(skill),
                  icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              skill['description'],
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Progress',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
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
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lessons',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${skill['completed_lessons']}/${skill['total_lessons']}',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: deepPurple,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Last Activity',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getTimeAgo(skill['last_activity']),
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              minHeight: 8,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _continueLearning(skill),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: deepPurple,
                      side: BorderSide(color: deepPurple),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Continue',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _takeAssessment(skill),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: deepPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Assessment',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSkillDetails(Map<String, dynamic> skill) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: skill['color'].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            skill['icon'],
                            color: skill['color'],
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                skill['name'],
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                skill['category'],
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Progress Overview',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildProgressItem('Current Level', skill['level']),
                    _buildProgressItem('Progress', '${skill['progress']}%'),
                    _buildProgressItem('Lessons Completed', '${skill['completed_lessons']}/${skill['total_lessons']}'),
                    _buildProgressItem('Last Activity', _getTimeAgo(skill['last_activity'])),
                    const SizedBox(height: 24),
                    Text(
                      'Learning Path',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildLearningStep('1', 'Complete remaining lessons', skill['total_lessons'] - skill['completed_lessons']),
                    _buildLearningStep('2', 'Take skill assessment', 1),
                    _buildLearningStep('3', 'Complete practical project', 1),
                    _buildLearningStep('4', 'Earn certification', 1),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _continueLearning(skill);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: deepPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Continue Learning',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: deepPurple,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLearningStep(String number, String description, int remaining) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: remaining > 0 ? Colors.grey[300] : Colors.green,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                number,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: remaining > 0 ? Colors.grey[600] : Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              description,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: remaining > 0 ? Colors.grey[700] : Colors.green,
              ),
            ),
          ),
          if (remaining > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$remaining remaining',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: Colors.orange,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
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
              'assets/pages_items/task.png',
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
                      Icon(
                        Icons.school_outlined,
                        size: 64,
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
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Header Section
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: deepPurple,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.trending_up,
                              size: 48,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Your Learning Journey',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Track your progress and continue learning',
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
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Quick Actions',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
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
                                        padding: const EdgeInsets.symmetric(vertical: 8),
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
                                        padding: const EdgeInsets.symmetric(vertical: 8),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
    );
  }
}
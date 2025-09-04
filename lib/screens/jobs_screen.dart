import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newly_graduate_hub/services/supabase_service.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  final Color deepPurple = const Color(0xFF6C2786);
  final SupabaseService _supabaseService = SupabaseService();
  final TextEditingController _searchController = TextEditingController();
  
  List<Map<String, dynamic>> _jobs = [];
  List<Map<String, dynamic>> _filteredJobs = [];
  bool _isLoading = true;
  String _selectedCategory = 'All';
  String? _currentUserId;

  final List<String> _categories = [
    'All',
    'Technology',
    'Finance',
    'Healthcare',
    'Education',
    'Marketing',
    'Engineering',
    'Design',
    'Sales',
    'Administration',
  ];

  @override
  void initState() {
    super.initState();
    _loadJobs();
    _searchController.addListener(_filterJobs);
  }

  Future<void> _loadJobs() async {
    setState(() {
      _isLoading = true;
    });

    final user = _supabaseService.getCurrentUser();
    if (user != null) {
      _currentUserId = user.id;
    }

    // Mock job data - in real app, this would come from backend
    await Future.delayed(const Duration(milliseconds: 800));
    
    setState(() {
      _jobs = [
        {
          'id': '1',
          'title': 'Software Developer',
          'company': 'TechCorp Nigeria',
          'location': 'Lagos, Nigeria',
          'salary': '₦150,000 - ₦250,000',
          'type': 'Full-time',
          'category': 'Technology',
          'description': 'We are looking for a skilled software developer to join our team. Experience with Flutter, React, and Node.js required.',
          'requirements': [
            'Bachelor\'s degree in Computer Science or related field',
            '2+ years of experience in software development',
            'Proficiency in Flutter, React, and Node.js',
            'Strong problem-solving skills',
            'Good communication skills',
          ],
          'posted_date': DateTime.now().subtract(const Duration(days: 2)),
          'is_featured': true,
          'logo': 'assets/pages_items/job.png',
        },
        {
          'id': '2',
          'title': 'Data Analyst',
          'company': 'DataFlow Solutions',
          'location': 'Abuja, Nigeria',
          'salary': '₦120,000 - ₦180,000',
          'type': 'Full-time',
          'category': 'Technology',
          'description': 'Join our data team to help analyze business metrics and provide insights for decision making.',
          'requirements': [
            'Bachelor\'s degree in Statistics, Mathematics, or related field',
            'Experience with SQL and Python',
            'Knowledge of data visualization tools',
            'Analytical thinking',
            'Attention to detail',
          ],
          'posted_date': DateTime.now().subtract(const Duration(days: 1)),
          'is_featured': false,
          'logo': 'assets/pages_items/job.png',
        },
        {
          'id': '3',
          'title': 'UX/UI Designer',
          'company': 'Creative Studios',
          'location': 'Port Harcourt, Nigeria',
          'salary': '₦100,000 - ₦150,000',
          'type': 'Contract',
          'category': 'Design',
          'description': 'Create beautiful and functional user interfaces for web and mobile applications.',
          'requirements': [
            'Portfolio showcasing design work',
            'Experience with Figma and Adobe Creative Suite',
            'Understanding of user-centered design principles',
            'Knowledge of design systems',
            'Collaborative mindset',
          ],
          'posted_date': DateTime.now().subtract(const Duration(hours: 6)),
          'is_featured': true,
          'logo': 'assets/pages_items/job.png',
        },
        {
          'id': '4',
          'title': 'Marketing Specialist',
          'company': 'Growth Marketing Ltd',
          'location': 'Kano, Nigeria',
          'salary': '₦80,000 - ₦120,000',
          'type': 'Full-time',
          'category': 'Marketing',
          'description': 'Develop and execute marketing strategies to drive brand awareness and customer acquisition.',
          'requirements': [
            'Bachelor\'s degree in Marketing or related field',
            'Experience with digital marketing tools',
            'Strong analytical skills',
            'Creative thinking',
            'Excellent communication skills',
          ],
          'posted_date': DateTime.now().subtract(const Duration(days: 3)),
          'is_featured': false,
          'logo': 'assets/pages_items/job.png',
        },
        {
          'id': '5',
          'title': 'DevOps Engineer',
          'company': 'CloudTech Solutions',
          'location': 'Remote',
          'salary': '₦200,000 - ₦300,000',
          'type': 'Full-time',
          'category': 'Technology',
          'description': 'Build and maintain our cloud infrastructure and deployment pipelines.',
          'requirements': [
            'Experience with AWS, Azure, or GCP',
            'Knowledge of Docker and Kubernetes',
            'Experience with CI/CD pipelines',
            'Linux system administration skills',
            'Automation mindset',
          ],
          'posted_date': DateTime.now().subtract(const Duration(hours: 12)),
          'is_featured': true,
          'logo': 'assets/pages_items/job.png',
        },
      ];
      _filteredJobs = _jobs;
      _isLoading = false;
    });
  }

  void _filterJobs() {
    final searchTerm = _searchController.text.toLowerCase();
    final categoryFilter = _selectedCategory == 'All' ? null : _selectedCategory;

    setState(() {
      _filteredJobs = _jobs.where((job) {
        final matchesSearch = job['title'].toLowerCase().contains(searchTerm) ||
            job['company'].toLowerCase().contains(searchTerm) ||
            job['location'].toLowerCase().contains(searchTerm);
        
        final matchesCategory = categoryFilter == null || job['category'] == categoryFilter;
        
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _filterJobs();
  }

  String _getTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else {
      return 'Just posted';
    }
  }

  void _showJobDetails(Map<String, dynamic> job) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
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
                            color: deepPurple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image.asset(
                            job['logo'],
                            width: 40,
                            height: 40,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                job['title'],
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                job['company'],
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: deepPurple,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                job['location'],
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
                    Row(
                      children: [
                        _buildJobTag(job['type'], Colors.green),
                        const SizedBox(width: 8),
                        _buildJobTag(job['category'], deepPurple),
                        const SizedBox(width: 8),
                        _buildJobTag(job['salary'], Colors.orange),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Job Description',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      job['description'],
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Requirements',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...job['requirements'].map((req) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check_circle, size: 16, color: Colors.green),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              req,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _applyForJob(job);
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
                          'Apply Now',
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

  Widget _buildJobTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  void _applyForJob(Map<String, dynamic> job) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Application submitted for ${job['title']} at ${job['company']}',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'View',
          textColor: Colors.white,
          onPressed: () {
            // Navigate to applications screen
          },
        ),
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
              'assets/pages_items/job.png',
              width: 24,
              height: 24,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              'Job Opportunities',
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
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search jobs, companies, or locations...',
                    hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: deepPurple, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
                const SizedBox(height: 16),
                // Category Filter
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = category == _selectedCategory;
                      
                      return Container(
                        margin: EdgeInsets.only(right: index < _categories.length - 1 ? 8 : 0),
                        child: FilterChip(
                          label: Text(
                            category,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? Colors.white : deepPurple,
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (_) => _onCategoryChanged(category),
                          backgroundColor: Colors.grey[100],
                          selectedColor: deepPurple,
                          checkmarkColor: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Job Listings
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredJobs.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.work_outline,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No jobs found',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try adjusting your search or filters',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _filteredJobs.length,
                        itemBuilder: (context, index) {
                          final job = _filteredJobs[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: deepPurple.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Image.asset(
                                  job['logo'],
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                              title: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      job['title'],
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  if (job['is_featured'])
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'Featured',
                                        style: GoogleFonts.poppins(
                                          fontSize: 10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(
                                    job['company'],
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: deepPurple,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    job['location'],
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      _buildJobTag(job['type'], Colors.green),
                                      const SizedBox(width: 8),
                                      _buildJobTag(job['salary'], Colors.orange),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _getTimeAgo(job['posted_date']),
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () => _showJobDetails(job),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
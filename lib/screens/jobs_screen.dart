import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:newly_graduate_hub/services/supabase_service.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  final Color deepPurple = const Color(0xFF6C2786);
  final SupabaseService _supabaseService = SupabaseService();
  
  String searchText = '';
  String selectedCategory = 'All';
  List<Map<String, dynamic>> _jobs = [];
  bool _isLoading = true;

  final List<String> categories = [
    'All',
    'Technology',
    'Finance',
    'Healthcare',
    'Education',
    'Manufacturing',
    'Oil & Gas',
    'Telecommunications',
    'Consulting',
    'Marketing',
  ];

  final List<Map<String, dynamic>> nigerianJobs = [
    {
      'id': '1',
      'title': 'Software Developer',
      'company': 'Flutterwave',
      'location': 'Lagos, Nigeria',
      'type': 'Full-time',
      'salary': '₦300,000 - ₦500,000',
      'experience': '2-4 years',
      'category': 'Technology',
      'description': 'We are looking for a skilled Software Developer to join our team. You will be responsible for developing and maintaining web applications using modern technologies.',
      'requirements': [
        'Bachelor\'s degree in Computer Science or related field',
        'Proficiency in JavaScript, Python, or Java',
        'Experience with React, Node.js, or Django',
        'Strong problem-solving skills',
        'Good communication skills',
      ],
      'benefits': [
        'Health insurance',
        'Flexible working hours',
        'Remote work options',
        'Professional development',
        'Performance bonuses',
      ],
      'logo': 'assets/pages_items/fmn_logo.png',
      'posted': '2 days ago',
      'applications': 45,
    },
    {
      'id': '2',
      'title': 'Financial Analyst',
      'company': 'GTBank',
      'location': 'Lagos, Nigeria',
      'type': 'Full-time',
      'salary': '₦250,000 - ₦400,000',
      'experience': '1-3 years',
      'category': 'Finance',
      'description': 'Join our finance team to analyze financial data, prepare reports, and provide insights to support business decisions.',
      'requirements': [
        'Bachelor\'s degree in Finance, Accounting, or Economics',
        'Strong analytical and Excel skills',
        'Knowledge of financial modeling',
        'Attention to detail',
        'Professional certification (ACCA, CFA) preferred',
      ],
      'benefits': [
        'Competitive salary',
        'Health insurance',
        'Pension scheme',
        'Annual leave',
        'Training opportunities',
      ],
      'logo': 'assets/pages_items/fmn_logo.png',
      'posted': '1 week ago',
      'applications': 32,
    },
    {
      'id': '3',
      'title': 'Medical Officer',
      'company': 'Lagos University Teaching Hospital',
      'location': 'Lagos, Nigeria',
      'type': 'Full-time',
      'salary': '₦400,000 - ₦600,000',
      'experience': '3-5 years',
      'category': 'Healthcare',
      'description': 'Provide medical care to patients, conduct examinations, and collaborate with healthcare teams.',
      'requirements': [
        'MBBS degree from recognized institution',
        'Valid medical license',
        'Residency training completed',
        'Experience in general practice',
        'Good bedside manner',
      ],
      'benefits': [
        'Comprehensive health coverage',
        'Housing allowance',
        'Transport allowance',
        'Continuing education',
        'Research opportunities',
      ],
      'logo': 'assets/pages_items/fmn_logo.png',
      'posted': '3 days ago',
      'applications': 28,
    },
    {
      'id': '4',
      'title': 'Marketing Specialist',
      'company': 'MTN Nigeria',
      'location': 'Lagos, Nigeria',
      'type': 'Full-time',
      'salary': '₦350,000 - ₦550,000',
      'experience': '4-6 years',
      'category': 'Marketing',
      'description': 'Develop and execute marketing strategies to promote our products and services in the Nigerian market.',
      'requirements': [
        'Bachelor\'s degree in Marketing or Business',
        'Proven marketing experience',
        'Digital marketing skills',
        'Strong leadership abilities',
        'Excellent communication skills',
      ],
      'benefits': [
        'Attractive salary package',
        'Performance bonuses',
        'Health insurance',
        'Phone and data allowance',
        'Career growth opportunities',
      ],
      'logo': 'assets/pages_items/fmn_logo.png',
      'posted': '5 days ago',
      'applications': 67,
    },
    {
      'id': '5',
      'title': 'Civil Engineer',
      'company': 'Julius Berger Nigeria',
      'location': 'Abuja, Nigeria',
      'type': 'Full-time',
      'salary': '₦400,000 - ₦650,000',
      'experience': '3-5 years',
      'category': 'Manufacturing',
      'description': 'Design and oversee construction projects, ensure quality standards, and manage project timelines.',
      'requirements': [
        'Bachelor\'s degree in Civil Engineering',
        'Professional engineering license',
        'Experience in construction management',
        'AutoCAD proficiency',
        'Project management skills',
      ],
      'benefits': [
        'Competitive salary',
        'Housing allowance',
        'Transport allowance',
        'Professional development',
        'Health insurance',
      ],
      'logo': 'assets/pages_items/fmn_logo.png',
      'posted': '1 week ago',
      'applications': 23,
    },
    {
      'id': '6',
      'title': 'Data Scientist',
      'company': 'Interswitch',
      'location': 'Lagos, Nigeria',
      'type': 'Full-time',
      'salary': '₦450,000 - ₦700,000',
      'experience': '2-4 years',
      'category': 'Technology',
      'description': 'Analyze large datasets to extract insights and develop predictive models for business decisions.',
      'requirements': [
        'Master\'s degree in Data Science or Statistics',
        'Proficiency in Python, R, or SQL',
        'Machine learning experience',
        'Statistical analysis skills',
        'Business acumen',
      ],
      'benefits': [
        'High salary package',
        'Stock options',
        'Flexible work arrangements',
        'Learning budget',
        'Conference attendance',
      ],
      'logo': 'assets/pages_items/fmn_logo.png',
      'posted': '4 days ago',
      'applications': 38,
    },
    {
      'id': '7',
      'title': 'Business Consultant',
      'company': 'KPMG Nigeria',
      'location': 'Lagos, Nigeria',
      'type': 'Full-time',
      'salary': '₦300,000 - ₦500,000',
      'experience': '3-5 years',
      'category': 'Consulting',
      'description': 'Provide strategic advice to clients, conduct business analysis, and develop improvement recommendations.',
      'requirements': [
        'Bachelor\'s degree in Business or related field',
        'Consulting experience preferred',
        'Strong analytical skills',
        'Excellent presentation skills',
        'Problem-solving abilities',
      ],
      'benefits': [
        'Competitive salary',
        'Performance bonuses',
        'Health insurance',
        'Professional development',
        'Travel opportunities',
      ],
      'logo': 'assets/pages_items/fmn_logo.png',
      'posted': '6 days ago',
      'applications': 41,
    },
    {
      'id': '8',
      'title': 'Petroleum Engineer',
      'company': 'Shell Nigeria',
      'location': 'Port Harcourt, Nigeria',
      'type': 'Full-time',
      'salary': '₦600,000 - ₦900,000',
      'experience': '4-6 years',
      'category': 'Oil & Gas',
      'description': 'Design and optimize oil and gas production systems, ensure safety standards, and maximize efficiency.',
      'requirements': [
        'Bachelor\'s degree in Petroleum Engineering',
        'Experience in upstream operations',
        'Knowledge of production optimization',
        'Safety certification',
        'Team leadership skills',
      ],
      'benefits': [
        'Excellent salary package',
        'Housing allowance',
        'Transport allowance',
        'Health insurance',
        'International opportunities',
      ],
      'logo': 'assets/pages_items/fmn_logo.png',
      'posted': '2 weeks ago',
      'applications': 19,
    },
    {
      'id': '9',
      'title': 'Network Engineer',
      'company': 'Airtel Nigeria',
      'location': 'Lagos, Nigeria',
      'type': 'Full-time',
      'salary': '₦350,000 - ₦550,000',
      'experience': '2-4 years',
      'category': 'Telecommunications',
      'description': 'Design, implement, and maintain network infrastructure to ensure optimal performance and reliability.',
      'requirements': [
        'Bachelor\'s degree in Computer Engineering or IT',
        'CCNA or CCNP certification',
        'Network administration experience',
        'Troubleshooting skills',
        'Knowledge of telecom protocols',
      ],
      'benefits': [
        'Competitive salary',
        'Health insurance',
        'Phone and data allowance',
        'Training opportunities',
        'Career advancement',
      ],
      'logo': 'assets/pages_items/fmn_logo.png',
      'posted': '1 week ago',
      'applications': 34,
    },
    {
      'id': '10',
      'title': 'Lecturer',
      'company': 'University of Lagos',
      'location': 'Lagos, Nigeria',
      'type': 'Full-time',
      'salary': '₦250,000 - ₦400,000',
      'experience': '3-5 years',
      'category': 'Education',
      'description': 'Teach undergraduate and postgraduate courses, conduct research, and contribute to academic development.',
      'requirements': [
        'PhD in relevant field',
        'Teaching experience',
        'Research publications',
        'Excellent communication skills',
        'Commitment to academic excellence',
      ],
      'benefits': [
        'Academic freedom',
        'Research funding',
        'Conference attendance',
        'Health insurance',
        'Housing allowance',
      ],
      'logo': 'assets/pages_items/fmn_logo.png',
      'posted': '3 weeks ago',
      'applications': 15,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));
    
    setState(() {
      _jobs = nigerianJobs;
      _isLoading = false;
    });
  }

  List<Map<String, dynamic>> get filteredJobs {
    return _jobs.where((job) {
      final matchesCategory = selectedCategory == 'All' || job['category'] == selectedCategory;
      final matchesSearch = searchText.isEmpty ||
          job['title'].toString().toLowerCase().contains(searchText.toLowerCase()) ||
          job['company'].toString().toLowerCase().contains(searchText.toLowerCase()) ||
          job['location'].toString().toLowerCase().contains(searchText.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _showJobDetails(Map<String, dynamic> job) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
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
                    // Job Header
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            job['logo'],
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
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
                                  fontSize: 20,
                                  color: deepPurple,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                job['company'],
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                                  const SizedBox(width: 4),
                                  Text(
                                    job['location'],
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Job Details
                    Row(
                      children: [
                        Expanded(
                          child: _buildDetailCard('Salary', job['salary'], Icons.attach_money, Colors.green),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildDetailCard('Experience', job['experience'], Icons.work, Colors.blue),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildDetailCard('Type', job['type'], Icons.schedule, Colors.orange),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Description
                    Text(
                      'Job Description',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: deepPurple,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      job['description'],
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Requirements
                    Text(
                      'Requirements',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: deepPurple,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...job['requirements'].map<Widget>((req) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.check_circle, size: 16, color: Colors.green),
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
                    )).toList(),
                    
                    const SizedBox(height: 24),
                    
                    // Benefits
                    Text(
                      'Benefits',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: deepPurple,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...job['benefits'].map<Widget>((benefit) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              benefit,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )).toList(),
                    
                    const SizedBox(height: 32),
                    
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: deepPurple,
                              side: BorderSide(color: deepPurple),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Save Job',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
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
          fontSize: 10,
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
          label: 'View Applications',
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
          // Header Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: deepPurple,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Find Your Dream Job',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Discover opportunities with top Nigerian companies',
                  style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    onChanged: (val) => setState(() => searchText = val),
                    decoration: InputDecoration(
                      hintText: 'Search jobs, companies, or locations...',
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.grey[500],
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey[500],
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Category Filters
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((category) {
                  final isSelected = selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: FilterChip(
                      label: Text(
                        category,
                        style: GoogleFonts.poppins(
                          color: isSelected ? Colors.white : Colors.grey[700],
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: deepPurple,
                      backgroundColor: Colors.white,
                      side: BorderSide(
                        color: isSelected ? deepPurple : Colors.grey[300]!,
                      ),
                      onSelected: (_) => setState(() => selectedCategory = category),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          
          // Jobs List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredJobs.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/pages_items/job.png',
                              width: 120,
                              height: 120,
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
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: filteredJobs.length,
                        itemBuilder: (context, index) {
                          final job = filteredJobs[index];
                          return _buildJobCard(job);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(Map<String, dynamic> job) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: InkWell(
        onTap: () => _showJobDetails(job),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      job['logo'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job['title'],
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: deepPurple,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          job['company'],
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildJobTag(job['type'], Colors.green),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Location and Posted
              Row(
                children: [
                  Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    job['location'],
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    job['posted'],
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Salary and Experience
              Row(
                children: [
                  Icon(Icons.attach_money, size: 14, color: Colors.green[600]),
                  const SizedBox(width: 4),
                  Text(
                    job['salary'],
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.green[600],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.work, size: 14, color: Colors.blue[600]),
                  const SizedBox(width: 4),
                  Text(
                    job['experience'],
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.blue[600],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Category and Applications
              Row(
                children: [
                  _buildJobTag(job['category'], deepPurple),
                  const Spacer(),
                  Text(
                    '${job['applications']} applications',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
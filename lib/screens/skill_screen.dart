import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SkillScreen extends StatefulWidget {
  const SkillScreen({super.key});

  @override
  State<SkillScreen> createState() => _SkillScreenState();
}

class _SkillScreenState extends State<SkillScreen> {
  final Color deepPurple = const Color(0xFF6C2786);
  int selectedTab = 0;
  String searchText = '';

  final List<String> tabs = ['All Skills', 'Technology', 'Design', 'Business', 'Marketing'];

  final List<Map<String, dynamic>> allSkills = [
    {
      'id': 'skill1',
      'img': 'assets/pages_items/skill1.png',
      'title': 'Front End Development',
      'desc': 'Master HTML, CSS, JavaScript, React, and modern web development frameworks',
      'duration': '8 Weeks',
      'mode': 'Online & Onsite',
      'category': 'Technology',
      'level': 'Beginner to Advanced',
      'price': '₦150,000',
      'instructor': 'Tech Academy Nigeria',
      'rating': 4.8,
      'students': 1250,
      'certificate': true,
    },
    {
      'id': 'skill2',
      'img': 'assets/pages_items/skill2.png',
      'title': 'Graphic Design',
      'desc': 'Learn Adobe Creative Suite, UI/UX design principles, and digital art creation',
      'duration': '6 Weeks',
      'mode': 'Online & Onsite',
      'category': 'Design',
      'level': 'Beginner to Intermediate',
      'price': '₦120,000',
      'instructor': 'Creative Design Institute',
      'rating': 4.7,
      'students': 890,
      'certificate': true,
    },
    {
      'id': 'skill3',
      'img': 'assets/pages_items/skill3.png',
      'title': 'Interior Decoration',
      'desc': 'Master interior design principles, space planning, and decorative techniques',
      'duration': '10 Weeks',
      'mode': 'Online & Onsite',
      'category': 'Design',
      'level': 'Beginner to Advanced',
      'price': '₦180,000',
      'instructor': 'Interior Design Academy',
      'rating': 4.6,
      'students': 650,
      'certificate': true,
    },
    {
      'id': 'skill4',
      'img': 'assets/pages_items/skill1.png',
      'title': 'Digital Marketing',
      'desc': 'Learn SEO, social media marketing, content creation, and analytics',
      'duration': '6 Weeks',
      'mode': 'Online',
      'category': 'Marketing',
      'level': 'Beginner to Intermediate',
      'price': '₦100,000',
      'instructor': 'Digital Marketing Pro',
      'rating': 4.5,
      'students': 1100,
      'certificate': true,
    },
    {
      'id': 'skill5',
      'img': 'assets/pages_items/skill2.png',
      'title': 'Project Management',
      'desc': 'Master Agile, Scrum, and traditional project management methodologies',
      'duration': '8 Weeks',
      'mode': 'Online & Onsite',
      'category': 'Business',
      'level': 'Intermediate to Advanced',
      'price': '₦200,000',
      'instructor': 'Business Management Institute',
      'rating': 4.9,
      'students': 750,
      'certificate': true,
    },
    {
      'id': 'skill6',
      'img': 'assets/pages_items/skill3.png',
      'title': 'Data Analysis',
      'desc': 'Learn Excel, SQL, Python, and data visualization tools',
      'duration': '10 Weeks',
      'mode': 'Online',
      'category': 'Technology',
      'level': 'Beginner to Advanced',
      'price': '₦160,000',
      'instructor': 'Data Science Academy',
      'rating': 4.8,
      'students': 920,
      'certificate': true,
    },
  ];

  List<Map<String, dynamic>> get filteredSkills {
    final tabName = tabs[selectedTab];
    return allSkills.where((skill) {
      final matchesTab = tabName == 'All Skills' || skill['category'] == tabName;
      final matchesSearch = searchText.isEmpty ||
          skill['title']
              .toString()
              .toLowerCase()
              .contains(searchText.toLowerCase()) ||
          skill['desc']
              .toString()
              .toLowerCase()
              .contains(searchText.toLowerCase());
      return matchesTab && matchesSearch;
    }).toList();
  }

  void _navigateToSkillDetail(String skillId) {
    switch (skillId) {
      case 'skill1':
        Navigator.pushNamed(context, '/skill1');
        break;
      case 'skill2':
        Navigator.pushNamed(context, '/skill2');
        break;
      case 'skill3':
        Navigator.pushNamed(context, '/skill3');
        break;
      default:
        _showSkillDetails(skillId);
    }
  }

  void _showSkillDetails(String skillId) {
    final skill = allSkills.firstWhere((s) => s['id'] == skillId);
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
                    // Skill Image
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          skill['img'],
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Skill Title
                    Text(
                      skill['title'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: deepPurple,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    
                    // Rating and Students
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          '${skill['rating']}',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.people, color: Colors.grey[600], size: 20),
                        const SizedBox(width: 4),
                        Text(
                          '${skill['students']} students',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Description
                    Text(
                      skill['desc'],
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Course Details
                    _buildDetailRow('Duration', skill['duration']),
                    _buildDetailRow('Mode', skill['mode']),
                    _buildDetailRow('Level', skill['level']),
                    _buildDetailRow('Instructor', skill['instructor']),
                    _buildDetailRow('Price', skill['price']),
                    _buildDetailRow('Certificate', skill['certificate'] ? 'Yes' : 'No'),
                    
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
                              'Learn More',
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
                              _enrollInSkill(skill);
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
                              'Enroll Now',
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(
            '$label:',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _enrollInSkill(Map<String, dynamic> skill) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Enrolling in ${skill['title']}...',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: deepPurple,
        action: SnackBarAction(
          label: 'View Progress',
          textColor: Colors.white,
          onPressed: () => Navigator.pushNamed(context, '/skill-progress'),
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
              'assets/pages_assets/Skills.png',
              width: 24,
              height: 24,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              'Skills & Courses',
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
                  'Enhance Your Career',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Discover skills that will boost your professional growth',
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
                      hintText: 'Search skills and courses...',
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
          
          // Tabs
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(tabs.length, (i) {
                  final isSelected = selectedTab == i;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: FilterChip(
                      label: Text(
                        tabs[i],
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
                      onSelected: (_) => setState(() => selectedTab = i),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          
          // Skills List
          Expanded(
            child: filteredSkills.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/pages_assets/Skills.png',
                          width: 120,
                          height: 120,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No skills found',
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
                    itemCount: filteredSkills.length,
                    itemBuilder: (context, index) {
                      final skill = filteredSkills[index];
                      return _buildSkillCard(skill);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillCard(Map<String, dynamic> skill) {
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
        onTap: () => _navigateToSkillDetail(skill['id']),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Skill Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  skill['img'],
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              
              // Skill Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      skill['title'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: deepPurple,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      skill['desc'],
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey[600],
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    
                    // Course Info
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          skill['duration'],
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.computer, size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          skill['mode'],
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Rating and Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.star, size: 16, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              '${skill['rating']}',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          skill['price'],
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: deepPurple,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Arrow Icon
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class MastersUpdateScreen extends StatefulWidget {
  const MastersUpdateScreen({super.key});

  @override
  State<MastersUpdateScreen> createState() => _MastersUpdateScreenState();
}

class _MastersUpdateScreenState extends State<MastersUpdateScreen> {
  final Color deepPurple = const Color(0xFF6C2786);

  final List<Map<String, dynamic>> nigerianUniversities = [
    {
      'name': 'University of Lagos (UNILAG)',
      'location': 'Lagos, Nigeria',
      'logo': 'assets/pages_items/fmn_logo.png',
      'programs': [
        'MSc Computer Science',
        'MSc Business Administration',
        'MSc Economics',
        'MSc Engineering',
        'MSc Public Health',
      ],
      'tuition': '₦500,000 - ₦800,000',
      'duration': '12-18 months',
      'website': 'https://unilag.edu.ng',
      'admission': 'September/January',
      'requirements': ['Bachelor\'s degree', 'CGPA 3.0+', 'English proficiency'],
    },
    {
      'name': 'University of Ibadan (UI)',
      'location': 'Ibadan, Nigeria',
      'logo': 'assets/pages_items/fmn_logo.png',
      'programs': [
        'MSc Information Science',
        'MSc Agricultural Economics',
        'MSc Biochemistry',
        'MSc Statistics',
        'MSc Public Administration',
      ],
      'tuition': '₦400,000 - ₦700,000',
      'duration': '12-18 months',
      'website': 'https://ui.edu.ng',
      'admission': 'September/January',
      'requirements': ['Bachelor\'s degree', 'CGPA 3.0+', 'English proficiency'],
    },
    {
      'name': 'Obafemi Awolowo University (OAU)',
      'location': 'Ile-Ife, Nigeria',
      'logo': 'assets/pages_items/fmn_logo.png',
      'programs': [
        'MSc Technology Management',
        'MSc Food Science',
        'MSc Architecture',
        'MSc Urban Planning',
        'MSc Environmental Management',
      ],
      'tuition': '₦350,000 - ₦600,000',
      'duration': '12-18 months',
      'website': 'https://oauife.edu.ng',
      'admission': 'September/January',
      'requirements': ['Bachelor\'s degree', 'CGPA 3.0+', 'English proficiency'],
    },
    {
      'name': 'Ahmadu Bello University (ABU)',
      'location': 'Zaria, Nigeria',
      'logo': 'assets/pages_items/fmn_logo.png',
      'programs': [
        'MSc Agricultural Engineering',
        'MSc Chemical Engineering',
        'MSc Civil Engineering',
        'MSc Electrical Engineering',
        'MSc Mechanical Engineering',
      ],
      'tuition': '₦300,000 - ₦550,000',
      'duration': '12-18 months',
      'website': 'https://abu.edu.ng',
      'admission': 'September/January',
      'requirements': ['Bachelor\'s degree', 'CGPA 3.0+', 'English proficiency'],
    },
    {
      'name': 'University of Nigeria (UNN)',
      'location': 'Nsukka, Nigeria',
      'logo': 'assets/pages_items/fmn_logo.png',
      'programs': [
        'MSc Mass Communication',
        'MSc Library Science',
        'MSc Political Science',
        'MSc Sociology',
        'MSc Psychology',
      ],
      'tuition': '₦400,000 - ₦650,000',
      'duration': '12-18 months',
      'website': 'https://unn.edu.ng',
      'admission': 'September/January',
      'requirements': ['Bachelor\'s degree', 'CGPA 3.0+', 'English proficiency'],
    },
    {
      'name': 'Covenant University',
      'location': 'Ota, Nigeria',
      'logo': 'assets/pages_items/fmn_logo.png',
      'programs': [
        'MSc Information Technology',
        'MSc Business Administration',
        'MSc Architecture',
        'MSc Civil Engineering',
        'MSc Electrical Engineering',
      ],
      'tuition': '₦800,000 - ₦1,200,000',
      'duration': '12-18 months',
      'website': 'https://covenantuniversity.edu.ng',
      'admission': 'September/January',
      'requirements': ['Bachelor\'s degree', 'CGPA 3.5+', 'English proficiency'],
    },
    {
      'name': 'Babcock University',
      'location': 'Ilishan-Remo, Nigeria',
      'logo': 'assets/pages_items/fmn_logo.png',
      'programs': [
        'MSc Computer Science',
        'MSc Business Administration',
        'MSc Public Health',
        'MSc Information Technology',
        'MSc Accounting',
      ],
      'tuition': '₦700,000 - ₦1,000,000',
      'duration': '12-18 months',
      'website': 'https://babcock.edu.ng',
      'admission': 'September/January',
      'requirements': ['Bachelor\'s degree', 'CGPA 3.0+', 'English proficiency'],
    },
    {
      'name': 'Pan-Atlantic University',
      'location': 'Lagos, Nigeria',
      'logo': 'assets/pages_items/fmn_logo.png',
      'programs': [
        'MSc Media and Communication',
        'MSc Business Administration',
        'MSc Information Technology',
        'MSc Entrepreneurship',
        'MSc Marketing',
      ],
      'tuition': '₦1,000,000 - ₦1,500,000',
      'duration': '12-18 months',
      'website': 'https://pau.edu.ng',
      'admission': 'September/January',
      'requirements': ['Bachelor\'s degree', 'CGPA 3.0+', 'English proficiency'],
    },
  ];

  void _showApplicationGuide() {
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
                    Text(
                      'Postgraduate Application Guide',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: deepPurple,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Application Steps
                    Text(
                      'Application Steps',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: deepPurple,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    _buildStepItem('1', 'Research Programs', 'Identify universities and programs that match your career goals'),
                    _buildStepItem('2', 'Check Requirements', 'Review admission requirements and deadlines'),
                    _buildStepItem('3', 'Prepare Documents', 'Gather all required documents and transcripts'),
                    _buildStepItem('4', 'Take Entrance Exams', 'Complete required entrance examinations if applicable'),
                    _buildStepItem('5', 'Submit Application', 'Complete online application and pay fees'),
                    _buildStepItem('6', 'Interview', 'Attend interview if required by the program'),
                    _buildStepItem('7', 'Acceptance', 'Receive admission letter and confirm enrollment'),
                    
                    const SizedBox(height: 24),
                    
                    // Required Documents
                    Text(
                      'Required Documents',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: deepPurple,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    _buildDocumentItem('Academic Transcripts', 'Official transcripts from all institutions attended'),
                    _buildDocumentItem('Degree Certificate', 'Copy of your bachelor\'s degree certificate'),
                    _buildDocumentItem('CV/Resume', 'Updated curriculum vitae highlighting relevant experience'),
                    _buildDocumentItem('Statement of Purpose', 'Personal statement explaining your goals and motivation'),
                    _buildDocumentItem('Letters of Recommendation', '2-3 academic or professional references'),
                    _buildDocumentItem('English Proficiency', 'TOEFL or IELTS scores (if required)'),
                    _buildDocumentItem('Application Fee', 'Payment receipt for application processing'),
                    
                    const SizedBox(height: 24),
                    
                    // Tips
                    Text(
                      'Application Tips',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: deepPurple,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    _buildTipItem('Start Early', 'Begin your application process at least 6 months before deadline'),
                    _buildTipItem('Research Thoroughly', 'Visit university websites and contact departments directly'),
                    _buildTipItem('Prepare Strong SOP', 'Write a compelling statement of purpose'),
                    _buildTipItem('Get Good References', 'Choose recommenders who know you well academically/professionally'),
                    _buildTipItem('Follow Instructions', 'Carefully follow all application instructions and deadlines'),
                    _buildTipItem('Proofread Everything', 'Ensure all documents are error-free and professional'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepItem(String number, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: deepPurple,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                number,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: deepPurple,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: deepPurple, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: deepPurple,
                  ),
                ),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb, color: Colors.amber[700], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.amber[700],
                  ),
                ),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: color,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickLinkCard(String title, String description, IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: deepPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: deepPurple, size: 24),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: deepPurple,
          ),
        ),
        subtitle: Text(
          description,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
        onTap: onTap,
      ),
    );
  }

  Widget _buildUniversityCard(Map<String, dynamic> university) {
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
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: deepPurple.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    university['logo'],
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
                        university['name'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: deepPurple,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            university['location'],
                            style: GoogleFonts.poppins(
                              fontSize: 13,
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
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Programs
                Text(
                  'Available Programs',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: deepPurple,
                  ),
                ),
                const SizedBox(height: 8),
                ...university['programs'].map<Widget>((program) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Icon(Icons.school, size: 12, color: Colors.grey[500]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          program,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                )).toList(),
                
                const SizedBox(height: 16),
                
                // Details
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailItem('Tuition', university['tuition'], Icons.attach_money),
                    ),
                    Expanded(
                      child: _buildDetailItem('Duration', university['duration'], Icons.access_time),
                    ),
                    Expanded(
                      child: _buildDetailItem('Admission', university['admission'], Icons.calendar_today),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _openExternal(university['website']),
                        icon: Icon(Icons.language, size: 16),
                        label: Text('Website', style: GoogleFonts.poppins(fontSize: 12)),
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
                        onPressed: () => _showUniversityDetails(university),
                        icon: Icon(Icons.info, size: 16),
                        label: Text('Details', style: GoogleFonts.poppins(fontSize: 12)),
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

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: deepPurple,
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
    );
  }

  void _showUniversityDetails(Map<String, dynamic> university) {
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
                    Text(
                      university['name'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: deepPurple,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      university['location'],
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    Text(
                      'Admission Requirements',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: deepPurple,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...university['requirements'].map<Widget>((req) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
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
                    
                    const SizedBox(height: 20),
                    
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _openExternal(university['website']),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: deepPurple,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Visit Website',
                              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
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

  void _openExternal(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open $url'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
              'assets/pages_items/masters.png',
              width: 24,
              height: 24,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              'Masters Update',
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
      body: SingleChildScrollView(
        child: Column(
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
                    'Postgraduate Programs',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Discover top Nigerian universities for your master\'s degree',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            // Quick Stats
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Universities',
                      '${nigerianUniversities.length}',
                      Icons.school,
                      deepPurple,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Programs',
                      '40+',
                      Icons.book,
                      Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Duration',
                      '12-18m',
                      Icons.access_time,
                      Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
            
            // Quick Links
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Links',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: deepPurple,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  _buildQuickLinkCard(
                    'Application Guide',
                    'Step-by-step application process',
                    Icons.assignment,
                    _showApplicationGuide,
                  ),
                  _buildQuickLinkCard(
                    'Scholarships',
                    'Available funding opportunities',
                    Icons.monetization_on,
                    () => _openExternal('https://scholarships.gov.ng'),
                  ),
                  _buildQuickLinkCard(
                    'JAMB Portal',
                    'Official postgraduate portal',
                    Icons.link,
                    () => _openExternal('https://jamb.gov.ng'),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Featured Universities
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Featured Universities',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: deepPurple,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  ...nigerianUniversities.map((university) => _buildUniversityCard(university)),
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
import 'package:flutter/material.dart';

class SkillsScreen extends StatelessWidget {
  const SkillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skills Development'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildSkillsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Develop Your Skills',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose from a variety of skills to enhance your career prospects.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsList() {
    final skills = [
      {'name': 'Digital Marketing', 'icon': Icons.trending_up, 'color': Colors.blue},
      {'name': 'Web Development', 'icon': Icons.code, 'color': Colors.green},
      {'name': 'Data Analysis', 'icon': Icons.analytics, 'color': Colors.orange},
      {'name': 'Project Management', 'icon': Icons.assignment, 'color': Colors.purple},
      {'name': 'Graphic Design', 'icon': Icons.design_services, 'color': Colors.red},
      {'name': 'Content Writing', 'icon': Icons.edit, 'color': Colors.teal},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: skills.length,
      itemBuilder: (context, index) {
        final skill = skills[index];
        return _buildSkillCard(skill);
      },
    );
  }

  Widget _buildSkillCard(Map<String, dynamic> skill) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          // Navigate to skill details
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                skill['icon'],
                size: 48,
                color: skill['color'],
              ),
              const SizedBox(height: 12),
              Text(
                skill['name'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  // Enroll in skill
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: skill['color'],
                  foregroundColor: Colors.white,
                ),
                child: const Text('Enroll'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
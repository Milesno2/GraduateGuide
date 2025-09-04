import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newly_graduate_hub/services/supabase_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final Color deepPurple = const Color(0xFF6C2786);
  final SupabaseService _supabaseService = SupabaseService();
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
    });

    // Mock notifications - in real app, these would come from backend
    await Future.delayed(const Duration(milliseconds: 500));
    
    setState(() {
      _notifications = [
        {
          'id': '1',
          'title': 'Welcome to Graduate Guide!',
          'message': 'Your account was created successfully. Start exploring our features to build your career.',
          'type': 'welcome',
          'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
          'isRead': false,
          'icon': Icons.celebration,
          'color': Colors.green,
        },
        {
          'id': '2',
          'title': 'Campus News Update',
          'message': 'Lautech Student Emerge as the best in the FMN Competition. Read more about this achievement.',
          'type': 'news',
          'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
          'isRead': false,
          'icon': Icons.newspaper,
          'color': Colors.blue,
        },
        {
          'id': '3',
          'title': 'Skill Progress',
          'message': 'You have completed 2 new skills this week. Keep up the great work!',
          'type': 'progress',
          'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
          'isRead': true,
          'icon': Icons.trending_up,
          'color': Colors.orange,
        },
        {
          'id': '4',
          'title': 'NYSC Registration Reminder',
          'message': 'Don\'t forget to complete your NYSC registration. Deadline is approaching.',
          'type': 'reminder',
          'timestamp': DateTime.now().subtract(const Duration(days: 1)),
          'isRead': true,
          'icon': Icons.schedule,
          'color': Colors.red,
        },
        {
          'id': '5',
          'title': 'New Job Opportunities',
          'message': '5 new job opportunities match your profile. Check them out now!',
          'type': 'jobs',
          'timestamp': DateTime.now().subtract(const Duration(hours: 3)),
          'isRead': false,
          'icon': Icons.work,
          'color': Colors.purple,
        },
        {
          'id': '6',
          'title': 'Resume Builder Tip',
          'message': 'Your resume has been viewed 12 times this week. Consider updating it.',
          'type': 'tip',
          'timestamp': DateTime.now().subtract(const Duration(hours: 4)),
          'isRead': true,
          'icon': Icons.lightbulb,
          'color': Colors.amber,
        },
      ];
      _isLoading = false;
    });
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  void _markAsRead(String notificationId) {
    setState(() {
      final notification = _notifications.firstWhere((n) => n['id'] == notificationId);
      notification['isRead'] = true;
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification['isRead'] = true;
      }
    });
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
              'assets/pages_items/Bell.png',
              width: 24,
              height: 24,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text('Notifications',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                )),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (_notifications.any((n) => !n['isRead']))
            TextButton(
              onPressed: _markAllAsRead,
              child: Text(
                'Mark all read',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _notifications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_none,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No notifications yet',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'We\'ll notify you when there\'s something new',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadNotifications,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
                      final notification = _notifications[index];
                      final isRead = notification['isRead'] as bool;
                      
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
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
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: notification['color'].withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              notification['icon'],
                              color: notification['color'],
                              size: 24,
                            ),
                          ),
                          title: Text(
                            notification['title'],
                            style: GoogleFonts.poppins(
                              fontWeight: isRead ? FontWeight.w500 : FontWeight.w600,
                              fontSize: 16,
                              color: isRead ? Colors.grey[700] : Colors.black,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                notification['message'],
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _getTimeAgo(notification['timestamp']),
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                          trailing: !isRead
                              ? Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: deepPurple,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                )
                              : null,
                          onTap: () {
                            if (!isRead) {
                              _markAsRead(notification['id']);
                            }
                            // Handle notification tap based on type
                            _handleNotificationTap(notification);
                          },
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  void _handleNotificationTap(Map<String, dynamic> notification) {
    final type = notification['type'];
    
    switch (type) {
      case 'welcome':
        // Navigate to onboarding or welcome screen
        break;
      case 'news':
        // Navigate to news/updates screen
        Navigator.pushNamed(context, '/updates');
        break;
      case 'progress':
        // Navigate to skills progress screen
        Navigator.pushNamed(context, '/skill-progress');
        break;
      case 'reminder':
        // Navigate to NYSC guidelines
        Navigator.pushNamed(context, '/nysc-guidelines');
        break;
      case 'jobs':
        // Navigate to jobs screen
        Navigator.pushNamed(context, '/jobs');
        break;
      case 'tip':
        // Navigate to resume builder
        Navigator.pushNamed(context, '/resume-builder');
        break;
      default:
        break;
    }
  }
}

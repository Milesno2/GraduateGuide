import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';

class SupabaseService {
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? 'https://zqcykjxwsnlxmtzcmiga.supabase.co';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpxY3lranh3c25seG10emNtaWdhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY4NDI4MDgsImV4cCI6MjA3MjQxODgwOH0.dkH258TCMv4q7XXLknfnLNCJu1LVqEGdzabsh-0Oj7s';

  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  late final SupabaseClient _supabase;
  RealtimeChannel? _messagesChannel;
  RealtimeChannel? _notificationsChannel;

  Future<void> initialize() async {
    try {
      // Load environment variables
      await dotenv.load(fileName: ".env");
      
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
      );
      _supabase = Supabase.instance.client;
    } catch (e) {
      print('Supabase initialization error: $e');
      // Continue with fallback values
    }
  }

  SupabaseClient get client => _supabase;

  User? getCurrentUser() {
    try {
      return _supabase.auth.currentUser;
    } catch (e) {
      print('Get current user error: $e');
      return null;
    }
  }

  // ==================== AUTHENTICATION ====================

  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String gender,
    required String university,
    required String graduationYear,
    required String course,
  }) async {
    try {
      final AuthResponse response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': name,
          'phone': phone,
          'gender': gender,
          'university': university,
          'graduation_year': graduationYear,
          'course': course,
        },
      );

      if (response.user != null) {
        await _createUserProfile(response.user!);
        return true;
      }
      return false;
    } catch (e) {
      print('Sign up error: $e');
      return false;
    }
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        await _updateLastLogin(response.user!.id);
        return true;
      }
      return false;
    } catch (e) {
      print('Sign in error: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      _disconnectRealtimeChannels();
      await _supabase.auth.signOut();
    } catch (e) {
      print('Sign out error: $e');
    }
  }

  // ==================== USER PROFILE ====================

  Future<void> _createUserProfile(User user) async {
    try {
      await _supabase.from('users').insert({
        'id': user.id,
        'email': user.email,
        'first_name': user.userMetadata?['name']?.toString().split(' ').first ?? '',
        'last_name': user.userMetadata?['name']?.toString().split(' ').last ?? '',
        'profession': user.userMetadata?['course'] ?? '',
        'graduation_year': user.userMetadata?['graduation_year'] ?? '',
        'school': user.userMetadata?['university'] ?? '',
      });
    } catch (e) {
      print('Create user profile error: $e');
    }
  }

  Future<void> _updateLastLogin(String userId) async {
    try {
      await _supabase.from('users').update({
        'last_login': DateTime.now().toIso8601String(),
      }).eq('id', userId);
    } catch (e) {
      print('Update last login error: $e');
    }
  }

  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final response = await _supabase
          .from('users')
          .select()
          .eq('id', userId)
          .single();
      return response;
    } catch (e) {
      print('Get user profile error: $e');
      return null;
    }
  }

  Future<bool> updateUserProfile(String userId, Map<String, dynamic> updates) async {
    try {
      await _supabase.from('users').update(updates).eq('id', userId);
      return true;
    } catch (e) {
      print('Update user profile error: $e');
      return false;
    }
  }

  // ==================== FILE UPLOAD ====================

  Future<String?> uploadFile(String bucket, String path, File file) async {
    try {
      final response = await _supabase.storage.from(bucket).upload(path, file);
      return _supabase.storage.from(bucket).getPublicUrl(response);
    } catch (e) {
      print('Upload file error: $e');
      return null;
    }
  }

  Future<String?> uploadProfileImage(String userId, File imageFile) async {
    try {
      final fileName = 'profile_$userId.jpg';
      final response = await _supabase.storage
          .from('profile-images')
          .upload(fileName, imageFile);
      
      final publicUrl = _supabase.storage
          .from('profile-images')
          .getPublicUrl(response);
      
      await updateUserProfile(userId, {'profile_image': publicUrl});
      return publicUrl;
    } catch (e) {
      print('Upload profile image error: $e');
      return null;
    }
  }

  Future<String?> uploadVoiceMessage(String conversationId, File audioFile) async {
    // Skip voice upload on web for now
    if (kIsWeb) {
      print('Voice upload not supported on web yet');
      return null;
    }
    
    try {
      final fileName = 'voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
      final path = '$conversationId/$fileName';
      
      final response = await _supabase.storage
          .from('voice-messages')
          .upload(path, audioFile);
      
      return _supabase.storage
          .from('voice-messages')
          .getPublicUrl(response);
    } catch (e) {
      print('Upload voice message error: $e');
      return null;
    }
  }

  // ==================== REAL-TIME MESSAGING ====================

  void initializeMessaging() {
    try {
      // Simplified realtime for web compatibility
      print('Messaging initialized');
    } catch (e) {
      print('Initialize messaging error: $e');
    }
  }

  void _handleNewMessage(Map<String, dynamic> payload) {
    // Handle new message notification
    print('New message received: ${payload['new']}');
  }

  void _handleMessageUpdate(Map<String, dynamic> payload) {
    // Handle message update (e.g., read status)
    print('Message updated: ${payload['new']}');
  }

  Future<List<Map<String, dynamic>>> getConversations(String userId) async {
    try {
      final response = await _supabase
          .from('conversations')
          .select('''
            *,
            participant1:users!conversations_participant1_id_fkey(id, first_name, last_name, profile_image),
            participant2:users!conversations_participant2_id_fkey(id, first_name, last_name, profile_image),
            last_message:messages!conversations_last_message_id_fkey(content, created_at)
          ''')
          .or('participant1_id.eq.$userId,participant2_id.eq.$userId')
          .order('last_message_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Get conversations error: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getMessages(String conversationId) async {
    try {
      final response = await _supabase
          .from('messages')
          .select('*, sender:users!messages_sender_id_fkey(first_name, last_name, profile_image)')
          .eq('conversation_id', conversationId)
          .order('created_at', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Get messages error: $e');
      return [];
    }
  }

  Future<bool> sendMessage({
    required String conversationId,
    required String senderId,
    required String receiverId,
    required String content,
    String? voiceUrl,
    String messageType = 'text',
  }) async {
    try {
      await _supabase.from('messages').insert({
        'conversation_id': conversationId,
        'sender_id': senderId,
        'receiver_id': receiverId,
        'content': content,
        'voice_url': voiceUrl,
        'message_type': messageType,
      });
      return true;
    } catch (e) {
      print('Send message error: $e');
      return false;
    }
  }

  Future<bool> markMessageAsRead(String messageId) async {
    try {
      await _supabase.from('messages').update({
        'is_read': true,
        'read_at': DateTime.now().toIso8601String(),
      }).eq('id', messageId);
      return true;
    } catch (e) {
      print('Mark message as read error: $e');
      return false;
    }
  }

  // ==================== VOICE CALLS ====================

  Future<bool> initiateVoiceCall({
    required String callerId,
    required String receiverId,
  }) async {
    try {
      await _supabase.from('voice_calls').insert({
        'caller_id': callerId,
        'receiver_id': receiverId,
        'status': 'initiated',
      });
      return true;
    } catch (e) {
      print('Initiate voice call error: $e');
      return false;
    }
  }

  Future<bool> updateCallStatus(String callId, String status) async {
    try {
      final updates = {'status': status};
      if (status == 'answered') {
        updates['started_at'] = DateTime.now().toIso8601String();
      } else if (status == 'ended') {
        updates['ended_at'] = DateTime.now().toIso8601String();
      }

      await _supabase.from('voice_calls').update(updates).eq('id', callId);
      return true;
    } catch (e) {
      print('Update call status error: $e');
      return false;
    }
  }

  // ==================== NOTIFICATIONS ====================

  void initializeNotifications() {
    try {
      // Simplified notifications for web compatibility
      print('Notifications initialized');
    } catch (e) {
      print('Initialize notifications error: $e');
    }
  }

  void _handleNewNotification(Map<String, dynamic> payload) {
    // Handle new notification
    print('New notification received: ${payload['new']}');
  }

  Future<bool> createNotification({
    required String userId,
    required String title,
    required String message,
    String type = 'general',
    String priority = 'normal',
    String? actionUrl,
  }) async {
    try {
      await _supabase.from('notifications').insert({
        'user_id': userId,
        'title': title,
        'message': message,
        'type': type,
        'priority': priority,
        'action_url': actionUrl,
      });
      return true;
    } catch (e) {
      print('Create notification error: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getUserNotifications(String userId) async {
    try {
      final response = await _supabase
          .from('notifications')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(50);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Get user notifications error: $e');
      return [];
    }
  }

  Future<bool> markNotificationAsRead(String notificationId) async {
    try {
      await _supabase.from('notifications').update({
        'is_read': true,
        'read_at': DateTime.now().toIso8601String(),
      }).eq('id', notificationId);
      return true;
    } catch (e) {
      print('Mark notification as read error: $e');
      return false;
    }
  }

  Future<int> getUnreadNotificationCount(String userId) async {
    try {
      final response = await _supabase
          .from('notifications')
          .select('id')
          .eq('user_id', userId)
          .eq('is_read', false);

      return response.length;
    } catch (e) {
      print('Get unread notification count error: $e');
      return 0;
    }
  }

  // ==================== SKILLS MANAGEMENT ====================

  Future<List<Map<String, dynamic>>> getAvailableSkills() async {
    try {
      final response = await _supabase
          .from('skills')
          .select()
          .eq('is_active', true)
          .order('name');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Get available skills error: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getUserSkills(String userId) async {
    try {
      final response = await _supabase
          .from('user_skills')
          .select('''
            *,
            skill:skills(*)
          ''')
          .eq('user_id', userId)
          .order('enrolled_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Get user skills error: $e');
      return [];
    }
  }

  Future<bool> addUserSkill({
    required String userId,
    required String skillId,
  }) async {
    try {
      await _supabase.from('user_skills').insert({
        'user_id': userId,
        'skill_id': skillId,
        'progress': 0.0,
      });
      return true;
    } catch (e) {
      print('Add user skill error: $e');
      return false;
    }
  }

  Future<bool> updateSkillProgress({
    required String userSkillId,
    required double progress,
    String? nextMilestone,
  }) async {
    try {
      final updates = {
        'progress': progress,
        'last_activity': DateTime.now().toIso8601String(),
      };
      
      if (nextMilestone != null) {
        updates['next_milestone'] = nextMilestone;
      }

      await _supabase.from('user_skills').update(updates).eq('id', userSkillId);
      return true;
    } catch (e) {
      print('Update skill progress error: $e');
      return false;
    }
  }

  // ==================== JOBS MANAGEMENT ====================

  Future<List<Map<String, dynamic>>> getJobRecommendations(String userId) async {
    try {
      final response = await _supabase
          .from('jobs')
          .select()
          .eq('is_active', true)
          .order('created_at', ascending: false)
          .limit(20);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Get job recommendations error: $e');
      return [];
    }
  }

  Future<bool> applyForJob({
    required String jobId,
    required String userId,
    String? coverLetter,
    String? resumeUrl,
  }) async {
    try {
      await _supabase.from('job_applications').insert({
        'job_id': jobId,
        'user_id': userId,
        'cover_letter': coverLetter,
        'resume_url': resumeUrl,
      });
      return true;
    } catch (e) {
      print('Apply for job error: $e');
      return false;
    }
  }

  // ==================== CAREER AI ====================

  Future<Map<String, dynamic>> getCareerAdvice({
    required String userId,
    required String query,
    String sessionType = 'career_guidance',
  }) async {
    try {
      // Save the user query
      await _supabase.from('career_sessions').insert({
        'user_id': userId,
        'session_type': sessionType,
        'title': 'Career Advice Session',
        'content': query,
      });

      // Generate AI response (mock for now)
      final response = await _generateCareerAdvice(query);
      return response;
    } catch (e) {
      print('Get career advice error: $e');
      return {
        'advice': 'I apologize, but I\'m having trouble processing your request right now. Please try again later.',
        'type': 'error',
        'suggestions': ['Try rephrasing your question', 'Check your internet connection'],
      };
    }
  }

  Future<Map<String, dynamic>> _generateCareerAdvice(String query) async {
    // Mock AI response - in production, this would call an actual AI service
    final queryLower = query.toLowerCase();
    
    if (queryLower.contains('resume') || queryLower.contains('cv')) {
      return {
        'advice': 'Resume Writing Tips:\n\n1. Use clear, concise language\n2. Highlight relevant achievements\n3. Include specific metrics and results\n4. Tailor to job description\n5. Use professional formatting\n6. Proofread thoroughly',
        'type': 'resume_tips',
        'suggestions': ['Use action verbs', 'Include quantifiable results', 'Keep it to 1-2 pages'],
      };
    } else if (queryLower.contains('interview')) {
      return {
        'advice': 'Interview Preparation:\n\n1. Research the company thoroughly\n2. Practice common questions\n3. Prepare your "tell me about yourself" story\n4. Dress professionally\n5. Bring extra copies of your resume\n6. Follow up with a thank you email',
        'type': 'interview_prep',
        'suggestions': ['Practice with a friend', 'Research company culture', 'Prepare questions to ask'],
      };
    } else if (queryLower.contains('salary') || queryLower.contains('pay')) {
      return {
        'advice': 'Salary Negotiation Tips:\n\n1. Research market rates for your position\n2. Know your worth and minimum acceptable salary\n3. Practice your negotiation pitch\n4. Consider total compensation package\n5. Be confident but professional\n6. Have a backup plan',
        'type': 'salary_negotiation',
        'suggestions': ['Research industry standards', 'Practice your pitch', 'Consider benefits package'],
      };
    } else if (queryLower.contains('career') && queryLower.contains('change')) {
      return {
        'advice': 'Career Change Strategies:\n\n1. Assess your transferable skills\n2. Research your target industry\n3. Network with professionals in the field\n4. Consider additional education or certifications\n5. Start with side projects or volunteering\n6. Be patient with the transition process',
        'type': 'career_change',
        'suggestions': ['Identify transferable skills', 'Network in new field', 'Consider certifications'],
      };
    } else {
      return {
        'advice': 'Career Development Strategies:\n\n1. Network actively in your field\n2. Continuously upgrade your skills\n3. Build a strong online presence\n4. Consider certifications\n5. Stay updated with industry trends\n6. Seek mentorship opportunities',
        'type': 'general_advice',
        'suggestions': ['Explore skills section', 'Check job opportunities', 'Update your profile'],
      };
    }
  }

  // ==================== UTILITY METHODS ====================

  void _disconnectRealtimeChannels() {
    try {
      _messagesChannel?.unsubscribe();
      _notificationsChannel?.unsubscribe();
    } catch (e) {
      print('Disconnect realtime channels error: $e');
    }
  }

  Future<void> _initializeUserData(String userId) async {
    // Initialize any user-specific data
    await createNotification(
      userId: userId,
      title: 'Welcome to Graduate Assistant Hub!',
      message: 'Start exploring skills, jobs, and career opportunities tailored for you.',
      type: 'system',
    );
  }
} 
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

class SupabaseService {
  static const String _supabaseUrl = 'https://dvscnclorvsrhkiurlpt.supabase.co';
  static const String _supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR2c2NuY2xvcnZzcmhraXVybHB0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTUxNTk0NDYsImV4cCI6MjA3MDczNTQ0Nn0.LfMdRX-QSeDmeEEyCcb5lI7juh_ylHCjQ3HCDXj1UOQ';
  
  late SupabaseClient _supabase;

  Future<void> initialize() async {
    await Supabase.initialize(
      url: _supabaseUrl,
      anonKey: _supabaseAnonKey,
    );
    _supabase = Supabase.instance.client;
  }

  // Authentication Methods
  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String gender,
    required String university,
    required String graduationYear,
    required String course,
    String? profileImage,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
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
        // Insert user profile data
        await _supabase.from('profiles').insert({
          'id': response.user!.id,
          'name': name,
          'phone': phone,
          'gender': gender,
          'university': university,
          'graduation_year': graduationYear,
          'course': course,
          'profile_image_url': profileImage,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });

        // Create welcome notification
        await createNotification(
          userId: response.user!.id,
          title: 'Welcome to Graduate Guide!',
          message: 'Your account was created successfully. Start exploring our features to build your career.',
          type: 'welcome',
        );

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
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response.user != null;
    } catch (e) {
      print('Sign in error: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }

  // Profile Management
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      return response;
    } catch (e) {
      print('Get user profile error: $e');
      return null;
    }
  }

  Future<bool> updateUserProfile(String userId, Map<String, dynamic> data) async {
    try {
      await _supabase
          .from('profiles')
          .update({
            ...data,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);
      return true;
    } catch (e) {
      print('Update user profile error: $e');
      return false;
    }
  }

  Future<String?> updateProfileImage(String userId, String imageUrl) async {
    try {
      await _supabase
          .from('profiles')
          .update({
            'profile_image_url': imageUrl,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);
      return imageUrl;
    } catch (e) {
      print('Update profile image error: $e');
      return null;
    }
  }

  Future<String?> uploadAvatarBytes(Uint8List data, String storagePath, {String contentType = 'image/png'}) async {
    try {
      final bucket = _supabase.storage.from('avatars');
      await bucket.uploadBinary(storagePath, data, fileOptions: FileOptions(upsert: true, contentType: contentType));
      final publicUrl = bucket.getPublicUrl(storagePath);
      return publicUrl;
    } catch (e) {
      print('Upload avatar error: $e');
      return null;
    }
  }

  // Notification Management
  Future<bool> createNotification({
    required String userId,
    required String title,
    required String message,
    required String type,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await _supabase.from('notifications').insert({
        'user_id': userId,
        'title': title,
        'message': message,
        'type': type,
        'metadata': metadata,
        'is_read': false,
        'created_at': DateTime.now().toIso8601String(),
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
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Get user notifications error: $e');
      return [];
    }
  }

  Future<bool> markNotificationAsRead(String notificationId) async {
    try {
      await _supabase
          .from('notifications')
          .update({'is_read': true})
          .eq('id', notificationId);
      return true;
    } catch (e) {
      print('Mark notification as read error: $e');
      return false;
    }
  }

  Future<bool> markAllNotificationsAsRead(String userId) async {
    try {
      await _supabase
          .from('notifications')
          .update({'is_read': true})
          .eq('user_id', userId)
          .eq('is_read', false);
      return true;
    } catch (e) {
      print('Mark all notifications as read error: $e');
      return false;
    }
  }

  Future<int> getUnreadNotificationCount(String userId) async {
    try {
      final response = await _supabase
          .from('notifications')
          .select('id', count: CountOption.exact)
          .eq('user_id', userId)
          .eq('is_read', false);
      return response.count ?? 0;
    } catch (e) {
      print('Get unread notification count error: $e');
      return 0;
    }
  }

  // Career AI Assistant
  Future<Map<String, dynamic>> getCareerAdvice({
    required String userId,
    required String query,
    Map<String, dynamic>? context,
  }) async {
    try {
      // Get user profile for context
      final profile = await getUserProfile(userId);
      
      // In a real implementation, this would call an AI service
      // For now, we'll return mock responses based on query type
      final response = await _supabase.functions.invoke(
        'career-ai-assistant',
        body: {
          'query': query,
          'user_profile': profile,
          'context': context,
        },
      );

      if (response.status == 200) {
        return response.data;
      } else {
        // Fallback to mock response
        return _getMockCareerAdvice(query, profile);
      }
    } catch (e) {
      print('Career AI error: $e');
      // Return mock response on error
      final profile = await getUserProfile(userId);
      return _getMockCareerAdvice(query, profile);
    }
  }

  Map<String, dynamic> _getMockCareerAdvice(String query, Map<String, dynamic>? profile) {
    final queryLower = query.toLowerCase();
    
    if (queryLower.contains('resume') || queryLower.contains('cv')) {
      return {
        'advice': 'Here are some tips for your resume:\n\n1. Keep it concise (1-2 pages)\n2. Use action verbs\n3. Quantify achievements\n4. Tailor to job description\n5. Include relevant skills',
        'type': 'resume_tips',
        'confidence': 0.95,
      };
    } else if (queryLower.contains('interview')) {
      return {
        'advice': 'Interview preparation tips:\n\n1. Research the company\n2. Practice common questions\n3. Prepare STAR method answers\n4. Dress professionally\n5. Follow up with thank you email',
        'type': 'interview_prep',
        'confidence': 0.92,
      };
    } else if (queryLower.contains('job') || queryLower.contains('career')) {
      return {
        'advice': 'Based on your profile, consider these career paths:\n\n1. Software Developer\n2. Data Analyst\n3. Product Manager\n4. UX Designer\n5. DevOps Engineer',
        'type': 'career_paths',
        'confidence': 0.88,
      };
    } else {
      return {
        'advice': 'I\'m here to help with your career development. You can ask me about:\n\n• Resume writing\n• Interview preparation\n• Job search strategies\n• Skill development\n• Career planning',
        'type': 'general',
        'confidence': 0.85,
      };
    }
  }

  // Skills Management
  Future<List<Map<String, dynamic>>> getUserSkills(String userId) async {
    try {
      final response = await _supabase
          .from('user_skills')
          .select('*, skills(*)')
          .eq('user_id', userId);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Get user skills error: $e');
      return [];
    }
  }

  Future<bool> addUserSkill(String userId, String skillId, int proficiencyLevel) async {
    try {
      await _supabase.from('user_skills').insert({
        'user_id': userId,
        'skill_id': skillId,
        'proficiency_level': proficiencyLevel,
        'created_at': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      print('Add user skill error: $e');
      return false;
    }
  }

  // Job Management
  Future<List<Map<String, dynamic>>> getJobRecommendations(String userId) async {
    try {
      final profile = await getUserProfile(userId);
      final userSkills = await getUserSkills(userId);
      
      // In a real implementation, this would use ML to match jobs
      final response = await _supabase
          .from('jobs')
          .select()
          .limit(10)
          .order('created_at', ascending: false);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Get job recommendations error: $e');
      return [];
    }
  }

  // Resume Management
  Future<Map<String, dynamic>?> getUserResume(String userId) async {
    try {
      final response = await _supabase
          .from('resumes')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(1)
          .single();
      return response;
    } catch (e) {
      print('Get user resume error: $e');
      return null;
    }
  }

  Future<bool> saveResume(String userId, Map<String, dynamic> resumeData) async {
    try {
      await _supabase.from('resumes').insert({
        'user_id': userId,
        'data': resumeData,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      print('Save resume error: $e');
      return false;
    }
  }

  // Auth State Changes
  Stream<AuthState> authStateChanges() {
    return _supabase.auth.onAuthStateChange;
  }

  // Real-time notifications
  Stream<List<Map<String, dynamic>>> getNotificationsStream(String userId) {
    return _supabase
        .from('notifications')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .map((event) => List<Map<String, dynamic>>.from(event));
  }
} 
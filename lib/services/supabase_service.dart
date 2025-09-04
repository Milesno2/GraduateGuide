import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';

class SupabaseService {
  // Production Supabase Configuration
  static const String _supabaseUrl = 'https://your-project.supabase.co';
  static const String _supabaseAnonKey = 'your-anon-key';
  
  late SupabaseClient _supabase;
  late RealtimeChannel _messagesChannel;
  late RealtimeChannel _notificationsChannel;

  // Singleton pattern
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  Future<void> initialize() async {
    await Supabase.initialize(
      url: _supabaseUrl,
      anonKey: _supabaseAnonKey,
      realtimeClientOptions: const RealtimeClientOptions(
        logLevel: RealtimeLogLevel.info,
      ),
    );
    _supabase = Supabase.instance.client;
    _initializeRealtimeChannels();
  }

  void _initializeRealtimeChannels() {
    _messagesChannel = _supabase.channel('messages');
    _notificationsChannel = _supabase.channel('notifications');
  }

  // ==================== AUTHENTICATION ====================
  
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required String gender,
    required String university,
    required String graduationYear,
    required String course,
    required String profession,
    String? profileImage,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'phone': phone,
          'gender': gender,
          'university': university,
          'graduation_year': graduationYear,
          'course': course,
          'profession': profession,
        },
      );

      if (response.user != null) {
        // Create user profile
        await _createUserProfile(response.user!, {
          'first_name': firstName,
          'last_name': lastName,
          'phone': phone,
          'gender': gender,
          'university': university,
          'graduation_year': graduationYear,
          'course': course,
          'profession': profession,
          'profile_image_url': profileImage,
        });

        // Create welcome notification
        await createNotification(
          userId: response.user!.id,
          title: 'Welcome to Graduate Guide! 🎉',
          message: 'Your account was created successfully. Start exploring our features to build your career.',
          type: 'welcome',
          priority: 'high',
        );

        // Initialize user data
        await _initializeUserData(response.user!.id);
      }

      return response;
    } catch (e) {
      print('Sign up error: $e');
      rethrow;
    }
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user != null) {
        // Update last login
        await _updateLastLogin(response.user!.id);
      }
      
      return response;
    } catch (e) {
      print('Sign in error: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      _disconnectRealtimeChannels();
    } catch (e) {
      print('Sign out error: $e');
      rethrow;
    }
  }

  User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }

  Stream<AuthState> authStateChanges() {
    return _supabase.auth.onAuthStateChange;
  }

  // ==================== USER PROFILE MANAGEMENT ====================

  Future<void> _createUserProfile(User user, Map<String, dynamic> profileData) async {
    try {
      await _supabase.from('user_profiles').insert({
        'id': user.id,
        'email': user.email,
        ...profileData,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
        'is_online': true,
        'last_seen': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Create user profile error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final response = await _supabase
          .from('user_profiles')
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
          .from('user_profiles')
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

  Future<void> _updateLastLogin(String userId) async {
    try {
      await _supabase
          .from('user_profiles')
          .update({
            'last_login': DateTime.now().toIso8601String(),
            'is_online': true,
          })
          .eq('id', userId);
    } catch (e) {
      print('Update last login error: $e');
    }
  }

  // ==================== REAL-TIME MESSAGING ====================

  Future<void> initializeMessaging() async {
    final user = getCurrentUser();
    if (user == null) return;

    try {
      // Subscribe to personal messages
      _messagesChannel
          .on(
            RealtimeListenTypes.postgresChanges,
            ChannelFilter(
              event: 'INSERT',
              schema: 'public',
              table: 'messages',
              filter: 'recipient_id=eq.${user.id}',
            ),
            (payload, [ref]) {
              _handleNewMessage(payload);
            },
          )
          .on(
            RealtimeListenTypes.postgresChanges,
            ChannelFilter(
              event: 'UPDATE',
              schema: 'public',
              table: 'messages',
              filter: 'recipient_id=eq.${user.id}',
            ),
            (payload, [ref]) {
              _handleMessageUpdate(payload);
            },
          )
          .subscribe();
    } catch (e) {
      print('Initialize messaging error: $e');
    }
  }

  void _handleNewMessage(Map<String, dynamic> payload) {
    // Handle new message notification
    print('New message received: $payload');
  }

  void _handleMessageUpdate(Map<String, dynamic> payload) {
    // Handle message updates (read status, etc.)
    print('Message updated: $payload');
  }

  Future<List<Map<String, dynamic>>> getConversations(String userId) async {
    try {
      final response = await _supabase
          .from('conversations')
          .select('''
            *,
            participants:conversation_participants(
              user_id,
              user_profiles(id, first_name, last_name, profile_image_url, university, is_online, last_seen)
            ),
            last_message:messages(
              id,
              content,
              message_type,
              created_at,
              sender_id
            )
          ''')
          .eq('participants.user_id', userId)
          .order('last_message.created_at', ascending: false);

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
          .select('''
            *,
            sender:user_profiles(id, first_name, last_name, profile_image_url)
          ''')
          .eq('conversation_id', conversationId)
          .order('created_at', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Get messages error: $e');
      return [];
    }
  }

  Future<String?> sendMessage({
    required String conversationId,
    required String senderId,
    required String content,
    required String messageType, // text, voice, image, file
    String? voiceUrl,
    String? fileUrl,
    int? voiceDuration,
  }) async {
    try {
      final response = await _supabase.from('messages').insert({
        'conversation_id': conversationId,
        'sender_id': senderId,
        'content': content,
        'message_type': messageType,
        'voice_url': voiceUrl,
        'file_url': fileUrl,
        'voice_duration': voiceDuration,
        'created_at': DateTime.now().toIso8601String(),
      }).select().single();

      // Update conversation last message
      await _supabase
          .from('conversations')
          .update({
            'last_message_id': response['id'],
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', conversationId);

      return response['id'];
    } catch (e) {
      print('Send message error: $e');
      return null;
    }
  }

  Future<bool> markMessageAsRead(String messageId, String userId) async {
    try {
      await _supabase
          .from('messages')
          .update({
            'read_at': DateTime.now().toIso8601String(),
            'read_by': userId,
          })
          .eq('id', messageId);
      return true;
    } catch (e) {
      print('Mark message as read error: $e');
      return false;
    }
  }

  // ==================== VOICE MESSAGING ====================

  Future<String?> uploadVoiceMessage(Uint8List audioData, String fileName) async {
    try {
      final bucket = _supabase.storage.from('voice-messages');
      final filePath = '${DateTime.now().millisecondsSinceEpoch}_$fileName';
      
      await bucket.uploadBinary(
        filePath,
        audioData,
        fileOptions: const FileOptions(
          contentType: 'audio/m4a',
          upsert: false,
        ),
      );

      return bucket.getPublicUrl(filePath);
    } catch (e) {
      print('Upload voice message error: $e');
      return null;
    }
  }

  // ==================== VOICE CALLS ====================

  Future<String?> initiateVoiceCall({
    required String callerId,
    required String receiverId,
    required String callType, // audio, video
  }) async {
    try {
      final response = await _supabase.from('voice_calls').insert({
        'caller_id': callerId,
        'receiver_id': receiverId,
        'call_type': callType,
        'status': 'initiating',
        'created_at': DateTime.now().toIso8601String(),
      }).select().single();

      return response['id'];
    } catch (e) {
      print('Initiate voice call error: $e');
      return null;
    }
  }

  Future<bool> updateCallStatus(String callId, String status) async {
    try {
      await _supabase
          .from('voice_calls')
          .update({
            'status': status,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', callId);
      return true;
    } catch (e) {
      print('Update call status error: $e');
      return false;
    }
  }

  // ==================== NOTIFICATIONS ====================

  Future<void> initializeNotifications() async {
    final user = getCurrentUser();
    if (user == null) return;

    try {
      _notificationsChannel
          .on(
            RealtimeListenTypes.postgresChanges,
            ChannelFilter(
              event: 'INSERT',
              schema: 'public',
              table: 'notifications',
              filter: 'user_id=eq.${user.id}',
            ),
            (payload, [ref]) {
              _handleNewNotification(payload);
            },
          )
          .subscribe();
    } catch (e) {
      print('Initialize notifications error: $e');
    }
  }

  void _handleNewNotification(Map<String, dynamic> payload) {
    // Handle new notification
    print('New notification: $payload');
  }

  Future<bool> createNotification({
    required String userId,
    required String title,
    required String message,
    required String type,
    String priority = 'normal',
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await _supabase.from('notifications').insert({
        'user_id': userId,
        'title': title,
        'message': message,
        'type': type,
        'priority': priority,
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
      await _supabase
          .from('notifications')
          .update({
            'is_read': true,
            'read_at': DateTime.now().toIso8601String(),
          })
          .eq('id', notificationId);
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
          .select('id', count: CountOption.exact)
          .eq('user_id', userId)
          .eq('is_read', false);
      return response.count ?? 0;
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
          .order('name', ascending: true);
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
          .order('created_at', ascending: false);
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
        'progress': 0,
        'created_at': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      print('Add user skill error: $e');
      return false;
    }
  }

  Future<bool> updateSkillProgress(String userSkillId, int progress) async {
    try {
      await _supabase
          .from('user_skills')
          .update({
            'progress': progress,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userSkillId);
      return true;
    } catch (e) {
      print('Update skill progress error: $e');
      return false;
    }
  }

  // ==================== JOBS MANAGEMENT ====================

  Future<List<Map<String, dynamic>>> getJobRecommendations(String userId) async {
    try {
      final userProfile = await getUserProfile(userId);
      if (userProfile == null) return [];

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

  Future<bool> applyForJob(String userId, String jobId, Map<String, dynamic> applicationData) async {
    try {
      await _supabase.from('job_applications').insert({
        'user_id': userId,
        'job_id': jobId,
        'status': 'pending',
        'application_data': applicationData,
        'created_at': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      print('Apply for job error: $e');
      return false;
    }
  }

  // ==================== CAREER AI ASSISTANT ====================

  Future<Map<String, dynamic>> getCareerAdvice({
    required String userId,
    required String query,
    Map<String, dynamic>? context,
  }) async {
    try {
      final userProfile = await getUserProfile(userId);
      
      // In production, this would call an AI service
      // For now, return intelligent responses based on query
      return _generateCareerAdvice(query, userProfile);
    } catch (e) {
      print('Career AI error: $e');
      return {
        'advice': 'I\'m sorry, I encountered an error. Please try again.',
        'type': 'error',
        'confidence': 0.0,
      };
    }
  }

  Map<String, dynamic> _generateCareerAdvice(String query, Map<String, dynamic>? profile) {
    final queryLower = query.toLowerCase();
    
    if (queryLower.contains('resume') || queryLower.contains('cv')) {
      return {
        'advice': 'Here are professional resume tips:\n\n1. Keep it concise (1-2 pages)\n2. Use action verbs and quantify achievements\n3. Tailor to job description\n4. Include relevant skills and certifications\n5. Proofread thoroughly\n6. Use professional formatting',
        'type': 'resume_tips',
        'confidence': 0.95,
        'suggestions': ['Update your resume', 'Get professional review', 'Practice interview questions'],
      };
    } else if (queryLower.contains('interview')) {
      return {
        'advice': 'Interview preparation guide:\n\n1. Research the company thoroughly\n2. Practice common questions using STAR method\n3. Prepare questions to ask\n4. Dress professionally\n5. Arrive early\n6. Follow up with thank you email',
        'type': 'interview_prep',
        'confidence': 0.92,
        'suggestions': ['Practice mock interviews', 'Research company culture', 'Prepare portfolio'],
      };
    } else if (queryLower.contains('job') || queryLower.contains('career')) {
      return {
        'advice': 'Career development strategies:\n\n1. Network actively in your field\n2. Continuously upgrade your skills\n3. Build a strong online presence\n4. Consider certifications\n5. Stay updated with industry trends\n6. Seek mentorship opportunities',
        'type': 'career_paths',
        'confidence': 0.88,
        'suggestions': ['Join professional groups', 'Attend industry events', 'Build portfolio'],
      };
    } else {
      return {
        'advice': 'I\'m here to help with your career development! You can ask me about:\n\n• Resume writing and optimization\n• Interview preparation strategies\n• Job search techniques\n• Skill development recommendations\n• Career planning and goal setting\n• Industry insights and trends',
        'type': 'general',
        'confidence': 0.85,
        'suggestions': ['Explore skills section', 'Check job opportunities', 'Update your profile'],
      };
    }
  }

  // ==================== UTILITY METHODS ====================

  Future<void> _initializeUserData(String userId) async {
    try {
      // Initialize user preferences
      await _supabase.from('user_preferences').insert({
        'user_id': userId,
        'notifications_enabled': true,
        'email_notifications': true,
        'push_notifications': true,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Initialize user data error: $e');
    }
  }

  void _disconnectRealtimeChannels() {
    try {
      _messagesChannel.unsubscribe();
      _notificationsChannel.unsubscribe();
    } catch (e) {
      print('Disconnect realtime channels error: $e');
    }
  }

  // ==================== FILE UPLOAD ====================

  Future<String?> uploadFile(Uint8List fileData, String fileName, String contentType) async {
    try {
      final bucket = _supabase.storage.from('user-files');
      final filePath = '${DateTime.now().millisecondsSinceEpoch}_$fileName';
      
      await bucket.uploadBinary(
        filePath,
        fileData,
        fileOptions: FileOptions(
          contentType: contentType,
          upsert: false,
        ),
      );

      return bucket.getPublicUrl(filePath);
    } catch (e) {
      print('Upload file error: $e');
      return null;
    }
  }

  Future<String?> uploadProfileImage(Uint8List imageData, String userId) async {
    try {
      final bucket = _supabase.storage.from('profile-images');
      final filePath = '${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      
      await bucket.uploadBinary(
        filePath,
        imageData,
        fileOptions: const FileOptions(
          contentType: 'image/jpeg',
          upsert: true,
        ),
      );

      return bucket.getPublicUrl(filePath);
    } catch (e) {
      print('Upload profile image error: $e');
      return null;
    }
  }
} 
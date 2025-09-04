import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class SupabaseService {
  static late SupabaseClient _supabase;
  static String get supabaseUrl => const String.fromEnvironment('SUPABASE_URL', 
    defaultValue: 'https://zqcykjxwsnlxmtzcmiga.supabase.co');
  static String get supabaseAnonKey => const String.fromEnvironment('SUPABASE_ANON_KEY', 
    defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpxY3lranh3c25seG10emNtaWdhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY4NDI4MDgsImV4cCI6MjA3MjQxODgwOH0.dkH258TCMv4q7XXLknfnLNCJu1LVqEGdzabsh-0Oj7s');

  Future<void> initialize() async {
    try {
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
      );
      _supabase = Supabase.instance.client;
    } catch (e) {
      print('Supabase initialization error: $e');
    }
  }

  SupabaseClient get client => _supabase;

  Future<User?> getCurrentUser() async {
    try {
      return _supabase.auth.currentUser;
    } catch (e) {
      print('Get current user error: $e');
      return null;
    }
  }

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required Map<String, dynamic> userData,
  }) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
      data: userData,
    );
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      _disconnectRealtimeChannels();
    } catch (e) {
      print('Sign out error: $e');
    }
  }

  void _disconnectRealtimeChannels() {
    // Simplified for web compatibility
    print('Disconnecting realtime channels');
  }

  // Messaging functionality
  void initializeMessaging() {
    // Simplified for web compatibility
    print('Initializing messaging');
  }

  void initializeNotifications() {
    // Simplified for web compatibility
    print('Initializing notifications');
  }

  Future<List<Map<String, dynamic>>> getConversations(String userId) async {
    try {
      final response = await _supabase
          .from('conversations')
          .select('*, participants(*)')
          .eq('participant1_id', userId)
          .order('updated_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Get conversations error: $e');
      return [];
    }
  }

  Stream<List<Map<String, dynamic>>> listenToConversations(String userId) {
    return _supabase
        .from('conversations')
        .stream(primaryKey: ['id'])
        .eq('participant1_id', userId)
        .order('updated_at', ascending: false)
        .map((response) => List<Map<String, dynamic>>.from(response));
  }

  Future<List<Map<String, dynamic>>> getMessages(String conversationId) async {
    try {
      final response = await _supabase
          .from('messages')
          .select('*')
          .eq('conversation_id', conversationId)
          .order('created_at', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Get messages error: $e');
      return [];
    }
  }

  Stream<List<Map<String, dynamic>>> listenToMessages(String conversationId) {
    return _supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('conversation_id', conversationId)
        .order('created_at', ascending: true)
        .map((response) => List<Map<String, dynamic>>.from(response));
  }

  Future<void> sendMessage({
    required String conversationId,
    required String senderId,
    required String receiverId,
    required String content,
    required String messageType,
  }) async {
    try {
      await _supabase.from('messages').insert({
        'conversation_id': conversationId,
        'sender_id': senderId,
        'receiver_id': receiverId,
        'content': content,
        'message_type': messageType,
      });

      // Update conversation's last message
      await _supabase
          .from('conversations')
          .update({'updated_at': DateTime.now().toIso8601String()})
          .eq('id', conversationId);
    } catch (e) {
      print('Send message error: $e');
      rethrow;
    }
  }

  Future<void> markMessageAsRead(String messageId) async {
    try {
      await _supabase
          .from('messages')
          .update({'read_at': DateTime.now().toIso8601String()})
          .eq('id', messageId);
    } catch (e) {
      print('Mark message as read error: $e');
    }
  }

  Future<String?> initiateVoiceCall({
    required String callerId,
    required String receiverId,
  }) async {
    try {
      final response = await _supabase.from('voice_calls').insert({
        'caller_id': callerId,
        'receiver_id': receiverId,
        'status': 'initiated',
        'started_at': DateTime.now().toIso8601String(),
      }).select();

      if (response.isNotEmpty) {
        return response.first['id'];
      }
      return null;
    } catch (e) {
      print('Initiate voice call error: $e');
      return null;
    }
  }

  Future<String?> uploadVoiceMessage(String conversationId, dynamic audioFile) async {
    if (kIsWeb) {
      // Skip voice upload for web
      print('Voice upload skipped for web');
      return null;
    }
    
    try {
      final path = 'voice_messages/$conversationId/${DateTime.now().millisecondsSinceEpoch}.m4a';
      await _supabase.storage.from('voice-messages').upload(path, audioFile);
      return _supabase.storage.from('voice-messages').getPublicUrl(path);
    } catch (e) {
      print('Upload voice message error: $e');
      return null;
    }
  }

  // User profile functionality
  Future<String?> uploadProfileImage(String userId, dynamic imageFile) async {
    try {
      final path = 'profile_images/$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';
      await _supabase.storage.from('profile-images').upload(path, imageFile);
      return _supabase.storage.from('profile-images').getPublicUrl(path);
    } catch (e) {
      print('Upload profile image error: $e');
      return null;
    }
  }

  Future<void> updateUserProfile(String userId, Map<String, dynamic> updates) async {
    try {
      await _supabase
          .from('user_profiles')
          .update(updates)
          .eq('user_id', userId);
    } catch (e) {
      print('Update user profile error: $e');
    }
  }

  // Notifications
  Future<int> getUnreadNotificationCount(String userId) async {
    try {
      final response = await _supabase
          .from('notifications')
          .select('*')
          .eq('user_id', userId);

      return response.where((notification) => notification['read_at'] == null).length;
    } catch (e) {
      print('Get unread notification count error: $e');
      return 0;
    }
  }
} 
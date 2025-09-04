import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newly_graduate_hub/services/supabase_service.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:typed_data';
import 'dart:async';
import 'dart:io';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final TextEditingController _messageController = TextEditingController();
  final Color deepPurple = const Color(0xFF6C2786);
  final SupabaseService _supabaseService = SupabaseService();
  
  // Audio recording
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isRecording = false;
  bool _isPlaying = false;
  String? _currentPlayingMessageId;
  Duration _recordingDuration = Duration.zero;
  Timer? _recordingTimer;
  
  // Data
  List<Map<String, dynamic>> _conversations = [];
  List<Map<String, dynamic>> _messages = [];
  Map<String, dynamic>? _currentConversation;
  String? _currentUserId;
  bool _isLoading = true;
  bool _isLoadingMessages = false;
  
  // Real-time
  StreamSubscription? _messagesSubscription;
  StreamSubscription? _conversationsSubscription;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    final user = _supabaseService.getCurrentUser();
    if (user != null) {
      _currentUserId = user.id;
      await _loadConversations();
      await _initializeRealtime();
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadConversations() async {
    if (_currentUserId == null) return;

    try {
      final conversations = await _supabaseService.getConversations(_currentUserId!);
      setState(() {
        _conversations = conversations;
      });
    } catch (e) {
      print('Load conversations error: $e');
    }
  }

  Future<void> _loadMessages(String conversationId) async {
    setState(() {
      _isLoadingMessages = true;
    });

    try {
      final messages = await _supabaseService.getMessages(conversationId);
      setState(() {
        _messages = messages;
        _isLoadingMessages = false;
      });
      
      // Mark messages as read
      for (var message in messages) {
        if (message['sender_id'] != _currentUserId && message['read_at'] == null) {
          await _supabaseService.markMessageAsRead(message['id']);
        }
      }
    } catch (e) {
      print('Load messages error: $e');
      setState(() {
        _isLoadingMessages = false;
      });
    }
  }

  Future<void> _initializeRealtime() async {
    if (_currentUserId == null) return;

    try {
      _supabaseService.initializeMessaging();
      
      // Listen for new messages - simplified for now
      _loadConversations();
    } catch (e) {
      print('Initialize realtime error: $e');
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty || _currentConversation == null || _currentUserId == null) return;

    final messageText = _messageController.text.trim();
    _messageController.clear();

    try {
      await _supabaseService.sendMessage(
        conversationId: _currentConversation!['id'],
        senderId: _currentUserId!,
        receiverId: _currentConversation!['participant1_id'] == _currentUserId 
            ? _currentConversation!['participant2_id'] 
            : _currentConversation!['participant1_id'],
        content: messageText,
        messageType: 'text',
      );
      
      // Reload messages to show the new message
      await _loadMessages(_currentConversation!['id']);
    } catch (e) {
      print('Send message error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send message', style: GoogleFonts.poppins()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        await _audioRecorder.start();
        
        setState(() {
          _isRecording = true;
          _recordingDuration = Duration.zero;
        });
        
        _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            _recordingDuration += const Duration(seconds: 1);
          });
        });
      }
    } catch (e) {
      print('Start recording error: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      _recordingTimer?.cancel();
      
      setState(() {
        _isRecording = false;
      });
      
      if (path != null && _currentConversation != null && _currentUserId != null) {
        // Read the audio file - simplified for web
        final audioData = await File(path).readAsBytes();
          
          // Upload voice message - simplified for web
          final voiceUrl = await _supabaseService.uploadVoiceMessage(
            _currentConversation!['id'],
            File(path),
          );
          
          if (voiceUrl != null) {
            await _supabaseService.sendMessage(
              conversationId: _currentConversation!['id'],
              senderId: _currentUserId!,
              content: 'Voice message',
              messageType: 'voice',
              voiceUrl: voiceUrl,
              // voiceDuration: _recordingDuration.inSeconds, // Removed for web compatibility
            );
            
            await _loadMessages(_currentConversation!['id']);
          }
        }
      }
    } catch (e) {
      print('Stop recording error: $e');
    }
  }

  Future<void> _playVoiceMessage(String voiceUrl, String messageId) async {
    try {
      if (_isPlaying && _currentPlayingMessageId == messageId) {
        await _audioPlayer.stop();
        setState(() {
          _isPlaying = false;
          _currentPlayingMessageId = null;
        });
      } else {
        if (_isPlaying) {
          await _audioPlayer.stop();
        }
        
        await _audioPlayer.play(UrlSource(voiceUrl));
        setState(() {
          _isPlaying = true;
          _currentPlayingMessageId = messageId;
        });
        
        _audioPlayer.onPlayerComplete.listen((event) {
          setState(() {
            _isPlaying = false;
            _currentPlayingMessageId = null;
          });
        });
      }
    } catch (e) {
      print('Play voice message error: $e');
    }
  }

  Future<void> _initiateVoiceCall(String receiverId) async {
    if (_currentUserId == null) return;

    try {
      final callId = await _supabaseService.initiateVoiceCall(
        callerId: _currentUserId!,
        receiverId: receiverId,
        // callType: 'audio', // Removed for web compatibility
      );
      
      if (callId != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Initiating voice call...', style: GoogleFonts.poppins()),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Initiate voice call error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to initiate call', style: GoogleFonts.poppins()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _selectConversation(Map<String, dynamic> conversation) {
    setState(() {
      _currentConversation = conversation;
    });
    _loadMessages(conversation['id']);
  }

  Widget _buildConversationList() {
    if (_conversations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No conversations yet',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start a conversation with someone from your school',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _conversations.length,
      itemBuilder: (context, index) {
        final conversation = _conversations[index];
        final participants = conversation['participants'] as List;
        final otherParticipant = participants.firstWhere(
          (p) => p['user_id'] != _currentUserId,
          orElse: () => participants.first,
        );
        final lastMessage = conversation['last_message']?.first;
        
        return ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: otherParticipant['user_profiles']?['profile_image_url'] != null
                ? NetworkImage(otherParticipant['user_profiles']['profile_image_url'])
                : null,
            child: otherParticipant['user_profiles']?['profile_image_url'] == null
                ? Text(
                    '${otherParticipant['user_profiles']?['first_name']?[0] ?? ''}${otherParticipant['user_profiles']?['last_name']?[0] ?? ''}',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                : null,
          ),
          title: Text(
            '${otherParticipant['user_profiles']?['first_name'] ?? ''} ${otherParticipant['user_profiles']?['last_name'] ?? ''}',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                otherParticipant['user_profiles']?['university'] ?? '',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: deepPurple,
                ),
              ),
              if (lastMessage != null)
                Text(
                  lastMessage['message_type'] == 'voice' ? '🎤 Voice message' : lastMessage['content'],
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (otherParticipant['user_profiles']?['is_online'] == true)
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => _initiateVoiceCall(otherParticipant['user_id']),
                icon: Icon(Icons.call, color: deepPurple, size: 20),
              ),
            ],
          ),
          onTap: () => _selectConversation(conversation),
        );
      },
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isMe = message['sender_id'] == _currentUserId;
    final messageType = message['message_type'] as String;
    final content = message['content'] as String;
    final timestamp = DateTime.parse(message['created_at']);
    final sender = message['sender'];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe)
            CircleAvatar(
              radius: 16,
              backgroundImage: sender?['profile_image_url'] != null
                  ? NetworkImage(sender['profile_image_url'])
                  : null,
              child: sender?['profile_image_url'] == null
                  ? Text(
                      '${sender?['first_name']?[0] ?? ''}${sender?['last_name']?[0] ?? ''}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
          if (!isMe) const SizedBox(width: 6),
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                color: isMe ? const Color(0xFFF8F6FF) : Colors.white,
                border: Border.all(
                  color: deepPurple.withOpacity(0.7),
                  width: 2,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMe ? 16 : 0),
                  bottomRight: Radius.circular(isMe ? 0 : 16),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (messageType == 'voice')
                    _buildVoiceMessageWidget(message)
                  else
                    Text(
                      content,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(timestamp),
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isMe) const SizedBox(width: 6),
          if (isMe)
            CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage('assets/pages_assets/profile.png'),
            ),
        ],
      ),
    );
  }

  Widget _buildVoiceMessageWidget(Map<String, dynamic> message) {
    final isPlaying = _isPlaying && _currentPlayingMessageId == message['id'];
    final voiceUrl = message['voice_url'];
    final duration = message['voice_duration'] ?? 0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => _playVoiceMessage(voiceUrl, message['id']),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: deepPurple,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Voice message',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            Text(
              '${duration}s',
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  Widget _buildInputBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        color: Colors.white,
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                // Handle attach action
              },
              child: Image.asset('assets/pages_assets/upload_files.png',
                  width: 24, height: 24),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: _isRecording ? 'Recording... ${_recordingDuration.inSeconds}s' : 'Type a message',
                  hintStyle: GoogleFonts.poppins(
                    color: _isRecording ? Colors.red : Colors.grey,
                    fontSize: 15,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  filled: true,
                  fillColor: Colors.white,
                ),
                enabled: !_isRecording,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                // Handle camera action
              },
              child: Image.asset('assets/pages_assets/Camera.png',
                  width: 24, height: 24),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _isRecording ? _stopRecording : _startRecording,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _isRecording ? Colors.red : deepPurple,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  _isRecording ? Icons.stop : Icons.mic,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _isRecording ? null : _sendMessage,
              child: Image.asset(
                'assets/pages_assets/sender.png',
                width: 24,
                height: 24,
                color: _isRecording ? Colors.grey : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset('assets/pages_assets/ChevronLeftOutline.png',
              width: 24, height: 24),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          _currentConversation != null ? 'Chat' : 'Messages',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          if (_currentConversation != null)
            IconButton(
              onPressed: () {
                setState(() {
                  _currentConversation = null;
                  _messages.clear();
                });
              },
              icon: Icon(Icons.arrow_back, color: deepPurple),
            ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Image.asset('assets/pages_items/Bell.png',
                width: 26, height: 26),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (_currentConversation == null)
                  Expanded(child: _buildConversationList())
                else
                  Expanded(
                    child: _isLoadingMessages
                        ? const Center(child: CircularProgressIndicator())
                        : _messages.isEmpty
                            ? Center(
                                child: Text(
                                  'No messages yet',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                itemCount: _messages.length,
                                reverse: false,
                                itemBuilder: (context, index) {
                                  final message = _messages[index];
                                  return _buildMessageBubble(message);
                                },
                              ),
                  ),
                if (_currentConversation != null) _buildInputBar(),
              ],
            ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    _recordingTimer?.cancel();
    _messagesSubscription?.cancel();
    _conversationsSubscription?.cancel();
    super.dispose();
  }
}

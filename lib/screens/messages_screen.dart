import 'package:flutter/material.dart';
import 'package:newly_graduate_hub/services/supabase_service.dart';
import 'package:newly_graduate_hub/screens/skills_screen.dart';
import 'dart:async';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  final TextEditingController _messageController = TextEditingController();
  
  List<Map<String, dynamic>> _conversations = [];
  List<Map<String, dynamic>> _messages = [];
  Map<String, dynamic>? _currentConversation;
  String? _currentUserId;
  bool _isLoading = true;
  bool _isLoadingMessages = false;
  bool _isRecording = false;
  Duration _recordingDuration = Duration.zero;
  Timer? _recordingTimer;
  StreamSubscription? _messagesSubscription;
  StreamSubscription? _conversationsSubscription;

  @override
  void initState() {
    super.initState();
    _initializeMessages();
  }

  Future<void> _initializeMessages() async {
    try {
      final user = await _supabaseService.getCurrentUser();
      if (user != null) {
        _currentUserId = user.id;
        await _loadConversations();
        _supabaseService.initializeMessaging();
        _listenToConversations();
      }
    } catch (e) {
      print('Error initializing messages: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadConversations() async {
    try {
      final conversations = await _supabaseService.getConversations(_currentUserId!);
      setState(() {
        _conversations = conversations;
      });
    } catch (e) {
      print('Error loading conversations: $e');
    }
  }

  void _listenToConversations() {
    _conversationsSubscription = _supabaseService.listenToConversations(_currentUserId!).listen((conversations) {
      setState(() {
        _conversations = conversations;
      });
    });
  }

  Future<void> _loadMessages(String conversationId) async {
    setState(() {
      _isLoadingMessages = true;
    });

    try {
      final messages = await _supabaseService.getMessages(conversationId);
      setState(() {
        _messages = messages;
      });
      
      // Listen to new messages
      _messagesSubscription?.cancel();
      _messagesSubscription = _supabaseService.listenToMessages(conversationId).listen((messages) {
        setState(() {
          _messages = messages;
        });
      });
    } catch (e) {
      print('Error loading messages: $e');
    } finally {
      setState(() {
        _isLoadingMessages = false;
      });
    }
  }

  Future<void> _sendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty || _currentConversation == null) return;

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
      _messageController.clear();
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  Future<void> _initiateVoiceCall() async {
    if (_currentUserId == null) return;

    try {
      final callId = await _supabaseService.initiateVoiceCall(
        callerId: _currentUserId!,
        receiverId: _currentConversation!['participant1_id'] == _currentUserId 
            ? _currentConversation!['participant2_id'] 
            : _currentConversation!['participant1_id'],
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Voice call initiated: $callId')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to initiate call: $e')),
      );
    }
  }

  void _selectConversation(Map<String, dynamic> conversation) {
    setState(() {
      _currentConversation = conversation;
    });
    _loadMessages(conversation['id']);
  }

  Widget _buildConversationsList() {
    if (_conversations.isEmpty) {
      return const Center(
        child: Text('No conversations yet'),
      );
    }

    return ListView.builder(
      itemCount: _conversations.length,
      itemBuilder: (context, index) {
        final conversation = _conversations[index];
        final otherParticipant = conversation['participants'].firstWhere(
          (p) => p['user_id'] != _currentUserId,
        );

        return ListTile(
          leading: CircleAvatar(
            backgroundImage: otherParticipant['profile_image'] != null
                ? NetworkImage(otherParticipant['profile_image'])
                : null,
            child: otherParticipant['profile_image'] == null
                ? Text(otherParticipant['full_name'][0].toUpperCase())
                : null,
          ),
          title: Text(otherParticipant['full_name']),
          subtitle: Text(conversation['last_message'] ?? 'No messages yet'),
          onTap: () => _selectConversation(conversation),
        );
      },
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isMe = message['sender_id'] == _currentUserId;
    final messageType = message['message_type'] ?? 'text';

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (messageType == 'text')
              Text(
                message['content'],
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black,
                  fontSize: 16,
                ),
              ),
            if (messageType == 'voice')
              _buildVoiceMessage(message),
            const SizedBox(height: 4),
            Text(
              _formatTimestamp(message['created_at']),
              style: TextStyle(
                color: isMe ? Colors.white70 : Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceMessage(Map<String, dynamic> message) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.play_arrow,
          color: Colors.white,
          size: 24,
        ),
        const SizedBox(width: 8),
        Text(
          'Voice Message',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(String? timestamp) {
    if (timestamp == null) return '';
    final date = DateTime.parse(timestamp);
    return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(25),
            ),
            child: IconButton(
              onPressed: _sendMessage,
              icon: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentConversation != null ? 'Chat' : 'Messages',
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          if (_currentConversation != null)
            IconButton(
              onPressed: () {
                setState(() {
                  _currentConversation = null;
                  _messages.clear();
                });
              },
              icon: const Icon(Icons.arrow_back),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (_currentConversation == null)
                  Expanded(child: _buildConversationsList())
                else
                  Expanded(
                    child: _isLoadingMessages
                        ? const Center(child: CircularProgressIndicator())
                        : _messages.isEmpty
                            ? const Center(child: Text('No messages yet'))
                            : ListView.builder(
                                itemCount: _messages.length,
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
    _recordingTimer?.cancel();
    _messagesSubscription?.cancel();
    _conversationsSubscription?.cancel();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newly_graduate_hub/services/supabase_service.dart';

class CareerAssistantScreen extends StatefulWidget {
  const CareerAssistantScreen({super.key});

  @override
  State<CareerAssistantScreen> createState() => _CareerAssistantScreenState();
}

class _CareerAssistantScreenState extends State<CareerAssistantScreen> {
  final Color deepPurple = const Color(0xFF6C2786);
  final SupabaseService _supabaseService = SupabaseService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  void _initializeChat() {
    final user = _supabaseService.getCurrentUser();
    if (user != null) {
      _currentUserId = user.id;
      _addWelcomeMessage();
    }
  }

  void _addWelcomeMessage() {
    _messages.add({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'text': 'Hello! I\'m your Career Assistant AI. I can help you with:\n\n• Resume writing and optimization\n• Interview preparation\n• Job search strategies\n• Career planning and guidance\n• Skill development advice\n\nWhat would you like to know about?',
      'isUser': false,
      'timestamp': DateTime.now(),
      'type': 'welcome',
    });
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty || _currentUserId == null) return;

    // Add user message
    final userMessage = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'text': message,
      'isUser': true,
      'timestamp': DateTime.now(),
    };

    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
    });

    _messageController.clear();
    _scrollToBottom();

    try {
      // Get AI response
      final response = await _supabaseService.getCareerAdvice(
        userId: _currentUserId!,
        query: message,
      );

      final aiMessage = {
        'id': (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        'text': response['advice'] ?? 'I\'m sorry, I couldn\'t process your request. Please try again.',
        'isUser': false,
        'timestamp': DateTime.now(),
        'type': response['type'] ?? 'general',
        'confidence': response['confidence'] ?? 0.8,
      };

      setState(() {
        _messages.add(aiMessage);
        _isLoading = false;
      });

      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages.add({
          'id': (DateTime.now().millisecondsSinceEpoch + 1).toString(),
          'text': 'I\'m sorry, I encountered an error. Please try again later.',
          'isUser': false,
          'timestamp': DateTime.now(),
          'type': 'error',
        });
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isUser = message['isUser'] as bool;
    final text = message['text'] as String;
    final timestamp = message['timestamp'] as DateTime;

    return Container(
      margin: EdgeInsets.only(
        left: isUser ? 50 : 16,
        right: isUser ? 16 : 50,
        bottom: 12,
      ),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isUser ? deepPurple : Colors.grey[100],
              borderRadius: BorderRadius.circular(20).copyWith(
                bottomLeft: isUser ? const Radius.circular(20) : const Radius.circular(5),
                bottomRight: isUser ? const Radius.circular(5) : const Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isUser && message['type'] != 'welcome')
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: _getTypeColor(message['type']).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getTypeLabel(message['type']),
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: _getTypeColor(message['type']),
                      ),
                    ),
                  ),
                Text(
                  text,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: isUser ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: isUser ? 0 : 16,
              right: isUser ? 16 : 0,
              top: 4,
            ),
            child: Text(
              _formatTime(timestamp),
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(String? type) {
    switch (type) {
      case 'resume_tips':
        return Colors.blue;
      case 'interview_prep':
        return Colors.green;
      case 'career_paths':
        return Colors.orange;
      case 'job_search':
        return Colors.purple;
      case 'skill_development':
        return Colors.teal;
      default:
        return deepPurple;
    }
  }

  String _getTypeLabel(String? type) {
    switch (type) {
      case 'resume_tips':
        return 'Resume Tips';
      case 'interview_prep':
        return 'Interview Prep';
      case 'career_paths':
        return 'Career Paths';
      case 'job_search':
        return 'Job Search';
      case 'skill_development':
        return 'Skill Development';
      default:
        return 'Career Advice';
    }
  }

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildQuickActions() {
    final quickActions = [
      {'text': 'Resume Tips', 'icon': Icons.description},
      {'text': 'Interview Prep', 'icon': Icons.people},
      {'text': 'Job Search', 'icon': Icons.work},
      {'text': 'Career Paths', 'icon': Icons.trending_up},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: deepPurple,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: quickActions.map((action) {
              return GestureDetector(
                onTap: () {
                  _messageController.text = action['text'] as String;
                  _sendMessage();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: deepPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: deepPurple.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        action['icon'] as IconData,
                        size: 16,
                        color: deepPurple,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        action['text'] as String,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: deepPurple,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
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
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.psychology,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Career Assistant AI',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Your AI Career Guide',
                  style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Column(
        children: [
          if (_messages.isEmpty) _buildQuickActions(),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isLoading) {
                  return Container(
                    margin: const EdgeInsets.only(left: 50, right: 16, bottom: 12),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(20).copyWith(
                              bottomLeft: const Radius.circular(5),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(deepPurple),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Thinking...',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
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
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Ask me about your career...',
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: deepPurple,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: IconButton(
                    onPressed: _isLoading ? null : _sendMessage,
                    icon: Icon(
                      _isLoading ? Icons.hourglass_empty : Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
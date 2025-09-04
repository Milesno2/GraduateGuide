import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CareerAssistantScreen extends StatefulWidget {
  const CareerAssistantScreen({super.key});

  @override
  State<CareerAssistantScreen> createState() => _CareerAssistantScreenState();
}

class _CareerAssistantScreenState extends State<CareerAssistantScreen> {
  final List<_Msg> _messages = <_Msg>[];
  final TextEditingController _input = TextEditingController();
  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _seed();
  }

  void _seed() {
    _messages.clear();
    _messages.addAll([
      _Msg(
        fromBot: true,
        text:
            'Hi! I\'m your Career Guide. What is your field or area of interest?\nFor example: Computer Science, Nursing, Law, Product Design, Data, Business...',
      ),
      _Msg(fromBot: true, text: 'You can type it below or tap a suggestion:'),
    ]);
    setState(() {});
  }

  void _send(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add(_Msg(fromBot: false, text: text.trim()));
      _input.clear();
    });
    _autoReply(text.trim());
  }

  void _autoReply(String userText) {
    // Very lightweight, local guidance tree
    final lower = userText.toLowerCase();
    String reply;
    if (lower.contains('design')) {
      reply = 'Great! For Design, here\'s a path:\n\n'
          '1) Foundations: Color, Typography, Layout\n'
          '2) Tools: Figma/Adobe XD\n'
          '3) Build: 3 portfolio case studies\n'
          '4) Network: Join design communities\n\n'
          'Would you like beginner resources, portfolio tips, or jobs in Design?';
    } else if (lower.contains('data')) {
      reply = 'Awesome! Data track:\n\n'
          '1) Learn: Excel → SQL → Python\n'
          '2) Practice: Kaggle datasets\n'
          '3) Visualize: Power BI / Tableau\n'
          '4) Portfolio: 3-5 projects\n\n'
          'Focus on learning path, project ideas, or job prep?';
    } else if (lower.contains('software') || lower.contains('computer')) {
      reply = 'Software path:\n\n'
          '1) CS basics: DS/Algo\n'
          '2) Web or Mobile stack\n'
          '3) Version control + Deploy\n'
          '4) 2-3 real apps\n\n'
          'Prefer Web (Frontend/Backend/Fullstack) or Mobile (Flutter/React Native)?';
    } else if (lower.contains('nurse') || lower.contains('medical') || lower.contains('health')) {
      reply = 'Healthcare path:\n\n'
          '1) Certifications & CPD\n'
          '2) Specialization (e.g., Public Health)\n'
          '3) Volunteer/Internship\n\n'
          'Want certification links, specialization ideas, or scholarship info?';
    } else {
      reply = 'Got it. I can help with learning paths, resources, and jobs.\n'
          'Would you like: Learning Plan, Project Ideas, or Job Prep?';
    }

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() => _messages.add(_Msg(fromBot: true, text: reply)));
      _scrollToEnd();
    });
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _chip(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, bottom: 8),
      child: ActionChip(
        label: Text(label, style: GoogleFonts.poppins()),
        onPressed: () => _send(label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Career Guide', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _messages.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Wrap(
                    children: [
                      _chip('Computer Science'),
                      _chip('Product Design'),
                      _chip('Data Analysis'),
                      _chip('Nursing'),
                      _chip('Law'),
                      _chip('Business'),
                    ],
                  );
                }
                final msg = _messages[index - 1];
                return Align(
                  alignment: msg.fromBot ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.76),
                    decoration: BoxDecoration(
                      color: msg.fromBot ? const Color(0xFFF8F6FF) : Colors.white,
                      border: Border.all(color: const Color(0xFF6C2786).withOpacity(0.7), width: 2),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(msg.fromBot ? 0 : 16),
                        bottomRight: Radius.circular(msg.fromBot ? 16 : 0),
                      ),
                    ),
                    child: Text(msg.text, style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87)),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _input,
                      onSubmitted: _send,
                      decoration: InputDecoration(
                        hintText: 'What\'s your field? (e.g., Computer Science)',
                        hintStyle: GoogleFonts.poppins(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => _send(_input.text),
                    icon: const Icon(Icons.send),
                    color: const Color(0xFF6C2786),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Msg {
  final bool fromBot;
  final String text;
  _Msg({required this.fromBot, required this.text});
}
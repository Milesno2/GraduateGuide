import 'dart:async';
import 'package:flutter/material.dart';

class LogConsoleService {
  static final LogConsoleService _instance = LogConsoleService._internal();
  factory LogConsoleService() => _instance;
  LogConsoleService._internal();

  final StreamController<String> _controller = StreamController<String>.broadcast();
  final List<String> _buffer = <String>[];

  void add(String message) {
    final line = '[${DateTime.now().toIso8601String()}] $message';
    _buffer.add(line);
    if (_buffer.length > 500) {
      _buffer.removeAt(0);
    }
    _controller.add(line);
  }

  Stream<String> get stream => _controller.stream;
  List<String> get history => List.unmodifiable(_buffer);
}

class LogConsoleOverlay extends StatefulWidget {
  const LogConsoleOverlay({super.key});

  @override
  State<LogConsoleOverlay> createState() => _LogConsoleOverlayState();
}

class _LogConsoleOverlayState extends State<LogConsoleOverlay> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !_open,
      child: Stack(
        children: [
          // Toggle button (always clickable)
          Positioned(
            right: 12,
            bottom: 12,
            child: IgnorePointer(
              ignoring: false,
              child: FloatingActionButton.small(
                onPressed: () => setState(() => _open = !_open),
                backgroundColor: _open ? Colors.redAccent : Colors.black87,
                child: Icon(_open ? Icons.close : Icons.terminal, color: Colors.white),
              ),
            ),
          ),
          if (_open)
            Positioned(
              left: 12,
              right: 12,
              bottom: 68,
              height: MediaQuery.of(context).size.height * 0.45,
              child: Material(
                elevation: 8,
                color: Colors.black.withOpacity(0.9),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: _LogStreamView(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _LogStreamView extends StatefulWidget {
  @override
  State<_LogStreamView> createState() => _LogStreamViewState();
}

class _LogStreamViewState extends State<_LogStreamView> {
  final LogConsoleService _svc = LogConsoleService();
  final ScrollController _scroll = ScrollController();
  late StreamSubscription<String> _sub;
  late List<String> _lines;

  @override
  void initState() {
    super.initState();
    _lines = List<String>.from(_svc.history);
    _sub = _svc.stream.listen((line) {
      setState(() => _lines.add(line));
      _autoScroll();
    });
  }

  void _autoScroll() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.jumpTo(_scroll.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text('Live Console', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            ),
            TextButton(
              onPressed: () => setState(() => _lines = []),
              child: const Text('Clear', style: TextStyle(color: Colors.orangeAccent)),
            ),
          ],
        ),
        const Divider(color: Colors.white24, height: 1),
        const SizedBox(height: 8),
        Expanded(
          child: Scrollbar(
            controller: _scroll,
            child: ListView.builder(
              controller: _scroll,
              itemCount: _lines.length,
              itemBuilder: (context, index) {
                return Text(
                  _lines[index],
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
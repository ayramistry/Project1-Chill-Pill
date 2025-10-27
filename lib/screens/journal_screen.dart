import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'calm_home_page.dart'; // for back navigation

class JournalScreen extends StatefulWidget {
  const JournalScreen({Key? key}) : super(key: key);

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _float1;
  late Animation<double> _float2;
  late Animation<double> _float3;

  List<Map<String, dynamic>> _entries = [];
  final TextEditingController _entryController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  late AudioPlayer _audioPlayer;
  bool _isRainPlaying = false;
  double _volume = 0.5;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _loadEntries();
    _audioPlayer = AudioPlayer();
  }

  void _initAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    _float1 = Tween<double>(begin: 0, end: 20)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _float2 = Tween<double>(begin: 0, end: 15)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine));
    _float3 = Tween<double>(begin: 0, end: 25)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic));
  }

  Future<void> _loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('journalEntries');
    if (stored != null) {
      setState(() {
        _entries = List<Map<String, dynamic>>.from(json.decode(stored));
        _entries.sort((a, b) =>
            DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])));
      });
    }
  }

  Future<void> _saveEntries() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('journalEntries', json.encode(_entries));
  }

  Future<void> _toggleRainSound() async {
    if (_isRainPlaying) {
      await _audioPlayer.stop();
    } else {
      await _audioPlayer.play(AssetSource('rain_sound.mp3'));
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.setVolume(_volume);
    }
    setState(() {
      _isRainPlaying = !_isRainPlaying;
    });
  }

  void _addEntry() {
    if (_entryController.text.trim().isEmpty ||
        _titleController.text.trim().isEmpty) return;

    final newEntry = {
      'title': _titleController.text.trim(),
      'content': _entryController.text.trim(),
      'date': DateTime.now().toIso8601String(),
    };

    setState(() {
      _entries.insert(0, newEntry);
    });

    _saveEntries();
    _entryController.clear();
    _titleController.clear();
    Navigator.pop(context);
  }

  void _openNewEntryDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFFDE1EB),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
        side: const BorderSide(color: Color(0xFFF7A4C3), width: 3),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "New Journal Entry",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _entryController,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    labelText: "Write your thoughts...",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _addEntry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF7A4C3),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                  child: Text(
                    "Save Entry",
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openEntryView(Map<String, dynamic> entry) {
    showDialog(
      context: context,
      builder: (context) => _TypingEntryDialog(entry: entry),
    );
  }

  String _formatDate(String iso) {
    final date = DateTime.parse(iso);
    final formatter = DateFormat('MM/dd/yyyy  hh:mm a');
    return formatter.format(date);
  }

  Widget _buildCircle(double size, Color color) => Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.25),
              blurRadius: 6,
              spreadRadius: 0.5,
            ),
          ],
        ),
      );

  @override
  void dispose() {
    _audioPlayer.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          // 🌸 Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFED4E7), Color(0xFFF8EFFF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // ⬅️ Back button
          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Color(0xFF7C4DFF), size: 28),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),

          // ☁️ Rain toggle button
          Positioned(
            top: 50,
            right: 20,
            child: IconButton(
              icon: Icon(
                _isRainPlaying ? Icons.cloud_off : Icons.cloud_queue,
                color: const Color(0xFF7C4DFF),
                size: 30,
              ),
              onPressed: _toggleRainSound,
              tooltip: _isRainPlaying ? "Stop Rain" : "Play Rain",
            ),
          ),

          // 🌕 Floating dots
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Stack(
                children: [
                  Positioned(
                    top: 180 + _float1.value,
                    left: 50,
                    child: _buildCircle(
                      45,
                      Colors.purple.shade100.withOpacity(0.3),
                    ),
                  ),
                  Positioned(
                    top: 230 - _float2.value,
                    right: 40,
                    child: _buildCircle(
                      60,
                      Colors.purple.shade200.withOpacity(0.3),
                    ),
                  ),
                  Positioned(
                    bottom: 260 + _float3.value,
                    left: 70,
                    child: _buildCircle(35, Colors.white.withOpacity(0.3)),
                  ),
                ],
              );
            },
          ),

          // 💜 Purple curved background
          Positioned(
            top: MediaQuery.of(context).size.height * 0.22,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: Color(0xFF7C4DFF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(120),
                  topRight: Radius.circular(120),
                ),
              ),
            ),
          ),

          // 📝 Journal content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),
                Text(
                  "My Journal",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),

                // Volume control slider (only visible when playing)
                if (_isRainPlaying)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Slider(
                      value: _volume,
                      min: 0,
                      max: 1,
                      divisions: 10,
                      activeColor: const Color(0xFF7C4DFF),
                      inactiveColor: Colors.purple.shade100,
                      label: "Volume",
                      onChanged: (value) {
                        setState(() => _volume = value);
                        _audioPlayer.setVolume(value);
                      },
                    ),
                  ),

                GestureDetector(
                  onTap: _openNewEntryDialog,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF7A4C3),
                          shape: BoxShape.circle,
                        ),
                        child:
                            const Icon(Icons.add, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Add New Entry",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                Expanded(
                  child: _entries.isEmpty
                      ? Center(
                          child: Text(
                            "No entries (yet...)",
                            style: GoogleFonts.nunito(
                              fontSize: 18,
                              color: Colors.black54,
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: ListView.builder(
                            itemCount: _entries.length,
                            itemBuilder: (context, index) {
                              final entry = _entries[index];
                              return GestureDetector(
                                onTap: () => _openEntryView(entry),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.all(18),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.purple.shade200,
                                      width: 2,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        entry['title'],
                                        style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        _formatDate(entry['date']),
                                        style: GoogleFonts.nunito(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
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
}

// 🌷 Typing animation dialog
class _TypingEntryDialog extends StatefulWidget {
  final Map<String, dynamic> entry;
  const _TypingEntryDialog({required this.entry});

  @override
  State<_TypingEntryDialog> createState() => _TypingEntryDialogState();
}

class _TypingEntryDialogState extends State<_TypingEntryDialog> {
  String displayedText = "";
  int index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTypingAnimation();
  }

  void _startTypingAnimation() {
    final fullText = widget.entry['content'];
    _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (index < fullText.length) {
        setState(() {
          displayedText += fullText[index];
          index++;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFFFDE1EB),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFFF7A4C3), width: 3),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.entry['title'],
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                DateFormat('MM/dd/yyyy  hh:mm a')
                    .format(DateTime.parse(widget.entry['date'])),
                style: GoogleFonts.nunito(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 12),
              Text(
                displayedText,
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  height: 1.4,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

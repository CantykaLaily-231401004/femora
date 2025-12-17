import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class MusicPlayerPopup extends StatefulWidget {
  const MusicPlayerPopup({Key? key}) : super(key: key);

  @override
  State<MusicPlayerPopup> createState() => _MusicPlayerPopupState();
}

class _MusicPlayerPopupState extends State<MusicPlayerPopup> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  final List<Map<String, String>> _musicList = [
    {'title': 'Healing Frequency Meditation', 'path': 'sounds/musik_rileks.mp3'},
    // Anda bisa menambahkan musik lain di sini
    // {'title': 'Ocean Waves', 'path': 'sounds/relaxing_music_2.mp3'},
  ];

  int _currentIndex = 0;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  late StreamSubscription _playerStateSubscription;
  late StreamSubscription _durationSubscription;
  late StreamSubscription _positionSubscription;
  late StreamSubscription _completionSubscription;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  void _initPlayer() {
    _playerStateSubscription = _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) setState(() => _isPlaying = state == PlayerState.playing);
    });

    _durationSubscription = _audioPlayer.onDurationChanged.listen((d) {
      if (mounted) setState(() => _duration = d);
    });

    _positionSubscription = _audioPlayer.onPositionChanged.listen((p) {
      if (mounted) setState(() => _position = p);
    });

    _completionSubscription = _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() => _position = _duration); // Mark as finished
        if (_musicList.length > 1) _nextTrack();
      }
    });

    _playMusic(_currentIndex);
  }

  Future<void> _playMusic(int index) async {
    if (!mounted) return;
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(_musicList[index]['path']!));
      if(mounted) setState(() => _currentIndex = index);
    } catch (e) {
      debugPrint("Error playing music: $e");
    }
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      // If finished, restart. Otherwise, resume.
      if (_position >= _duration && _duration > Duration.zero) {
        await _playMusic(_currentIndex);
      } else {
        await _audioPlayer.resume();
      }
    }
  }

  Future<void> _nextTrack() async {
    if (_musicList.length < 2) return;
    int nextIndex = (_currentIndex + 1) % _musicList.length;
    await _playMusic(nextIndex);
  }

  Future<void> _previousTrack() async {
    if (_musicList.length < 2) return;
    int prevIndex = (_currentIndex - 1 + _musicList.length) % _musicList.length;
    await _playMusic(prevIndex);
  }

  @override
  void dispose() {
    _playerStateSubscription.cancel();
    _durationSubscription.cancel();
    _positionSubscription.cancel();
    _completionSubscription.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
  
  String _formatDuration(Duration d) => d.toString().split('.').first.substring(2, 7);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 520, // Increased height slightly
      decoration: const BoxDecoration(
        color: Color(0xFFFDEBD0),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Stack(
        children: [
          // Using SingleChildScrollView to prevent overflow
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, 
              children: [
                const SizedBox(height: 32),
                const Text('Musik Relaksasi 🎵', style: TextStyle(color: Color(0xFFF75270), fontSize: 24, fontFamily: 'Poppins', fontWeight: FontWeight.w700)),
                const SizedBox(height: 24),
                Container(
                  width: 140, height: 140, // Slightly smaller
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 4))],
                  ),
                  child: const Icon(Icons.music_note, size: 70, color: Color(0xFFF75270)),
                ),
                const SizedBox(height: 24),
                Text(_musicList[_currentIndex]['title']!, style: const TextStyle(color: Color(0xFFF75270), fontSize: 20, fontFamily: 'Poppins', fontWeight: FontWeight.w600), textAlign: TextAlign.center),
                const SizedBox(height: 16),
                Slider(
                  value: _position.inSeconds.toDouble().clamp(0.0, _duration.inSeconds.toDouble()),
                  max: _duration.inSeconds.toDouble() > 0 ? _duration.inSeconds.toDouble() : 1.0,
                  activeColor: const Color(0xFFF75270),
                  inactiveColor: Colors.grey.shade300,
                  onChanged: (v) => _audioPlayer.seek(Duration(seconds: v.toInt())),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_formatDuration(_position), style: const TextStyle(color: Color(0xFFF75270), fontSize: 12)),
                      Text(_formatDuration(_duration), style: const TextStyle(color: Color(0xFFF75270), fontSize: 12)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(onPressed: _musicList.length > 1 ? _previousTrack : null, icon: const Icon(Icons.skip_previous), iconSize: 40, color: const Color(0xFFF75270).withOpacity(_musicList.length > 1 ? 1.0 : 0.5)),
                    Container(
                      width: 64, height: 64,
                      decoration: const BoxDecoration(color: Color(0xFFF75270), shape: BoxShape.circle),
                      child: IconButton(onPressed: _togglePlayPause, icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow), iconSize: 36, color: Colors.white),
                    ),
                    IconButton(onPressed: _musicList.length > 1 ? _nextTrack : null, icon: const Icon(Icons.skip_next), iconSize: 40, color: const Color(0xFFF75270).withOpacity(_musicList.length > 1 ? 1.0 : 0.5)),
                  ],
                ),
              ],
            ),
          ),
          // Close Button
          Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.close, color: Color(0xFFF75270)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
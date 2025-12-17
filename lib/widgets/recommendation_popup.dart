import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class RecommendationPopup extends StatefulWidget {
  final String header;
  final String message;
  final String? imageName;

  const RecommendationPopup({
    Key? key,
    required this.header,
    required this.message,
    this.imageName,
  }) : super(key: key);

  @override
  State<RecommendationPopup> createState() => _RecommendationPopupState();
}

class _RecommendationPopupState extends State<RecommendationPopup> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _showPlayer = false;

  // --- Audio Player State ---
  final List<Map<String, String>> _musicList = [
    {'title': 'Musik Rileks', 'path': 'sounds/musik_rileks.mp3'},
    // TODO: Add more tracks here if you want
    // {'title': 'Ocean Waves', 'path': 'sounds/ocean_waves.mp3'},
    // {'title': 'Rain Sounds', 'path': 'sounds/rain_sounds.mp3'},
  ];

  int _currentIndex = 0;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  StreamSubscription? _playerSubscription;

  @override
  void dispose() {
    _playerSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _initAndPlay() {
    _playerSubscription = _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) setState(() => _isPlaying = state == PlayerState.playing);
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      if (mounted) setState(() => _duration = duration);
    });

    _audioPlayer.onPositionChanged.listen((position) {
      if (mounted) setState(() => _position = position);
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _position = _duration;
          _isPlaying = false;
        });
      }
    });

    _playTrack(_currentIndex);
  }

  Future<void> _playTrack(int index) async {
    // Stop previous track if any, then play the new one.
    await _audioPlayer.stop(); 
    await _audioPlayer.play(AssetSource(_musicList[index]['path']!));
    if (mounted) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      // If finished, restart from beginning
      if (_position >= _duration) {
         await _playTrack(_currentIndex);
      } else {
         await _audioPlayer.resume();
      }
    }
  }


  Future<void> _nextTrack() async {
    if (_musicList.length > 1) {
      int nextIndex = (_currentIndex + 1) % _musicList.length;
      await _playTrack(nextIndex);
    }
  }

  Future<void> _previousTrack() async {
    if (_musicList.length > 1) {
      int prevIndex = (_currentIndex - 1 + _musicList.length) % _musicList.length;
      await _playTrack(prevIndex);
    }
  }


  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
        decoration: const BoxDecoration(
          color: Color(0xFFFDEBD0),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Stack(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: ScaleTransition(scale: animation, child: child));
              },
              child: _showPlayer ? _buildPlayer() : _buildRecommendation(),
            ),
            Positioned(
              top: -10,
              right: -10,
              child: IconButton(
                icon: const Icon(Icons.close, color: Color(0xFFF75270)),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendation() {
    // This is the view with the Yes/No buttons
    return Column(
      key: const ValueKey('recommendation'),
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.header,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFFF75270),
            fontSize: 24,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          widget.message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFFF75270),
            fontSize: 20,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 32),
        const Text(
          'Putar Musik Relaksasi?',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFF75270),
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            setState(() => _showPlayer = true);
            _initAndPlay();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF75270),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: const Text('Iya', style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFFF75270)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.symmetric(vertical: 12),
            foregroundColor: const Color(0xFFF75270),
          ),
          child: const Text('Tidak', style: TextStyle(fontSize: 18)),
        ),
      ],
    );
  }

  Widget _buildPlayer() {
    // This is the music player view
    return Column(
      key: const ValueKey('player'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Musik Relaksasi',
          style: TextStyle(color: Color(0xFFF75270), fontSize: 24, fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          width: 120, height: 120,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)]),
          child: const Icon(Icons.music_note, size: 60, color: Color(0xFFF75270)),
        ),
        const SizedBox(height: 16),
        Text(
          _musicList[_currentIndex]['title']!,
          style: const TextStyle(color: Color(0xFFF75270), fontSize: 20, fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        Slider(
          value: _position.inSeconds.toDouble().clamp(0.0, _duration.inSeconds.toDouble()),
          max: _duration.inSeconds.toDouble(),
          onChanged: (value) => _audioPlayer.seek(Duration(seconds: value.toInt())),
          activeColor: const Color(0xFFF75270),
          inactiveColor: Colors.grey.shade300,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_formatDuration(_position), style: const TextStyle(color: Color(0xFFF75270))),
              Text(_formatDuration(_duration), style: const TextStyle(color: Color(0xFFF75270))),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: _musicList.length > 1 ? _previousTrack : null,
              icon: const Icon(Icons.skip_previous), iconSize: 40, color: const Color(0xFFF75270).withOpacity(_musicList.length > 1 ? 1.0 : 0.4)
            ),
            Container(
              width: 64, height: 64,
              decoration: const BoxDecoration(color: Color(0xFFF75270), shape: BoxShape.circle),
              child: IconButton(
                onPressed: _togglePlayPause,
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow), iconSize: 36, color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: _musicList.length > 1 ? _nextTrack : null,
              icon: const Icon(Icons.skip_next), iconSize: 40, color: const Color(0xFFF75270).withOpacity(_musicList.length > 1 ? 1.0 : 0.4)
            ),
          ],
        ),
      ],
    );
  }
}

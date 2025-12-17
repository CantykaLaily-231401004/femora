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
    {
      'title': 'Calm Meditation',
      'url': 'https://cdn.pixabay.com/download/audio/2022/05/27/audio_1808fbf07a.mp3'
    },
    {
      'title': 'Peaceful Piano',
      'url': 'https://cdn.pixabay.com/download/audio/2022/03/10/audio_d1718ab41b.mp3'
    },
    {
      'title': 'Healing Frequency',
      'url': 'https://cdn.pixabay.com/download/audio/2021/11/26/audio_bb630cc098.mp3'
    },
  ];

  int _currentIndex = 0;
  bool _isPlaying = false;
  bool _isLoading = true; // Start in loading state
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  String _errorMessage = '';

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
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
          // Any final state means we are no longer loading.
          if (state == PlayerState.playing || state == PlayerState.paused || state == PlayerState.completed) {
            _isLoading = false;
          }
        });
      }
    });

    _durationSubscription = _audioPlayer.onDurationChanged.listen((d) {
      if (mounted) setState(() => _duration = d);
    });

    _positionSubscription = _audioPlayer.onPositionChanged.listen((p) {
      if (mounted) setState(() => _position = p);
    });

    _completionSubscription = _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() => _position = _duration);
        if (_musicList.length > 1) _nextTrack();
      }
    });

    _playMusic(_currentIndex);
  }

  Future<void> _playMusic(int index) async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _currentIndex = index;
    });

    try {
      await _audioPlayer.play(UrlSource(_musicList[index]['url']!));
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Gagal memuat musik. Periksa koneksi.';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      if (_position >= _duration && _duration > Duration.zero) {
        await _playMusic(_currentIndex);
      } else {
        await _audioPlayer.resume();
      }
    }
  }

  Future<void> _nextTrack() async {
    if (_musicList.length < 2) return;
    await _playMusic((_currentIndex + 1) % _musicList.length);
  }

  Future<void> _previousTrack() async {
    if (_musicList.length < 2) return;
    await _playMusic((_currentIndex - 1 + _musicList.length) % _musicList.length);
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
  
  String _formatDuration(Duration d) {
    if (d.inSeconds < 0) return '00:00';
    return d.toString().split('.').first.substring(2, 7);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 520,
      decoration: const BoxDecoration(
        color: Color(0xFFFDEBD0),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(32, 24, 32, 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, 
              children: [
                const SizedBox(height: 32),
                const Text('Musik Relaksasi 🎵', style: TextStyle(color: Color(0xFFF75270), fontSize: 24, fontFamily: 'Poppins', fontWeight: FontWeight.w700)),
                const SizedBox(height: 24),
                
                Container(
                  width: 140, height: 140,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 4))],
                  ),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator(color: Color(0xFFF75270)))
                      : Icon(_isPlaying ? Icons.volume_up_rounded : Icons.volume_down_rounded, size: 70, color: const Color(0xFFF75270)),
                ),
                
                const SizedBox(height: 24),
                Text(_musicList[_currentIndex]['title']!, style: const TextStyle(color: Color(0xFFF75270), fontSize: 20, fontFamily: 'Poppins', fontWeight: FontWeight.w600), textAlign: TextAlign.center),
                
                if (_errorMessage.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(_errorMessage, style: const TextStyle(color: Colors.redAccent, fontSize: 12), textAlign: TextAlign.center),
                ],
                
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
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(_formatDuration(_position), style: const TextStyle(color: Color(0xFFF75270), fontSize: 12)),
                    Text(_formatDuration(_duration), style: const TextStyle(color: Color(0xFFF75270), fontSize: 12)),
                  ]),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(onPressed: _musicList.length > 1 ? _previousTrack : null, icon: const Icon(Icons.skip_previous), iconSize: 40, color: const Color(0xFFF75270).withOpacity(_musicList.length > 1 ? 1.0 : 0.5)),
                    Container(
                      width: 64, height: 64,
                      decoration: const BoxDecoration(color: Color(0xFFF75270), shape: BoxShape.circle),
                      child: _isLoading
                          ? const Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)))
                          : IconButton(onPressed: _togglePlayPause, icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow), iconSize: 36, color: Colors.white),
                    ),
                    IconButton(onPressed: _musicList.length > 1 ? _nextTrack : null, icon: const Icon(Icons.skip_next), iconSize: 40, color: const Color(0xFFF75270).withOpacity(_musicList.length > 1 ? 1.0 : 0.5)),
                  ],
                ),
                const SizedBox(height: 20), // Bottom padding to ensure no overflow
              ],
            ),
          ),
          Positioned(
            top: 16, right: 16,
            child: IconButton(icon: const Icon(Icons.close, color: Color(0xFFF75270)), onPressed: () => Navigator.of(context).pop()),
          ),
        ],
      ),
    );
  }
}
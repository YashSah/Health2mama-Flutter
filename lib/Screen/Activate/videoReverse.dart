import 'package:flutter/material.dart';
import 'package:health2mama/Utils/pref_utils.dart';
import 'package:video_player/video_player.dart';
import 'package:flick_video_player/flick_video_player.dart';

class ReverseVideoPlayer extends StatefulWidget {
  ReverseVideoPlayer();

  @override
  _ReverseVideoPlayerState createState() => _ReverseVideoPlayerState();
}

class _ReverseVideoPlayerState extends State<ReverseVideoPlayer> {
  late FlickManager _flickManager;
  late VideoPlayerController _videoController;
  bool _isReversing = false;
  bool _isReverseModeEnabled = false; // Track reverse mode
  final int _fps = 30;

  @override
  void initState() {
    super.initState();

    // Initialize the video player and FlickManager
    _videoController =
        VideoPlayerController.network(PrefUtils.getSquezzesVideo())
          ..initialize().then((_) {
            setState(() {});
            _videoController.play();
          });

    _flickManager = FlickManager(videoPlayerController: _videoController);

    // Add a listener to check for the end of the video
    _videoController.addListener(() {
      if (!_isReversing &&
          !_isReverseModeEnabled &&
          _videoController.value.position >= _videoController.value.duration) {
        _startReversePlayback();
      }
    });
  }

  // Function to start reverse playback
  Future<void> _startReversePlayback() async {
    setState(() {
      _isReversing = true;
      _isReverseModeEnabled = true;
    });
    _flickManager.flickControlManager?.pause();

    // Simulate reverse playback
    while (_videoController.value.position > Duration.zero) {
      final newTime = _videoController.value.position -
          Duration(milliseconds: (1000 / _fps).round());
      await _videoController
          .seekTo(newTime > Duration.zero ? newTime : Duration.zero);

      // Wait for the seek operation to complete
      await Future.delayed(Duration(milliseconds: (1000 / _fps).round()));
    }

    // After reverse playback, reset to the beginning
    setState(() {
      _isReversing = false;
    });
    _videoController.seekTo(Duration.zero);

    // Play the video again in forward mode after reverse playback
    _flickManager.flickControlManager?.play();
    setState(() {
      _isReverseModeEnabled = false; // Reset reverse mode flag
    });
  }

  @override
  void dispose() {
    _flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reverse Video Playback"),
      ),
      body: Center(
        child: _videoController.value.isInitialized
            ? FlickVideoPlayer(flickManager: _flickManager)
            : CircularProgressIndicator(),
      ),
    );
  }
}

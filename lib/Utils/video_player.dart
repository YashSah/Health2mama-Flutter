import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({
    Key? key,
    required this.videoUrl,
  }) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  bool _isLoading = true; // Loading state for the video
  bool _showControls = false;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(
      widget.videoUrl,
      videoPlayerOptions: VideoPlayerOptions(
        mixWithOthers: true, // Allows other audio (like Spotify) to continue playing
      ),
    )..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isLoading = false; // Video is now loaded
          });
        }
      });

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      looping: false,
      showControls: _showControls,
      aspectRatio: 16 / 9,
    );
  }

  // Toggle the visibility of controls on video tap
  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
      _chewieController = _chewieController.copyWith(showControls: _showControls);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleControls, // Toggle controls visibility on tap
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Chewie(
              controller: _chewieController,
            ),
          ),
          // Show CircularProgressIndicator while loading
          if (_isLoading)
            const CircularProgressIndicator(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _chewieController.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }
}

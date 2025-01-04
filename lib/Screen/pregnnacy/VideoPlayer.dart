// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
//
// class VideoPlayerScreen extends StatefulWidget {
//   @override
//   _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
// }
//
// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   late VideoPlayerController _controller;
//   late Future<void> _initializeVideoPlayerFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     // Initialize the VideoPlayerController with the video URL
//     _controller = VideoPlayerController.network(
//       'https://api.dyntube.com/v1/apps/hls/shm1RbjDSEegrSx0oiZqZw.m3u8',
//     );
//
//     // Initialize the controller and store the Future for later use
//     _initializeVideoPlayerFuture = _controller.initialize().then((_) {
//       // Ensure the first frame is shown after the video is initialized
//       setState(() {
//         _controller.play(); // Automatically play the video
//       });
//     }).catchError((error) {
//       print("Error initializing video player: $error");
//     });
//   }
//
//   @override
//   void dispose() {
//     // Dispose the controller when the widget is disposed
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: FutureBuilder(
//           future: _initializeVideoPlayerFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.done) {
//               // If the video is initialized, display the video
//               return AspectRatio(
//                 aspectRatio: _controller.value.aspectRatio,
//                 child: VideoPlayer(_controller),
//               );
//             } else if (snapshot.hasError) {
//               // If there's an error, display an error message
//               return Center(child: Text('Error loading video: ${snapshot.error}'));
//             } else {
//               // Otherwise, show a loading spinner
//               return CircularProgressIndicator();
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class TutorialVideo extends StatefulWidget {
  final String videoPath;

  const TutorialVideo({Key? key, required this.videoPath}) : super(key: key);

  @override
  _TutorialVideoState createState() => _TutorialVideoState();
}

class _TutorialVideoState extends State<TutorialVideo> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(true);
        _controller.setVolume(0);
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : Container(
            child: Center(child: CircularProgressIndicator()),
          );
  }
}

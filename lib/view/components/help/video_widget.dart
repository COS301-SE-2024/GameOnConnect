import 'package:flutter/material.dart';
import 'package:webviewtube/webviewtube.dart';


class TutorialVideo extends StatefulWidget {
  final String videoPath;

  const TutorialVideo({super.key, required this.videoPath});

  @override
  // ignore: library_private_types_in_public_api
  _TutorialVideoState createState() => _TutorialVideoState();
}

class _TutorialVideoState extends State<TutorialVideo> {
  late WebviewtubeController _controller;
  late String video;
  @override
  void initState() {
    super.initState();
    _controller = WebviewtubeController();
    video = widget.videoPath;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
        WebviewtubeVideoPlayer(videoId:video );

  }
}

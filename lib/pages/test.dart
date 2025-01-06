import 'package:flutter/material.dart';

import 'package:just_audio/just_audio.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  final player = AudioPlayer();
  String url = "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3";
  void _play() async {
    await player.play();
  }
  @override
  void initState() {
    super.initState();
    player.setUrl(url);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("test"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _play,
          child: Text("play"),
        ),
      ),
    );
  }
}
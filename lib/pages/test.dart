import 'package:flutter/material.dart';

import 'package:audioplayers/audioplayers.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  AudioPlayer player = AudioPlayer();
  String url = "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3";
  void _play() async {
    await player.setSourceUrl(url);
    await player.resume();
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
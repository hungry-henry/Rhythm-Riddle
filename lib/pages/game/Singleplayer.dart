import 'package:flutter/material.dart';
import '/generated/l10n.dart';
import 'package:http/http.dart' as http;

class SinglePlayer extends StatefulWidget {
  const SinglePlayer({Key? key}) : super(key: key);

  @override
  State<SinglePlayer> createState() => _SinglePlayerState();
}

class _SinglePlayerState extends State<SinglePlayer> {
  int playlistId = 0;
  String playlistTitle = '';
  String createTime = '';
  String createdBy = '';
  String musicTitle = '';
  String artist = '';
  int musicCount = 0;
  String? description;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final Map args = ModalRoute.of(context)?.settings.arguments as Map;
      setState(() {
        playlistId = args["id"];
        playlistTitle = args["title"];
        createTime = args["createTime"];
        createdBy = args["createdBy"];
        musicTitle = args["musicTitle"];
        artist = args["artist"];
        description = args["description"];
        musicCount = args["count"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${S.current.singlePlayer}: $playlistTitle")),
      body: Center(
        //输出歌单所有信息
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(playlistTitle),
            Text(createTime),
            Text(createdBy),
            Text(musicTitle),
            Text(artist),
            Text(description ?? ''),
            Text(musicCount.toString()),
          ]
        )
      )
    );
  }
}
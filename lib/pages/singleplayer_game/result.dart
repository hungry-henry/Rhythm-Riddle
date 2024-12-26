import 'package:flutter/material.dart';
import '/generated/l10n.dart';

class SinglePlayerGameResult extends StatefulWidget {
  @override
  State<SinglePlayerGameResult> createState() => _SinglePlayerGameResultState();
}

class _SinglePlayerGameResultState extends State<SinglePlayerGameResult> {
  Map _resultMap = {};
  int? _playlistId;
  String? _playlistTitle;

  @override
  void initState() {
    super.initState();
    setState(() {
      final args = ModalRoute.of(context)?.settings.arguments as Map;
      _resultMap = args['resultMap'];
      _playlistId = args['playlistId'];
      _playlistTitle = args['playlistTitle'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.quizResult(_playlistTitle ?? '')),
      ),
      body: Center(
        child: Text(_resultMap.toString()),
      ),
    );
  }
}
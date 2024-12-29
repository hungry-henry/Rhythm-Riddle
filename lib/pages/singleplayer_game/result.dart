import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import '/generated/l10n.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

class SinglePlayerGameResult extends StatefulWidget {
  @override
  State<SinglePlayerGameResult> createState() => _SinglePlayerGameResultState();
}

class _SinglePlayerGameResultState extends State<SinglePlayerGameResult> {
  static const storage = FlutterSecureStorage();
  String? _uid;
  String? _password;

  Map _resultMap = {};
  int? _playlistId;
  String? _playlistTitle;

  Logger logger = Logger();

  String? _responseBody;

  Future<void> _postResult() async {
    try{
      final response = await http.post(
        Uri.parse('http://hungryhenry.xyz/api/result.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'playlist_id': _playlistId.toString(),
          'player_id': _uid ?? '',
          'player_password': _password ?? '',
          'result_map': _resultMap
        })
      ).timeout(const Duration(seconds:7));
      setState(() {
        _responseBody = response.body;
      });
    }catch(e){
      if(e is TimeoutException && mounted){
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(context: context, builder: (context){
            return AlertDialog(
              content: Text(S.current.connectError),
              actions: [
                TextButton(onPressed: () {
                  Navigator.of(context).pop();
                }, child: Text("好吧")),
              ],
            );
          });
        });
      }else{
        logger.e(_responseBody ?? e);
        if(mounted){
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDialog(context: context, builder: (context){
              return AlertDialog(
                content: Text(S.current.unknownError),
                actions: [
                  TextButton(onPressed: () { 
                    Navigator.of(context).pushNamedAndRemoveUntil('/home', arguments: _playlistId, (route) => false);
                    Navigator.of(context).pushNamed('/PlaylistInfo', arguments: _playlistId);
                  }, child: Text(S.current.back))
                ],
              );
            });
          });
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    storage.read(key: 'uid').then((value) => setState(() {
      _uid = value!;
    }));
    storage.read(key: 'password').then((value) => setState(() {
      _password = value!;
    }));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    if (args != null) {
      setState(() {
        _resultMap = args['resultMap'];
        _playlistId = args['playlistId'];
        _playlistTitle = args['playlistTitle'];
      });
    }
    _postResult();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.quizResult(_playlistTitle ?? '')),
      ),
      body: Center(
        child: Text(_responseBody??'loading...'),
      ),
    );
  }
}
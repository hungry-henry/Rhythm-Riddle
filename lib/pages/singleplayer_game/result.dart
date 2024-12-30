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

  Map? _responseData;
  int? _score;

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
      if(mounted){
        setState(() {
          _responseData = jsonDecode(response.body);
          _score = _responseData!["score"];
        });
      }
    }catch(e){
      if(e is TimeoutException && mounted && _score == null){
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
        logger.e(_responseData);
        logger.e(e);
        if(mounted && _score == null){
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDialog(context: context, builder: (context){
              return AlertDialog(
                content: Text(S.current.unknownError),
                actions: [
                  TextButton(onPressed: () {Navigator.of(context).pop();}, 
                  child: Text(S.current.back))
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

    //延迟执行
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map?;
      if (args != null) {
        setState(() {
          _resultMap = args['resultMap'];
          _playlistId = args['playlistId'];
          _playlistTitle = args['playlistTitle'];
        });
      }
      _postResult();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.quizResult(_playlistTitle ?? '')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _playlistId != null ? Image.network(
                "http://hungryhenry.xyz/musiclab/playlist/$_playlistId.jpg",
                width: MediaQuery.of(context).size.width > MediaQuery.of(context).size.height ?
                MediaQuery.of(context).size.height * 0.45 : MediaQuery.of(context).size.width * 0.5,
              ) : const CircularProgressIndicator(),
          
              const SizedBox(height: 16),
              // 星星
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  double starValue = (_score != null ? _score! / 2 : 0.0) - index;
                  return _buildStar(starValue);
                }),
              ),
              const SizedBox(height: 16),
              // 分数
              Text(
                "${_score != null ? _score!.toStringAsFixed(1) : " - "} / 10",
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
          
              const SizedBox(height: 16),
              Text(
                S.current.details,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              // 详细信息
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 600
                ),
                child: Column(
                  children:[
                    for (var item in _resultMap.entries)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${int.parse(item.key) + 1}. ${item.value['quizType'] == 0 ? S.current.chooseMusic
                                      : item.value['quizType'] == 1 ? S.current.chooseArtist
                                      : item.value['quizType'] == 2 ? S.current.chooseAlbum
                                      : item.value['quizType'] == 3 ? S.current.chooseGenre : "WTF??HOW??"}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                for (var option in item.value['options'])
                                  Container(
                                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: Border.all(
                                        color: (option["title"] ?? option["name"]) == item.value['answer']
                                            ? Colors.green : Colors.red,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: ListTile(
                                      leading: (option["title"] ?? option["name"]) == item.value['submitText']
                                          ? const Icon(Icons.flag, color: Colors.blue)
                                          : null,
                                      title: Text((option["title"] ?? option["name"])),
                                      trailing: (option["title"] ?? option["name"]) == item.value['answer']
                                          ? Icon(Icons.check, color: Colors.green) : null
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ]
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildStar(double value) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const Icon(
          Icons.star_border, // 背景未选中的星星
          size: 40,
          color: Colors.grey,
        ),
        ClipRect(
          child: Align(
            alignment: Alignment.centerLeft,
            widthFactor: value > 1
                ? 1
                : value > 0
                    ? value
                    : 0,
            child: Icon(
              Icons.star, // 前景已选中的星星
              size: 40,
              color: Colors.amber,
            ),
          ),
        ),
      ],
    );
  }
}
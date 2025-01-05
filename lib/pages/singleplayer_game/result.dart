import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/generated/l10n.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:audioplayers/audioplayers.dart';

class SinglePlayerGameResult extends StatefulWidget {
  @override
  State<SinglePlayerGameResult> createState() => _SinglePlayerGameResultState();
}

class _SinglePlayerGameResultState extends State<SinglePlayerGameResult> {
  //用户信息
  static const storage = FlutterSecureStorage();
  String? _uid;
  String? _password;

  //传入参数
  Map _resultMap = {};
  int? _playlistId;
  String? _playlistTitle;

  Logger logger = Logger();

  //api返回数据
  Map? _responseData;
  int? _score;

  //播放器
  final _audioPlayer = AudioPlayer();
  //播放变化监测变量
  PlayerState? _playerState;
  Duration? _duration;
  Duration? _position;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerStateChangeSubscription;
  bool get _isPlaying => _playerState == PlayerState.playing;
  bool get _isPaused => _playerState == PlayerState.paused;
  String get _durationTextUnSplited => _duration?.toString() ?? "";
  String get _positionTextUnSplited => _position?.toString() ?? "";
  String get _durationText => _durationTextUnSplited.substring(
    _durationTextUnSplited.indexOf(":")+1,
    _durationTextUnSplited.lastIndexOf(".")
  );
  String get _positionText => _positionTextUnSplited.substring(
    _positionTextUnSplited.indexOf(":")+1,
    _positionTextUnSplited.lastIndexOf(".")
  );

  bool _loading = false;

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

  void _initStreams() {
    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _positionSubscription = _audioPlayer.onPositionChanged.listen(
      (p) => setState(() => _position = p),
    );

    _playerCompleteSubscription = _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration.zero;
      });
    });

    _playerStateChangeSubscription =
        _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _playerState = state;
      });
      logger.i(state);
    });
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
    _initStreams();
  }
  
  @override
  void dispose() { //释放资源内存
    _audioPlayer.dispose();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerStateChangeSubscription?.cancel();
    super.dispose();
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
              Wrap(
                spacing: 16.0, // Horizontal spacing between cards
                runSpacing: 16.0, // Vertical spacing between rows
                alignment: WrapAlignment.center,
                children:[
                  for (var item in _resultMap.entries)
                    SizedBox(
                      width:340,
                      height: 360,
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: ListView(
                            children: [
                              if(_isPlaying && _audioPlayer.source.toString() ==
                              UrlSource("http://hungryhenry.xyz/musiclab/music/${item.value['musicId']}.mp3").toString())...
                              [
                                //进度条
                                SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    trackHeight: 2,
                                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                                  ),
                                  child: Slider(
                                    onChanged: (value) {
                                      final duration = _duration;
                                      if (duration == null) {
                                        return;
                                      }
                                      final position = value * duration.inMilliseconds;
                                      _audioPlayer.seek(Duration(milliseconds: position.round()));
                                      if(_isPaused){
                                        _audioPlayer.resume();
                                        _playerState = PlayerState.playing;
                                      }
                                    },
                                    value: (_position != null &&
                                            _duration != null &&
                                            _position!.inMilliseconds > 0 &&
                                            _position!.inMilliseconds < _duration!.inMilliseconds)
                                        ? _position!.inMilliseconds / _duration!.inMilliseconds
                                        : 0.0,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      _position != null ? _positionText : '',
                                      style: const TextStyle(fontSize: 16.0),
                                    ),
                                    const Spacer(),
                                    Text(
                                      _duration != null ? _durationText : '',
                                      style: const TextStyle(fontSize: 16.0),
                                    ),
                                  ],
                                )
                              ],
                              Row(
                                children: [
                                  Expanded(
                                    child: Text( //题目
                                      "${int.parse(item.key) + 1}. ${item.value['quizType'] == 0 ? S.current.chooseMusic
                                          : item.value['quizType'] == 1 ? S.current.chooseArtist
                                          : item.value['quizType'] == 2 ? S.current.chooseAlbum
                                          : item.value['quizType'] == 3 ? S.current.chooseGenre
                                          : item.value['quizType'] == 4 ? S.current.enterMusic
                                          : item.value['quizType'] == 5 ? S.current.enterArtist
                                          : item.value['quizType'] == 6 ? S.current.enterAlbum
                                          : item.value['quizType'] == 7 ? S.current.enterGenre
                                          : "WTF??HOW??"}",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                          
                                  //播放按钮
                                  _loading && _audioPlayer.source.toString() == 
                                  UrlSource("http://hungryhenry.xyz/musiclab/music/${item.value['musicId']}.mp3").toString() ? 
                                  const CircularProgressIndicator() :
                                  IconButton(
                                    icon: _audioPlayer.source == null || !_isPlaying ? (
                                      const Icon(Icons.play_arrow)
                                    ):(
                                      _audioPlayer.source.toString() == 
                                      UrlSource("http://hungryhenry.xyz/musiclab/music/${item.value['musicId']}.mp3").toString() ? 
                                        const Icon(Icons.pause) : const Icon(Icons.play_arrow)
                                    ),
                                    onPressed: () async{
                                      try{
                                        if(!_isPlaying){
                                          if(_audioPlayer.source == null || 
                                            _audioPlayer.source.toString() != 
                                              UrlSource("http://hungryhenry.xyz/musiclab/music/${item.value['musicId']}.mp3").toString())
                                          {
                                            setState(() {_loading = true;});
                                            await _audioPlayer.stop();
                                            await _audioPlayer.play(UrlSource("http://hungryhenry.xyz/musiclab/music/${item.value['musicId']}.mp3"));
                                            setState(() {_loading = false;});
                                          }else{
                                            setState(() {_loading = true;});
                                            await _audioPlayer.resume();
                                            setState(() {_loading = false;});
                                          }
                                        }else{
                                          if(_audioPlayer.source.toString() == 
                                          UrlSource("http://hungryhenry.xyz/musiclab/music/${item.value['musicId']}.mp3").toString())
                                          {
                                            await _audioPlayer.pause();
                                          } else{
                                            setState(() {_loading = true;});
                                            await _audioPlayer.play(UrlSource("http://hungryhenry.xyz/musiclab/music/${item.value['musicId']}.mp3"));
                                            setState(() {_loading = false;});
                                          }
                                        }
                                      }catch(e){
                                        if(mounted){
                                          setState(() {_loading = false;});
                                          if(e is TimeoutException){
                                            showDialog(context: context, builder: (context){
                                              return AlertDialog(
                                                content: Text(S.current.connectError),
                                                actions: [
                                                  TextButton(onPressed: () { Navigator.pop(context);
                                                  }, child: Text(S.current.back)),
                                                ],
                                              );
                                            });
                                          }else{
                                            showDialog(context: context, builder: (context){
                                              return AlertDialog(
                                                  content: Text(S.current.unknownError),
                                                  actions: [
                                                    TextButton(onPressed: () { 
                                                      Navigator.of(context).pushNamedAndRemoveUntil('/home', arguments: _playlistId, (route) => false);
                                                      Navigator.of(context).pushNamed('/PlaylistInfo', arguments: _playlistId);
                                                    }, child: Text(S.current.back)),
                                                  ],
                                              );
                                            });
                                          }
                                        }
                                      }
                                    },
                                  )
                                ],
                              ),
                              const SizedBox(height: 8),
                              if(item.value['options'] != null)...[
                                for (var option in item.value['options'])...[
                                  Container(
                                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: Border.all(
                                        color: (option["text"]) == item.value['answer']
                                            ? Colors.green : Colors.red,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: ListTile(
                                      leading: (option["text"]) == item.value['submitText']
                                          ? option["text"] == item.value["answer"] 
                                          ? const Icon(Icons.check, color: Colors.green)
                                          : const Icon(Icons.close, color: Colors.red) : null,
                                      title: Text((option["text"])),
                                    ),
                                  )
                                ],
                                const SizedBox(height: 5),
                                Text("用时：${item.value['answerTime']}s", textAlign: TextAlign.center)
                              ]else ...[
                                ListTile(
                                  trailing: item.value['answer'] != null ?
                                      item.value['submitText'].toString().toLowerCase() == item.value['answer'].toString().toLowerCase()
                                        ? const Icon(Icons.check, color: Colors.green) : const Icon(Icons.close, color: Colors.red)
                                    : item.value["answerList"].any(
                                      (answers) => item.value['submitText'].toString().toLowerCase() == answers.toString().toLowerCase()
                                    ) ? const Icon(Icons.check, color: Colors.green) : const Icon(Icons.close, color: Colors.red),
                                  title: Text("输入："+item.value['submitText']),
                                ),
                                ListTile(
                                  title: Text("答案：${item.value['answer'] ?? item.value['answerList'].join(", ")}"
                                  ),
                                ),
                                ListTile(
                                  title: Text("回答用时：${item.value['answerTime']}s"),
                                )
                              ]
                            ],
                          ),
                        ),
                      ),
                    ),
                ]
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildStar(double value) {
    return Stack(
      alignment: Alignment.centerLeft,
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
            child: const Icon(
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
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:ui';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:logger/logger.dart';
import '/generated/l10n.dart';
import 'package:palette_generator/palette_generator.dart';

class SinglePlayerGame extends StatefulWidget {
  const SinglePlayerGame({super.key});

  @override
  State<SinglePlayerGame> createState() => _SinglePlayerGameState();
}

class _SinglePlayerGameState extends State<SinglePlayerGame> {
  //数据传入存储
  int _playlistId = 0;
  String _playlistTitle = '';
  String? _description;
  int _difficulty = 4;

  int _currentQuiz = -1; //题目计数器

  //音频&题目显示计时
  int _countdown = 0; 
  bool _canShowQuiz = false;

  Map _quizzes = {}; //存储api获取的题目

  String? _selectedOption; //选项
  String? _submittedOption; //提交的选项

  //歌曲播放准备
  final _audioPlayer = AudioPlayer();
  int _played = 0;
  int _audioPlayingTime = 0;  
  bool _prepareFinished = false;

  Logger logger = Logger(); //日志

  bool _loadTooSlow = false; //在要播放时，没准备好

  //答题时间
  int _answerTime = 0;
  int _currentAnswerTime = 0;

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

  Future<void> _prepareAudio() async {
    logger.i("preparing audio");
    if(_playerState==PlayerState.disposed) return;
    try{
      int id = _quizzes[_played.toString()]['music_id'] ?? _quizzes[_played.toString()]['id'];
      logger.i("start preparing $id");
      await _audioPlayer.setSourceUrl("http://hungryhenry.xyz/musiclab/music/$id.mp3").timeout(const Duration(seconds: 10));
      logger.i("prepare finished $id");
      await _audioPlayer.seek(Duration(seconds: _quizzes[_played.toString()]['start_at'])); // 跳到 startAt
      logger.i("seek finished ${_quizzes[_played.toString()]['start_at']} seconds");
      _prepareFinished = true;
      if(_loadTooSlow){
        setState(() {
          _loadTooSlow = false;
        });
        _resumeAndDelayAndStop();
      }
    }catch(e){
      if(e is TimeoutException){
        logger.log(Level.error, "prepare audio timeout: $e");
        if(!mounted) return;
        showDialog(context: context, builder: (context){
          return AlertDialog(
              content: Text(S.current.connectError),
              actions: [
                TextButton(onPressed: () { 
                  Navigator.of(context).pushNamedAndRemoveUntil('/home', arguments: _playlistId, (route) => false);
                  Navigator.of(context).pushNamed('/PlaylistInfo', arguments: _playlistId);
                }, child: Text(S.current.back)),
              ],
          );
        });
      }else{
        logger.log(Level.error, "prepare audio error: $e");
        if(!mounted) return;
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

  //倒计时
  void _startAudioCountdown() {
    logger.i("starting countdown");
    if(!mounted) return;
    setState(() {
      _countdown = 3; // 初始化倒计时
      _canShowQuiz = false;
      _prepareFinished = false;
    });

    //提前加载音频
    _prepareAudio();

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_countdown > 1) {
        setState(() {
          _countdown--; // 每秒减少1
        });
      } else {
        timer.cancel(); // 停止计时器
        setState(() {
          _currentQuiz = ++_currentQuiz;
          _countdown = 0;
        });

        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            _canShowQuiz = true;
          });
        });
      }
    });
  }


  //获取题目
  Future<void> _getQuiz(int playlistId, int difficulty) async {
    try{
      final response = await http.get(Uri.parse("http://hungryhenry.xyz/api/getQuiz.php?id=$playlistId&difficulty=$difficulty")).timeout(const Duration(seconds: 7));
      if (!mounted) return;
      if (response.statusCode == 200) {
        setState(() {
          _quizzes = jsonDecode(response.body);
        });
      } else {
        print("error");
        print(response.body);
      }
    } catch (e) {
      if(e is TimeoutException && mounted) {
        showDialog(context: context, builder: (context){
          return AlertDialog(
              content: Text(S.current.connectError),
              actions: [
                  TextButton(onPressed: () { 
                    Navigator.of(context).pushNamedAndRemoveUntil('/home', arguments: _playlistId, (route) => false);
                    Navigator.of(context).pushNamed('/PlaylistInfo', arguments: _playlistId);
                  }, child: Text(S.current.back)),
                  TextButton(onPressed: (){
                    Navigator.of(context).popAndPushNamed('/SinglePlayerGame', 
                    arguments: {playlistId, _playlistTitle, _description, difficulty});
                  }, child: Text(S.current.retry))
              ],
          );
        });
      }else{
        logger.i("error: $e");
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
      }
    }
  }

  //答题倒计时
  void _answerTimeCountdown() {
    _currentAnswerTime = _answerTime;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentAnswerTime == 0 || _submittedOption != null) {
        timer.cancel();
        if(_currentAnswerTime == 0 && mounted){
          setState(() {
            _submittedOption = "bruhtimeout";
          });
          if(_playerState == PlayerState.paused){
            _audioPlayer.resume();
            _playerState = PlayerState.playing;
          }
        }
      } else {
        if(mounted){
          setState(() {
            _currentAnswerTime--; // 每秒减少1
          });
        }
      }
    });
  }

  Future<void> _resumeAndDelayAndStop() async{
    logger.i("call on function _resumeAndDelayAndStop");
    
    if(_playerState==PlayerState.disposed) return;
    if(_prepareFinished){
      _played++;
      await _audioPlayer.resume();
      _playerState = PlayerState.playing;
      logger.i("played");
      _answerTimeCountdown();

      if(_playerState == PlayerState.playing){
        await Future.delayed(Duration(seconds: _audioPlayingTime), () {
          if(_submittedOption == null){
            _audioPlayer.pause(); 
            _playerState = PlayerState.paused;
            logger.i("paused");
          }
        });
      }
    }else{
      _loadTooSlow = true;
      logger.i("prepare not finished");
    }
  }

  //显示题目
  Widget _showQuiz(Map quizInfo, int difficulty){
    String answer = quizInfo['answer']; //正确答案
    List options = quizInfo["options"]; //选项list
    String question = "";

    switch(quizInfo["quizType"]){
      case 0: question = S.current.chooseMusic; break;
      case 1: question = S.current.chooseArtist; break;
      case 2: question = S.current.chooseAlbum; break;
      case 3: question = S.current.chooseGenre; break;
      default: S.current.unknownError; break;
    }
    
    return SizedBox(
      width: MediaQuery.of(context).size.width > 800
          ? MediaQuery.of(context).size.width * 0.7 - 350
          : MediaQuery.of(context).size.width * 0.8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("${_currentQuiz+1}/${_quizzes.length-1}"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //题目
              Text(
                question,
                style: const TextStyle(fontSize: 20),
              ),

              if (_submittedOption == null)...[
                //倒计时
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentAnswerTime < 6 && !_loadTooSlow ? Colors.yellow : Colors.grey[300],
                  ),
                  child: _loadTooSlow ? const Center(child:CircularProgressIndicator()) : Text(
                    _currentAnswerTime.toString(),
                    style: _currentAnswerTime < 6 && !_loadTooSlow ? const TextStyle(
                      color: Colors.red,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ) : const TextStyle(fontSize: 24),
                  ),
                ),
              ]
            ],
          ),

          //选项
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
              maxHeight: 320,
            ),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: options.length,
              itemBuilder: (context, index) {
                String currOption = options[index]['title'] ?? options[index]['name'];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: _submittedOption == null
                            ? Colors.transparent
                            : currOption == answer
                                ? Colors.green
                                : Colors.red,
                        width: 1,
                      ),
                    ),
                    title: Text(options[index]['title'] ?? options[index]['name']),
                    leading: Radio<String>(
                      value: options[index]['title'] ?? options[index]['name'],
                      groupValue: _selectedOption,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedOption = value;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          if (_submittedOption == null) ...[
            //提交按钮
            ElevatedButton(
              onPressed: () {
                logger.i("submitted with $_selectedOption");
                setState(() {
                  _submittedOption = _selectedOption;
                });
                if(_playerState != PlayerState.playing){
                  _audioPlayer.resume();
                  _playerState = PlayerState.playing;
                }
              },
              child: Text(S.current.submit), 
            ),
          ] else ...[
            const SizedBox(height: 10),
            _submittedOption == "bruhtimeout" ? const Text("时间到") : _submittedOption == answer ? const Text("正确!") : const Text("错误!"),
            const SizedBox(height: 10),

            if(_currentQuiz + 2 == _quizzes.length) ... [
              //结束
              ElevatedButton(
                onPressed: (){

                },
                child: Text(S.current.end),
              )
            ] else ... [
              //下一题
              ElevatedButton(
                onPressed: () {
                  _audioPlayer.stop();
                  setState(() {
                    _submittedOption = null;
                    _selectedOption = null;
                    _startAudioCountdown();
                  });
                },
                child: Text(S.current.next),
              ),
            ],
            
            if(_submittedOption != null) ...[
              //播放控制
              Row(
                children: [
                  //播放/暂停按钮
                  IconButton(
                    onPressed: (){
                      _isPlaying ? _audioPlayer.pause() : _audioPlayer.resume();
                      setState(() {
                        _playerState = _isPlaying ? PlayerState.paused : PlayerState.playing;
                      });
                    }, 
                    icon: _isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
                  ),
                  //进度条
                  Expanded(
                    child: SliderTheme(
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
                          if(_playerState == PlayerState.paused){
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
                  ),
                  //进度
                  Text(
                    _position != null
                        ? '$_positionText / $_durationText'
                        : _duration != null
                            ? _durationText
                            : '',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ]
          ]
        ],
      ),
    );
  }

  Widget _largeScreen(){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            children: [
              _playlistId == 0 ? const Center(child: CircularProgressIndicator()) : 
              Image.network("http://hungryhenry.xyz/musiclab/playlist/$_playlistId.jpg", width:350, height:350),
              const SizedBox(height: 16),
              Text(_playlistTitle, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              if(_description != null) ... [
                Text(_description ?? "No description", style: const TextStyle(fontSize: 18), softWrap: true),
                const SizedBox(height: 14)
              ],
              Text(
                "${S.current.difficulty}: ${_difficulty == 0 ? S.current.easy : _difficulty == 1 ?
                  S.current.normal : _difficulty == 2 ? S.current.hard
                  : S.current.custom}", 
                style: const TextStyle(fontSize: 18), softWrap: true
              ),
            ],
          ),
      
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _quizzes.isEmpty ? const CircularProgressIndicator() : //加载
                AnimatedSwitcher( //动画
                  duration: const Duration(milliseconds: 800),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: FadeTransition(opacity: animation, child: child),
                    );
                  },
                  child: _countdown > 0 ? 
                    Container(
                      key: ValueKey<int>(_countdown), // 使用倒计时数字作为key
                      padding: const EdgeInsets.all(24), // 调整内边距来增加背景的大小
                      decoration: const BoxDecoration(
                        color: Colors.red, 
                        shape: BoxShape.circle, 
                      ),
                      child: Text(
                        '$_countdown',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ) : const SizedBox.shrink(),
                ),
                const SizedBox(height: 20),
                if (_currentQuiz != -1 && _canShowQuiz && _quizzes[_currentQuiz.toString()] != null) ... [
                  _showQuiz(_quizzes[_currentQuiz.toString()], _difficulty)
                ],
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _smallScreen(){
    return Stack(
      alignment: Alignment.center,
      children: [
        OverflowBox(
          maxWidth: double.infinity,
          maxHeight: double.infinity,
          child: 
            _playlistId == 0 ? 
            const Center(child: CircularProgressIndicator()) : 
            Image.network("http://hungryhenry.xyz/musiclab/playlist/$_playlistId.jpg", 
              width: null,
              height: null,
              fit: BoxFit.cover,
            ),
        ),
        Container(
          color: Theme.of(context).primaryColor.withOpacity(0.5),
          width: double.infinity,
        ),
        //第三层是对前两层背景做高斯模糊处理，然后显示上面的内容
        ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(
              color: Colors.white.withOpacity(0.6),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          ),
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              Text(_playlistTitle, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Text("${S.current.difficulty}: ${_difficulty == 0 ? S.current.easy : _difficulty == 1 ?
                S.current.normal : _difficulty == 2 ? S.current.hard :
                S.current.custom}", style: const TextStyle(fontSize: 16), softWrap: true),
                
              const SizedBox(height:20),
          
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _quizzes.isEmpty ? const CircularProgressIndicator() : //加载
                  AnimatedSwitcher( //动画
                    duration: const Duration(milliseconds: 800),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: FadeTransition(opacity: animation, child: child),
                      );
                    },
                    child: _countdown > 0 ? 
                      Container(
                        key: ValueKey<int>(_countdown), // 使用倒计时数字作为key
                        padding: const EdgeInsets.all(24), // 调整内边距来增加背景的大小
                        decoration: const BoxDecoration(
                          color: Colors.red, 
                          shape: BoxShape.circle, 
                        ),
                        child: Text(
                          '$_countdown',
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ) : const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 20),
                  if (_currentQuiz != -1 && _canShowQuiz && _quizzes[_currentQuiz.toString()] != null) ... [
                    _showQuiz(_quizzes[_currentQuiz.toString()], _difficulty)
                  ],
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  //状态更新
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
      print(state.toString());
    });
  }

  @override
    void initState() {
      super.initState();
      Future.microtask(() {
        //获取传入参数
        final Map args = ModalRoute.of(context)?.settings.arguments as Map;
        setState(() {
          _playlistId = args["id"];
          _playlistTitle = args["title"];
          _description = args["description"];
          _difficulty = args["difficulty"];
        });

        //检测audioplayer状态
        if(_playerState == PlayerState.disposed){
          Navigator.of(context).popAndPushNamed('/SinglePlayerGame', arguments: args);
        }

        //获取题目
        _getQuiz(_playlistId, _difficulty);

        //难度对应时间
        switch (_difficulty) {
          case 0:
            _audioPlayingTime = 6;
            _answerTime = 15;
            break;
          case 1:
            _audioPlayingTime = 4;
            _answerTime = 10;
            break;
          case 2:
            _audioPlayingTime = 2;
            _answerTime = 5;
            break;
          default:
            _audioPlayingTime = 0;
            _answerTime = 0;
        }
      });
      _audioPlayer.onLog.listen(
        (String message) => logger.log(Level.info,message),
        onError: (Object e, [StackTrace? stackTrace]) => logger.log(Level.error, stackTrace),
      );
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
    if (_quizzes.isNotEmpty && _currentQuiz == -1 && _countdown == 0) {
      _startAudioCountdown();
    }
    if(_played == _currentQuiz && _currentQuiz != -1 && _countdown == 0) {
      _resumeAndDelayAndStop();
    }
    return Scaffold(
      extendBodyBehindAppBar: MediaQuery.of(context).size.width > 800 ? false : true,
      appBar: AppBar(
        title: Text("${S.current.singlePlayerGame}: $_playlistTitle"), 
        backgroundColor: Colors.white.withOpacity(0.6),
        elevation: 0,
      ),
      body: MediaQuery.of(context).size.width > 800 ? _largeScreen() : _smallScreen(),
    );
  }
}
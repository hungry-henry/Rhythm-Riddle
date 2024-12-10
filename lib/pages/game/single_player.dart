import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '/generated/l10n.dart';

import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:logger/logger.dart';

class SinglePlayer extends StatefulWidget {
  const SinglePlayer({super.key});

  @override
  State<SinglePlayer> createState() => _SinglePlayerState();
}

class _SinglePlayerState extends State<SinglePlayer> {
  int playlistId = 0;
  String playlistTitle = '';
  String createTime = '';
  String createdBy = '';
  String? description;

  int selectedDifficulty = 0;

  Widget _largeScreen(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Left Column
        Column(
          children: [
            // Playlist Image
            playlistId == 0 ? const Center(child: CircularProgressIndicator()) : Image.network(
              "http://hungryhenry.xyz/musiclab/playlist/$playlistId.jpg",
              width: 350,
              height: 350,
            ),
            const SizedBox(height: 8),
            // Date and Username
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(createTime, style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 16),
                Text(createdBy, style: const TextStyle(fontSize: 14)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              playlistTitle,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // Description
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Text(
                description ?? S.current.noDes,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        // Right Column - Difficulty
         Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              S.current.chooseDifficulty,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDifficulty = 0;
                    });
                  },
                  child: Container(
                    width: 80,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: selectedDifficulty == 0 ? Colors.blue : Colors.grey[300],
                      border: Border.all(color: Colors.grey),
                      borderRadius: const BorderRadius.horizontal(left: Radius.circular(10)),
                    ),
                    child: Center(
                      child: Text(
                        S.current.easy,
                        style: TextStyle(
                          color: selectedDifficulty == 0 ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDifficulty = 1;
                    });
                  },
                  child: Container(
                    width: 80,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: selectedDifficulty == 1 ? Colors.blue : Colors.grey[300],
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Center(
                      child: Text(
                        S.current.normal,
                        style: TextStyle(
                          color: selectedDifficulty == 1 ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDifficulty = 2;
                    });
                  },
                  child: Container(
                    width: 80,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: selectedDifficulty == 2 ? Colors.blue : Colors.grey[300],
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Center(
                      child: Text(
                        S.current.hard,
                        style: TextStyle(
                          color: selectedDifficulty == 2 ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDifficulty = 3;
                    });
                  },
                  child: Container(
                    width: 80,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: selectedDifficulty == 3 ? Colors.blue : Colors.grey[300],
                      border: Border.all(color: Colors.grey),
                      borderRadius: const BorderRadius.horizontal(right: Radius.circular(10)),
                    ),
                    child: Center(
                      child: Text(
                        S.current.custom,
                        style: TextStyle(
                          color: selectedDifficulty == 3 ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                )
              ]
            ),
            const SizedBox(height: 20),
            if(selectedDifficulty != 3) ... [
              Text(
                selectedDifficulty == 0 ? S.current.easyInfo : selectedDifficulty == 1 ? S.current.normalInfo : S.current.hardInfo,
                style: const TextStyle(fontSize: 18),
                softWrap: true,
              ),
              ElevatedButton(onPressed: (){
                Navigator.pushNamed(context, 
                '/SinglePlayerGame',
                arguments: {
                  "id": playlistId,
                  "title": playlistTitle,
                  "description": description,
                  "difficulty": selectedDifficulty
                }
                );
              }, child: Text(S.current.start))
            ] else ... [
              //blahblah
            ],
          ],
        ),
      ],
    );
  }

  Widget _smallScreen(){
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Upper row - Playlist Info
          Column(
            children: [
              // Playlist Image
              playlistId == 0 ? const Center(child: CircularProgressIndicator()) : Image.network(
                "http://hungryhenry.xyz/musiclab/playlist/$playlistId.jpg",
                width: MediaQuery.of(context).size.width < MediaQuery.of(context).size.height * 0.3 ?
                  MediaQuery.of(context).size.width :
                  MediaQuery.of(context).size.height * 0.4,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 8),
              if(description != null) ... [
                Text(
                  description!,
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
              ],
              Text(
                playlistTitle,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          
          const SizedBox(height: 15),
          
          // Lower row - Difficulty
          Text(
            S.current.chooseDifficulty,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500)
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDifficulty = 0;
                  });
                },
                child: Container(
                  width: 80,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: selectedDifficulty == 0 ? Colors.blue : Colors.grey[300],
                    border: Border.all(color: Colors.grey),
                    borderRadius: const BorderRadius.horizontal(left: Radius.circular(10)),
                  ),
                  child: Center(
                    child: Text(
                      S.current.easy,
                      style: TextStyle(
                        color: selectedDifficulty == 0 ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDifficulty = 1;
                  });
                },
                child: Container(
                  width: 80,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: selectedDifficulty == 1 ? Colors.blue : Colors.grey[300],
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Center(
                    child: Text(
                      S.current.normal,
                      style: TextStyle(
                        color: selectedDifficulty == 1 ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDifficulty = 2;
                  });
                },
                child: Container(
                  width: 80,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: selectedDifficulty == 2 ? Colors.blue : Colors.grey[300],
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Center(
                    child: Text(
                      S.current.hard,
                      style: TextStyle(
                        color: selectedDifficulty == 2 ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDifficulty = 3;
                  });
                },
                child: Container(
                  width: 80,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: selectedDifficulty == 3 ? Colors.blue : Colors.grey[300],
                    border: Border.all(color: Colors.grey),
                    borderRadius: const BorderRadius.horizontal(right: Radius.circular(10)),
                  ),
                  child: Center(
                    child: Text(
                      S.current.custom,
                      style: TextStyle(
                        color: selectedDifficulty == 3 ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              )
            ]
          ),
          const SizedBox(height: 20),
          if(selectedDifficulty != 3) ... [
            Text(
              selectedDifficulty == 0 ? S.current.easyInfo : selectedDifficulty == 1 ? S.current.normalInfo : S.current.hardInfo,
              style: const TextStyle(fontSize: 18),
              softWrap: true,
            ),
            ElevatedButton(onPressed: (){
              Navigator.pushNamed(context, 
              '/SinglePlayerGame',
              arguments: {
                "id": playlistId,
                "title": playlistTitle,
                "description": description,
                "difficulty": selectedDifficulty
              }
              );
            }, child: Text(S.current.start))
          ] else ... [
            //blahblah
          ],
        ],
      ),
    );
  }

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
        description = args["description"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${S.current.singlePlayerOptions}: $playlistTitle")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: MediaQuery.of(context).size.width > 800 ? _largeScreen() : _smallScreen(),
      ),
    );
  }
}


//SinglePlayerGame   终于到游戏啦！！！！ ---------------------------------------------------------------------
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

  //计时
  int _countdown = 0; 
  bool _canShowQuiz = false;

  Map _quizzes = {};

  String? _selectedOption; //选项

  //歌曲播放准备
  final _audioPlayer = AudioPlayer();
  int _played = 0;
  int _timeForPlaying = 0;  
  bool _prepareFinished = false;

  Logger logger = Logger(); //日志

  bool _loadTooSlow = false;

  Future<void> _prepareAudio() async {
    logger.i("preparing audio");
    try{
      int id = _quizzes[_played.toString()]['music_id'] ?? _quizzes[_played.toString()]['id'];
      logger.i("start preparing $id");
      await _audioPlayer.setSourceUrl("http://hungryhenry.xyz/musiclab/music/$id.mp3").timeout(const Duration(seconds: 10));
      await _audioPlayer.seek(Duration(minutes: 1, seconds: 0)); // 跳到 startAt
      _prepareFinished = true;
      logger.i("prepare finished $id");
      if(_loadTooSlow){
        setState(() {
          _loadTooSlow = false;
        });
        _resumeAndDelayAndStop();
      }
    }catch(e){
      if(e is TimeoutException && mounted){
        logger.log(Level.error, "prepare audio timeout: $e");
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
  void _startCountdown() {
    logger.i("starting countdown");
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
        print(_quizzes);
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

  Future<void> _resumeAndDelayAndStop() async{
    logger.i("call on function _resumeAndDelayAndStop");
    if(_audioPlayer.state == PlayerState.disposed){
      logger.i("disposed");
      return;
    }

    if(_prepareFinished){
      _played++;
      await _audioPlayer.resume();
      logger.i("played");

      if(_audioPlayer.state == PlayerState.playing){
        await Future.delayed(Duration(seconds: _timeForPlaying), () {
          _audioPlayer.pause(); 
        });
      }
      logger.i("paused");
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
      width: MediaQuery.of(context).size.width > 800 ? MediaQuery.of(context).size.width * 0.7 - 350 : MediaQuery.of(context).size.width * 0.8,
      child: Column(
        children: [
          Text(question, style: const TextStyle(fontSize: 20)),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8, maxHeight: 220),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: options.length,
              itemBuilder: (context, index) {
                return ListTile(
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
                );
              },
            ),
          ),
          ElevatedButton(onPressed: (){
            _audioPlayer.stop();
            logger.i("stop");
            if(answer == _selectedOption){
              if(_currentQuiz == _quizzes.length - 1){
                //show result
              }else{
                _startCountdown();
              }
            }else{
              logger.i("wrong");
            }
          }, child:Text(S.current.submit))
        ],
      ),
    );
  }

  Widget _largeScreen(){
    return Row(
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
              ]
            ],
          ),
        )
      ],
    );
  }

  Widget _smallScreen(){
    return SingleChildScrollView(
      child: Column(
        children: [
          _playlistId == 0 ? const Center(child: CircularProgressIndicator()) : 
          Image.network("http://hungryhenry.xyz/musiclab/playlist/$_playlistId.jpg", 
            width: MediaQuery.of(context).size.width < MediaQuery.of(context).size.height * 0.3 ? 
              MediaQuery.of(context).size.width :
              MediaQuery.of(context).size.height * 0.4,
          ),
          const SizedBox(height: 10),
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
              ]
            ],
          )
        ],
      ),
    );
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
        if(_audioPlayer.state == PlayerState.disposed){
          Navigator.of(context).popAndPushNamed('/SinglePlayerGame', arguments: args);
        }

        //获取题目
        _getQuiz(_playlistId, _difficulty);

        //难度对应时间
        switch (_difficulty) {
          case 0:
            _timeForPlaying = 6;
            break;
          case 1:
            _timeForPlaying = 4;
            break;
          case 2:
            _timeForPlaying = 2;
            break;
          default:
            _timeForPlaying = 0;
        }
      });
      _audioPlayer.onLog.listen(
        (String message) => logger.log(Level.info,message),
        onError: (Object e, [StackTrace? stackTrace]) => logger.log(Level.error, stackTrace),
      );
    }

  @override
  void dispose() { //释放资源内存
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      if (_quizzes.isNotEmpty && _currentQuiz == -1 && _countdown == 0) {
        _startCountdown();
      }
      if(_played == _currentQuiz && _currentQuiz != -1 && _countdown == 0) {
        _resumeAndDelayAndStop();
      }
    return Scaffold(
      appBar: AppBar(
        title: Text("${S.current.singlePlayerGame}: $_playlistTitle"), 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: MediaQuery.of(context).size.width > 800 ? _largeScreen() : _smallScreen(),
      )
    );
  }
}
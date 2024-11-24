import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import '/generated/l10n.dart';
import 'package:http/http.dart' as http;

import 'package:audioplayers/audioplayers.dart';

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
  String musicTitle = '';
  String artist = '';
  int musicCount = 0;
  String? description;

  int selectedDifficulty = 0;

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
      appBar: AppBar(title: Text("${S.current.singlePlayerOptions}: $playlistTitle")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
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
                // Song Info
                Text(
                  S.current.contains( musicCount, musicTitle, artist),
                  style: const TextStyle(fontSize: 14),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                    'SinglePlayerGame',
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
        ),
      ),
    );
  }
}


//SinglePlayerGame   终于到游戏啦！！！！
class SinglePlayerGame extends StatefulWidget {
  const SinglePlayerGame({super.key});

  @override
  State<SinglePlayerGame> createState() => _SinglePlayerGameState();
}

class _SinglePlayerGameState extends State<SinglePlayerGame> {
  //数据传入存储
  int playlistId = 0;
  String playlistTitle = '';
  String? description;
  int difficulty = 4;

  int currentQuiz = -1; //题目计数器

  //计时
  int _countdown = 0; 
  bool _isButtonVisible = true;
  Map quizzes = {};

  //音乐播放准备
  late AudioPlayer _audioPlayer;

  //选项
  String? _selectedOption;

  void _startCountdown() {
    setState(() {
      _countdown = 3; // 初始化倒计时
      _isButtonVisible = false; // 隐藏按钮
    });

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_countdown > 1) {
        setState(() {
          _countdown--; // 每秒减少1
        });
      } else {
        timer.cancel(); // 停止计时器
        setState(() {
          _countdown = 0;
          currentQuiz = ++currentQuiz;
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
          quizzes = jsonDecode(response.body);
        });
        print(quizzes);
      } else {
        print("error");
        print(response.body);
      }
    } catch (e) {
      if(e is TimeoutException) {
        await showDialog(context: context, builder: (context){
          return AlertDialog(
              content: Text(S.current.connectError),
              actions: [
                  TextButton(onPressed: () { 
                    Navigator.of(context).pop();
                  }, child: Text(S.current.back)),
                  TextButton(onPressed: (){
                    Navigator.of(context).popAndPushNamed("SinglePlayerGame", arguments: {playlistId, playlistTitle, description, difficulty});
                  }, child: Text(S.current.retry))
              ],
          );
        });
      }
    }
  }

  void _playAudioFromPosition(String audioUrl, Duration startAt, int timeForPlaying) async {
    await _audioPlayer.setSourceUrl(audioUrl); // 加载音频
    await _audioPlayer.seek(startAt); // 跳到 startAt
    _audioPlayer.resume(); // 开始播放

    // 延迟 timeForPlaying 秒后暂停
    Future.delayed(Duration(seconds: timeForPlaying), () {
      _audioPlayer.pause(); 
    });
  }

  Widget _showQuiz(Map quizInfo, int difficulty){
    int timeForPlaying = 0;
    switch (difficulty) {
      case 0:
        timeForPlaying = 6;
        break;
      case 1:
        timeForPlaying = 4;
        break;
      case 2:
        timeForPlaying = 2;
        break;
      default:
        timeForPlaying = 0;
    }

    print(quizInfo['id']);
    print(quizInfo['ext']);
    String audioUrl = "http://hungryhenry.xyz/musiclab/music/" + quizInfo['id'].toString() + "." + quizInfo['ext'];
    String answer = quizInfo['answer'];
    List options = quizInfo["options"];
    _playAudioFromPosition(audioUrl, Duration(minutes: 1, seconds: 20), timeForPlaying);
    return Column(
      children: [
        Text(answer),

        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 300, maxHeight: 300),
          child: ListView.builder(
            itemCount: options.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(options[index]['title']!),
                leading: Radio<String>(
                  value: options[index]['title']!,
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
        )
      ],
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
          description = args["description"];
          difficulty = args["difficulty"];
        });
        _getQuiz(playlistId, difficulty);
        _audioPlayer = AudioPlayer();
      });
    }

  @override
  void dispose() { //释放资源内存
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${S.current.singlePlayerGame}: $playlistTitle"), 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                playlistId == 0 ? const Center(child: CircularProgressIndicator()) : 
                Image.network("http://hungryhenry.xyz/musiclab/playlist/${playlistId}.jpg", width:350, height:350),
                const SizedBox(height: 20),
                Text(description ?? "No description", style: const TextStyle(fontSize: 18), softWrap: true),
                const SizedBox(height: 20),
                Text(difficulty == 0 ? S.current.easy : difficulty == 1 ? S.current.normal : difficulty == 2 ? S.current.hard : S.current.custom, style: const TextStyle(fontSize: 18), softWrap: true),
              ],
            ),
            Column(
              children: [
                quizzes.isEmpty ? const CircularProgressIndicator() : //加载
                _isButtonVisible ? ElevatedButton(onPressed:(){_startCountdown();}, child: Text(S.current.start)) : //开始按钮
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
                if (currentQuiz != -1 && _countdown == 0) ... [_showQuiz(quizzes[currentQuiz.toString()], difficulty)]
              ],
            )
          ],
        )
      )
    );
  }
}
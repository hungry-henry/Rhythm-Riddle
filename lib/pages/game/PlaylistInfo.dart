import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

class PlaylistInfo extends StatefulWidget {
  @override
  _PlaylistInfoState createState() => _PlaylistInfoState();
}

class _PlaylistInfoState extends State<PlaylistInfo> {
  int playlistId = 0;
  bool isLoading = true;

  //用户登录信息
  String? uid = '';
  String? username = '';
  String? mail = '';
  String? date = '';
  DateTime now = DateTime.now();
  bool isLogin = false;

  String title = '';
  String createTime = '';
  String createdBy = '';
  String musicTitle = '';
  String artist = '';
  String? description = '';
  int likes = 0;
  int played = 0;
  int musicCount = 0;

  void _checkLogin() async {
    uid = await storage.read(key: 'uid');
    username = await storage.read(key: 'username');
    mail = await storage.read(key: 'mail');
    date = await storage.read(key: 'date');
    if (uid != null && username != null && mail != null && now.difference(DateTime.parse(date!)).inDays < 7 && mounted) {
      setState(() {
        isLogin = true;
      });
    }
  }

  Future<void> _getFromApi() async {
    try{
      final response = await http.post(
        Uri.parse('http://hungryhenry.xyz/api/getPlaylistInfo.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, int>{
          'id': playlistId
        })
      ).timeout(const Duration(seconds:7));

      print(response.body);
      if(response.statusCode == 200 && mounted){
        setState(() {
          title = jsonDecode(response.body)['data']['playlist_title'];
          createTime = jsonDecode(response.body)['data']['create_time'];
          createdBy = jsonDecode(response.body)['data']['created_by'];
          musicTitle = jsonDecode(response.body)['data']['music_title'];
          artist = jsonDecode(response.body)['data']['artist'];
          description = jsonDecode(response.body)['data']['description'];
          likes = jsonDecode(response.body)['data']['likes'];
          played = jsonDecode(response.body)['data']['played'];
          musicCount = jsonDecode(response.body)['data']['music_count'];
          isLoading = false;
        });
      }else if(response.statusCode == 404 && mounted){
        await showDialog(context: context, builder: (context){
          return AlertDialog(
              content: Text(S.current.bug),
              actions: [
                  TextButton(onPressed: () { Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => route == null);
}, child: Text(S.current.ok)),
              ],
          );
        });
        setState(() {
          isLoading = false;
        });
      }else{
        if(mounted){
          await showDialog(context: context, builder: (context){
            return AlertDialog(
                content: Text(S.current.unknownError),
                actions: [
                    TextButton(onPressed: () { Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => route == null);
}, child: Text(S.current.ok)),
                ],
            );
          });
          setState(() {
            isLoading = false;
          });
        }
      }
    }catch(e){
      if(mounted){
        if(e is TimeoutException){
          await showDialog(context: context, builder: (context){
            return AlertDialog(
                content: Text(S.current.connectError),
                actions: [
                    TextButton(onPressed: () { Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => route == null);
}, child: Text(S.current.ok)),
                ],
            );
          });
        }else{
          await showDialog(context: context, builder: (context){
            return AlertDialog(
                content: Text(S.current.bug),
                actions: [
                    TextButton(onPressed: () { Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => route == null);
}, child: Text(S.current.ok)),
                ],
            );
          });
        }
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _checkLogin();
    Future.microtask(() {
      final int args = ModalRoute.of(context)?.settings.arguments as int;
      setState(() {
        playlistId = args;
      });
      _getFromApi();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text(title)),
      body: isLoading ? const Center(child: CircularProgressIndicator()) : LayoutBuilder(
        builder: (context, constraints){
          bool isSmallScreen = constraints.maxWidth < 600;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: isSmallScreen ? _buildSmallScreenLayout() : _buildLargeScreenLayout()
          );
        }
      )
    );
  }

  Widget _buildSmallScreenLayout() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: Column(
              children: [
                Image.network(
                  "http://hungryhenry.xyz/musiclab/playlist/$playlistId.jpg",
                  width: MediaQuery.of(context).size.width < MediaQuery.of(context).size.height * 0.3 ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.height * 0.4,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(createdBy),
                    const SizedBox(width: 25),
                    const Text("|"),
                    const SizedBox(width: 25),
                    Text(createTime)
                  ]
                )
              ]
            ),
          ),
          _buildInfoRow(),
          Text(S.current.contains(musicTitle, artist)),
          Row(
            mainAxisAlignment:MainAxisAlignment.center,
            children: [ElevatedButton(onPressed: (){
              Navigator.of(context).pushNamed(
                "SinglePlayer", 
                arguments: {
                  "id": playlistId,
                  "title": title, 
                  "musicTitle": musicTitle, 
                  "artist": artist, 
                  "createdBy": createdBy, 
                  "createTime": createTime,
                  "description": description,
                  "count": musicCount
                }
              );
            }, child: Text(S.current.singlePlayer)),
            const SizedBox(width:50),
            if(isLogin)...[
              ElevatedButton(
                onPressed: (){
                  Navigator.of(context).pushNamed(
                    "MultiPlayer", 
                    arguments: {
                      "id": playlistId,
                      "title": title, 
                      "musicTitle": musicTitle, 
                      "artist": artist, 
                      "createdBy": createdBy, 
                      "createTime": createTime,
                      "description": description,
                      "count": musicCount
                    }
                  );
                }, child: Text(S.current.multiPlayer)
              )
            ] else...[
              TextButton(
                onPressed:null,
                style:ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.grey[350]),
                  padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 25, vertical: 10)),
                ), 
                child:Text(S.current.multiPlayer)
              )
            ]]
          ),
          const SizedBox(height: 30)
        ],
      )
    );
  }

  // 大屏设备布局
  Widget _buildLargeScreenLayout() {
    return Center(  // 将整个布局居中
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,  // 水平方向居中对齐
        crossAxisAlignment: CrossAxisAlignment.center, // 垂直方向居中对齐
        children: [
          // 封面图片
          Padding(
            padding: EdgeInsets.only(left:MediaQuery.of(context).size.width * 0.1 - 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                    "http://hungryhenry.xyz/musiclab/playlist/$playlistId.jpg",
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                ),
                const SizedBox(height: 10),
                Text("创作者: $createdBy", style: const TextStyle(fontSize: 16)),
                Text("创作时间: $createTime", style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
          const SizedBox(width: 30),
          // 标题和信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center, // 让标题和信息在列中垂直居中
              children: [
                Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                _buildInfoRow(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Text(S.current.contains(musicTitle, artist)),
                SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(onPressed: (){
                      Navigator.of(context).pushNamed(
                        "SinglePlayer", 
                        arguments: {
                          "id": playlistId,
                          "title": title, 
                          "musicTitle": musicTitle, 
                          "artist": artist, 
                          "createdBy": createdBy, 
                          "createTime": createTime,
                          "description": description,
                          "count": musicCount
                        }
                      );
                    }, child: Text(S.current.singlePlayer)),
                    SizedBox(width:MediaQuery.of(context).size.width * 0.045),
                    if(isLogin)...[
                      ElevatedButton(
                        onPressed: (){
                          Navigator.of(context).pushNamed(
                            "MultiPlayer", 
                            arguments: {
                              "id": playlistId,
                              "title": title, 
                              "musicTitle": musicTitle, 
                              "artist": artist, 
                              "createdBy": createdBy, 
                              "createTime": createTime,
                              "description": description,
                              "count": musicCount
                            }
                          );
                        }, child: Text(S.current.multiPlayer)
                      )
                    ] else...[
                      TextButton(
                        onPressed:null,
                        style:ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Colors.grey[350]),
                          padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 25, vertical: 10)),
                        ),
                        child:Text(S.current.multiPlayer)
                      )
                    ]
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildInfoRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // 歌曲数量
        Column(
          children: [
            Icon(Icons.music_note, color: Colors.blue),
            SizedBox(height: 8),
            Text(
              musicCount.toString(),
              style: TextStyle(fontSize: 16),
            ),
            Text(S.current.songs),
          ],
        ),
        // 游玩数量
        Column(
          children: [
            Icon(Icons.sports_esports, color: Colors.green),
            SizedBox(height: 8),
            Text(
              played.toString(),
              style: const TextStyle(fontSize: 16),
            ),
            Text(S.current.played),
          ],
        ),
        // 点赞数量
        Column(
          children: [
            const Icon(Icons.thumb_up, color: Colors.red),
            const SizedBox(height: 8),
            Text(
              likes.toString(),
              style: const TextStyle(fontSize: 16),
            ),
            Text(S.current.likes),
          ],
        ),
      ],
    );
  }
}
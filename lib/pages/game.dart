import 'dart:convert';

import 'package:flutter/material.dart';
import '../generated/l10n.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

class Game extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  int playlistId = 0;
  bool isLoading = true;

  //用户登录信息
  String? uid = '';
  String? username = '';
  String? mail = '';
  bool isLogin = false;

  String title = '';
  String createTime = '';
  String createdBy = '';
  String musicTitle = '';
  String artist = '';

  void _checkLogin() async {
    uid = await storage.read(key: 'uid');
    username = await storage.read(key: 'username');
    mail = await storage.read(key: 'mail');
    if (uid != null && username != null && mail != null && mounted) {
      setState(() {
        isLogin = true;
      });
    }
  }
  
  void showDialogFunction(String title) async {
    await showDialog(context: context, builder: (context){
      return AlertDialog(
          content: Text(title),
          actions: [
              TextButton(onPressed: () {Navigator.of(context).pop(false);}, child: Text(S.current.ok)),
          ],
      );
    });
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
          isLoading = false;
        });
      }else if(response.statusCode == 404 && mounted){
        showDialogFunction(S.current.bug);
        setState(() {
          isLoading = false;
        });
      }else{
        showDialogFunction(S.current.unknownError);
        if(mounted){
          setState(() {
            isLoading = false;
          });
        }
      }
    }catch(e){
      showDialogFunction(S.current.connectError);
      if(mounted) {
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: Column(
              children: [
                Image.network(
                  "http://hungryhenry.xyz/musiclab/playlist/$playlistId.jpg",
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]
            ),
          ),
          _buildInfoRow(),
          Row(
            mainAxisAlignment:MainAxisAlignment.center,
            children: [ElevatedButton(onPressed: (){}, child: Text(S.current.singlePlayer)),
            const SizedBox(width:50),
            ElevatedButton(onPressed: (){}, child: Text(S.current.multiPlayer))]
          )
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
            child: Image.network(
              "http://hungryhenry.xyz/musiclab/playlist/$playlistId.jpg",
              width: 300,
              height: 300,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 30),
          // 标题和信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center, // 让标题和信息在列中垂直居中
              children: [
                Center( // 让标题居中
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                _buildInfoRow(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.13),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(onPressed: (){}, child: Text(S.current.singlePlayer)),
                    SizedBox(width:MediaQuery.of(context).size.width * 0.045),
                    ElevatedButton(onPressed: (){}, child: Text(S.current.multiPlayer)),
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
              '5',
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
              '100',
              style: TextStyle(fontSize: 16),
            ),
            Text(S.current.played),
          ],
        ),
        // 点赞数量
        Column(
          children: [
            Icon(Icons.thumb_up, color: Colors.red),
            SizedBox(height: 8),
            Text(
              '32',
              style: TextStyle(fontSize: 16),
            ),
            Text(S.current.likes),
          ],
        ),
      ],
    );
  }
}
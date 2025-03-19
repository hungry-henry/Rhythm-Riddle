import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../generated/l10n.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PlaylistInfo extends StatefulWidget {
  @override
  _PlaylistInfoState createState() => _PlaylistInfoState();
}

class _PlaylistInfoState extends State<PlaylistInfo> {
  int playlistId = 0;
  bool isLoading = true;

  String title = '';
  String createTime = '';
  String createdBy = '';
  String musicTitle = '';
  String artist = '';
  String? description = '';
  int likes = 0;
  int played = 0;
  int musicCount = 0;

  late String _documentsDirectory;

  String downloadText = '';
  int downloadProgress = 0;
  CancelToken cancelToken = CancelToken();

  Future<bool> _checkPermission() async {
    if(Platform.isAndroid){
      final status = await Permission.storage.status;
      if(status.isGranted){
        return true;
      }else{
        final permission = await Permission.storage.request();
        if(permission.isGranted){
          return true;
        }else{
          return false;
        }
      }
    }else{
      return true;
    }
  }

  Future<void> _downloadPlaylist() async {
    if(!await _checkPermission()){
      Fluttertoast.showToast(msg: S.current.permissionError(S.current.storagePerm));
      return;
    }else{
      Dio dio = Dio();
      final String url = 'http://hungryhenry.xyz/musiclab/playlist/$playlistId.zip';
      final String saveDir = _documentsDirectory + '/playlists/$playlistId.zip';
      try{
        await dio.download(
          url, saveDir, cancelToken: cancelToken,
          onReceiveProgress: (count, total) {
            if(mounted){
              setState(() {
                downloadProgress = 100 * count ~/ total;
              });
            }
          },
        );
        DateTime now = DateTime.now();
        final String date = DateFormat('yyyy-MM-dd').format(now);
        final File jsonFile = File(_documentsDirectory + '/local_playlists.json');
        if(!jsonFile.existsSync()){
          jsonFile.createSync();
          jsonFile.writeAsStringSync('[]');
        }
        final List localPlaylists = json.decode(jsonFile.readAsStringSync());
        localPlaylists.add({
          "id": playlistId,
          "title": title,
          "date": date,
          "count": musicCount,
        });
        jsonFile.writeAsStringSync(json.encode(localPlaylists));
        setState(() {
          downloadText = S.current.downloaded;
        });
      }catch(e){
        if(e is TimeoutException){
          await showDialog(context: context, builder: (context){
            return AlertDialog(
                content: Text(S.current.connectError),
                actions: [
                  TextButton(onPressed: () { Navigator.of(context).pop();}, child: Text("OK"))
                ],
            );
          });
        }else{
          print(e);
        }
      }
    }
  }

  Future<void> _getFromApi() async {
    final Dio dio = Dio();
    try{
      final response = await dio.post(
        'http://hungryhenry.xyz/api/getPlaylistInfo.php',
        data: {'id': playlistId},
        options: Options(
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
      ).timeout(const Duration(seconds: 7));

      if(response.statusCode == 200 && mounted){
        setState(() {
          title = response.data['data']['playlist_title'];
          createTime = response.data['data']['create_time'];
          createdBy = response.data['data']['created_by'];
          musicTitle = response.data['data']['music_title'];
          artist = response.data['data']['artist'];
          description = response.data['data']['description'];
          likes = response.data['data']['likes'];
          played = response.data['data']['played'];
          musicCount = response.data['data']['music_count'];
          isLoading = false;
        });
      }else if(response.statusCode == 404 && mounted){
        await showDialog(context: context, builder: (context){
          return AlertDialog(
              content: Text(S.current.bug),
              actions: [
                TextButton(onPressed: () { 
                  Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
                }, child: Text(S.current.ok)),
              ],
          );
        });
        setState(() {
          isLoading = false;
        });
      }else{
        print(response.data);
        if(mounted){
          await showDialog(context: context, builder: (context){
            return AlertDialog(
                content: Text(S.current.unknownError),
                actions: [
                  TextButton(onPressed: () { 
                    Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
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
      print(e);
      if(mounted){
        if(e is TimeoutException){
          await showDialog(context: context, builder: (context){
            return AlertDialog(
                content: Text(S.current.connectError),
                actions: [
                    TextButton(onPressed: () { Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
}, child: Text(S.current.ok)),
                ],
            );
          });
        }else{
          await showDialog(context: context, builder: (context){
            return AlertDialog(
                content: Text(S.current.bug),
                actions: [
                    TextButton(onPressed: () { Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
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
    Future.microtask(() {
      final int args = ModalRoute.of(context)?.settings.arguments as int;
      setState(() {
        playlistId = args;
      });
      getApplicationDocumentsDirectory().then((dir) {
        _documentsDirectory = dir.path + '/rhythm_riddle';
        final File path = File(_documentsDirectory + '/playlists/$playlistId.zip');
        if(path.existsSync()){
          setState(() {
            downloadText = S.current.downloaded;
          });
        }else{
          setState(() {
            downloadText = S.current.download;
          });
        }
      });
      _getFromApi();
    });
  }

  Widget _buildSmallScreenLayout() {
    return Column(
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
        Text(S.current.contains(musicTitle, artist, musicCount)),
        Row(
          mainAxisAlignment:MainAxisAlignment.center,
          children: [ElevatedButton(onPressed: (){
            Navigator.of(context).pushNamed(
              '/SinglePlayer', 
              arguments: {
                "id": playlistId,
                "title": title, 
                "createdBy": createdBy, 
                "createTime": createTime,
                "description": description,
              }
            );
          }, child: Text(S.current.singlePlayer)),
            const SizedBox(width:50),
            /*if(isLogin)...[
              ElevatedButton(
                onPressed: (){
                  Navigator.of(context).pushNamed(
                    "/MultiPlayer", 
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
            ] else...[*/
              TextButton(
                onPressed:null,
                style:ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Theme.of(context).primaryColorLight),
                  padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 25, vertical: 10)),
                ), 
                child:Text(S.current.multiPlayer)
              )
            //]
          ]
        ),
        const SizedBox(height: 30)
      ],
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
                Text("${S.current.creator}: $createdBy", style: const TextStyle(fontSize: 16)),
                Text("${S.current.createTime}: $createTime", style: const TextStyle(fontSize: 16)),
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
                Text(S.current.contains(musicTitle, artist, musicCount)),
                SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(onPressed: (){
                      Navigator.of(context).pushNamed(
                        '/SinglePlayer', 
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
                    /*if(isLogin)...[
                      ElevatedButton(
                        onPressed: (){
                          Navigator.of(context).pushNamed(
                            "/MultiPlayer", 
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
                    ] else...[*/
                      TextButton(
                        onPressed:null,
                        style:ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Theme.of(context).primaryColorLight),
                          padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 25, vertical: 10)),
                        ),
                        child:Text(S.current.multiPlayer)
                      )
                    //]
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
            const Icon(Icons.music_note, color: Colors.blue),
            const SizedBox(height: 8),
            Text(
              musicCount.toString(),
              style: const TextStyle(fontSize: 16),
            ),
            Text(S.current.songs),
          ],
        ),
        // 游玩数量
        Column(
          children: [
            const Icon(Icons.sports_esports, color: Colors.green),
            const SizedBox(height: 8),
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
        Column(
          children: [
            IconButton(
              icon: const Icon(Icons.download),
              color: downloadText == S.current.downloaded ? Colors.orange : Colors.grey,
              onPressed: () {
                if(downloadText == S.current.download) {
                  setState(() {
                    downloadText = S.current.downloading("");
                  });
                  _downloadPlaylist();
                }else if(downloadText == S.current.downloading("")){
                  cancelToken.cancel();
                  setState(() {
                    downloadText = S.current.downloaded;
                    downloadProgress = 0;
                  });
                }else if(downloadText == S.current.downloaded){
                  Navigator.pushNamed(context, "/localPlaylists");
                }
              }
            ),
            const SizedBox(height: 8),
            if(downloadProgress > 0) ...[
              Text(
              downloadProgress.toString() + "%",
              style: const TextStyle(fontSize: 16),
            )],
            Text(downloadText)
          ]
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: isLoading ? const Center(child: CircularProgressIndicator()) : LayoutBuilder(
        builder: (context, constraints){
          bool isSmallScreen = constraints.maxWidth < 800;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: isSmallScreen ? _buildSmallScreenLayout() : _buildLargeScreenLayout()
          );
        }
      )
    );
  }
}
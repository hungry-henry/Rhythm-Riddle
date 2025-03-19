import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
class LocalPlaylistsPage extends StatefulWidget {
  @override
  _LocalPlaylistsPageState createState() => _LocalPlaylistsPageState();
}

class _LocalPlaylistsPageState extends State<LocalPlaylistsPage> {
  late Directory _documentsDirectory;
  late File _localPlaylistsJson;
  List? _localPlaylists;
  
  @override 
  void initState() {
    super.initState();
    getApplicationDocumentsDirectory().then((directory) {
      _documentsDirectory = Directory(directory.path + '/rhythm_riddle');
      _localPlaylistsJson = File('${_documentsDirectory.path}/local_playlists.json');
      if(!_documentsDirectory.existsSync()){
        _documentsDirectory.createSync();
      }
      if (_localPlaylistsJson.existsSync()) {
        _localPlaylistsJson.readAsString().then((jsonString) {
          setState(() {
            _localPlaylists = json.decode(jsonString);
          });
        }); 
      } else {
        _localPlaylistsJson.createSync();
        setState(() {
          _localPlaylists = [];
        });
        _localPlaylistsJson.writeAsStringSync(json.encode([]));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Local Playlists'),
      ),
      body: _localPlaylists == null? Center(child: CircularProgressIndicator()) :
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: _localPlaylists!.isEmpty ? Center(child: Text('暂无歌单，去你喜欢的歌单下载吧')) : ListView.builder(
          itemCount: _localPlaylists!.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onLongPress: (){
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('删除歌单'),
                      content: Text('确定要删除${_localPlaylists![index]['title']}吗？'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('取消'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('删除'),
                        ),
                      ],
                    );
                  },
                );
              },
              onTap: (){
                //难度选择提示框
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('选择歌曲难度'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('取消', style: TextStyle(color: Colors.grey)),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil("/OfflineGame", (route) => false, arguments: {"id": _localPlaylists![index]['id'], "difficulty": 0});
                          },
                          child: Text('简单'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil("/OfflineGame", (route) => false, arguments: {"id": _localPlaylists![index]['id'], "difficulty": 1});
                          },
                          child: Text('中等'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil("/OfflineGame", (route) => false, arguments: {"id": _localPlaylists![index]['id'], "difficulty": 2});
                          },
                          child: Text('困难'),
                        ),
                      ],
                    );
                  }
                );
              },
              child: ListTile(
                leading: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(File("${_documentsDirectory.path}/img/${_localPlaylists![index]['id']}.jpg")),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  )
                ),
                title: Text(_localPlaylists![index]['title']),
                subtitle: Text(_localPlaylists![index]['count'].toString() + "首歌曲"),
              )
            );
          }
        )
      )
    );
  }
}
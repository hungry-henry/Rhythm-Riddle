import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:archive/archive.dart';
import 'package:path/path.dart' as path;
import 'package:just_audio/just_audio.dart';


Future<Map<String, dynamic>> chooseMusic(List index, int difficulty, Directory tempDir, List musicOptions) async{
  int key = Random().nextInt(index.length);
  int musicId = index[key]['music_id'];
  String musicTitle = index[key]['music_title'];
  String artists = index[key]['artist'];

  ///选项
  if(RegExp(r'[\u4e00-\u9fff]').hasMatch(musicTitle)){
    //有中文
    musicOptions = musicOptions.where((item)=>RegExp(r'[\u4e00-\u9fff]').hasMatch(item)).toList();
  }else{
    //无中文
    musicOptions = musicOptions.where((item)=>!RegExp(r'[\u4e00-\u9fff]').hasMatch(item)).toList();
  }

  //随机选择3首歌曲
  List<String> options = [];
  while(options.length < 3){
    int randomKey = Random().nextInt(musicOptions.length);
    if(!options.contains(musicOptions[randomKey])){
      options.add(musicOptions[randomKey]);
    }
  }
  options.add(musicTitle);
  options.shuffle();

  //获取音乐时长
  final audio = AudioPlayer();
  await audio.setFilePath("${tempDir.path}/music/$musicId.mp3");
  final duration = audio.duration;
  audio.dispose();

  int startAt = Random().nextInt(duration!.inSeconds - 10);
  
  int answerTime = 0;
  int musicPlayingTime = 0;
  switch (difficulty) {
    case 0:
      answerTime = 15;
      musicPlayingTime = 6;
      break;
    case 2:
      answerTime = 12;
      musicPlayingTime = 5;
      break;
    case 3:
      answerTime = 8;
      musicPlayingTime = 4;
      break;
    default:
      answerTime = 15;
      musicPlayingTime = 6;
      break;
  }

  return {
    "quizType": 0,
    "id": musicId,
    "answer": musicTitle,
    "artists": artists,
    "start_at": startAt,
    "answer_time": answerTime,
    "music_playing_time": musicPlayingTime,
    "options": options
  };
}

Future<Map<String, dynamic>> chooseArtist(List index, int difficulty, Directory tempDir, List artistOptions) async{
  int key = Random().nextInt(index.length);
  String artist = index[key]['artist'];
  int musicId = index[key]['music_id'];
  String music = index[key]['music_title'];
  late int artistId;

  //多个歌手？
  if(artist.contains(", ")){
    List artistList = artist.split(", ");
    int artistKey = Random().nextInt(artistList.length);
    artist = artistList[artistKey];
    artistId = index[key]['artist_id'].split(", ")[artistKey];
  }else{
    artistId = int.parse(index[key]['artist_id']);
  }

  //含中文？
  if(RegExp(r'[\u4e00-\u9fff]').hasMatch(artist)){
    artistOptions = artistOptions.where((item)=>RegExp(r'[\u4e00-\u9fff]').hasMatch(item)).toList();
  }else{
    artistOptions = artistOptions.where((item)=>!RegExp(r'[\u4e00-\u9fff]').hasMatch(item)).toList();
  }

  //随机选择3个歌手
  List<String> options = [];
  while(options.length < 3){
    int randomKey = Random().nextInt(artistOptions.length);
    if(!options.contains(artistOptions[randomKey])){
      options.add(artistOptions[randomKey]);
    }
  }
  options.add(artist);
  options.shuffle();

  //获取音乐时长
  final audio = AudioPlayer();
  await audio.setFilePath("${tempDir.path}/music/$musicId.mp3");
  final duration = audio.duration;
  audio.dispose();
  int startAt = Random().nextInt(duration!.inSeconds - 10);

  int answerTime = 0;
  int musicPlayingTime = 0;
  switch (difficulty) {
    case 0:
      answerTime = 15;
      musicPlayingTime = 6;
      break;
    case 2:
      answerTime = 12;
      musicPlayingTime = 5;
      break;
    case 3:
      answerTime = 8;
      musicPlayingTime = 4;
      break;
    default:
      answerTime = 15;
      musicPlayingTime = 6;
      break;
  }
  return {
    "quizType": 1,
    "id": artistId,
    "answer": artist,
    "music_id": musicId,
    "music": music,
    "start_at": startAt,
    "answer_time": answerTime,
    "music_playing_time": musicPlayingTime,
    "options": options
  };
}

Future<Map<String, dynamic>> getQuiz(int playlistId, int difficulty, Directory tempDir) async {
  Directory documentsDirectory = Directory((await getApplicationDocumentsDirectory()).path + "/rhythm_riddle");
  //读取options文件
  const optionsFile = "assets/offline_data.json";
  final Map optionsString = jsonDecode(await rootBundle.loadString(optionsFile));
  final List musicOptions = optionsString["music"];
  final List artistOptions = optionsString["artist"];
  final List albumOptions = optionsString["album"];
  final List genreOptions = optionsString["genre"];

  if(!documentsDirectory.existsSync()){
    documentsDirectory.create();
  }

  //解压zip文件到临时目录
  final zipFile = File("${documentsDirectory.path}/playlists/$playlistId.zip");
  if(!zipFile.existsSync()){
    return {"error": "playlist zip not found"};
  }
  final content = zipFile.readAsBytesSync();
  final archive = ZipDecoder().decodeBytes(content);
  for (final file in archive) {
    if (file.isFile) {
      final filePath = path.join(tempDir.path, file.name);
      final outputFile = File(filePath);
      await outputFile.create(recursive: true);
      await outputFile.writeAsBytes(file.content);
    }
  }

  //读取json文件
  final jsonFile = File("${tempDir.path}/index.json");
  final jsonString = await jsonFile.readAsString();
  List index = jsonDecode(jsonString);

  switch (difficulty) {
    case 0:
      Map<String, dynamic> quiz1 = await chooseMusic(index, difficulty, tempDir, musicOptions);
      index.removeWhere((item)=>item['music_id'] == quiz1['id']);
      Map<String, dynamic> quiz2 = await chooseArtist(index, difficulty, tempDir, artistOptions);
      index.removeWhere((item)=>item['music_id'] == quiz2['music_id']);
      return {
        "0": quiz1,
        "1": quiz2
      };
    case 1:return{};
    case 2:return{};
    default:return{"error": "difficulty error"};
  }
}
import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive.dart';
import 'package:path/path.dart' as path;
import 'package:just_audio/just_audio.dart';

String? randomBlanks(String input, int replaceCount) {
  if (replaceCount == 0) {
    return null;
  }

  // 过滤掉空格和标点符号的字符
  String filtered = input.replaceAll(RegExp(r'[^\p{L}\p{N}]', unicode: true), '');
  int length = filtered.length;

  if (length == 0 || replaceCount <= 0) {
    return null; // 如果没有可替换字符或 n <= 0，返回空列表
  }

  // 如果 n 大于可替换字符数量，将 n 调整为最大值
  replaceCount = replaceCount < length ? replaceCount : length;

  // 获取字符串中需要替换的非空格字符的索引
  List<int> indexes = [];
  List<int> nonSpaceIndexes = []; // 存储非空格字符的索引

  for (int i = 0; i < input.length; i++) {
    // 仅存储非空格字符的索引
    if (RegExp(r'\p{L}|\p{N}', unicode: true).hasMatch(input[i])) {
      nonSpaceIndexes.add(i);
    }
  }

  // 从非空格字符的索引中随机选择需要替换的索引
  if (nonSpaceIndexes.isNotEmpty) {
    Random random = Random();
    indexes = List<int>.from(nonSpaceIndexes);
    indexes.shuffle(random);
    indexes = indexes.sublist(0, replaceCount);
  }

  //将需要替换的字符替换为下划线
  String result = input;
  for (int i = 0; i < indexes.length; i++) {
    result = result.replaceRange(indexes[i], indexes[i] + 1, '_');
  }

  return result;
}

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
    if(!options.contains(musicOptions[randomKey]) && musicOptions[randomKey] != musicTitle){
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
    "artist": artists,
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
  if(RegExp(r'[\u4e00-\u9fff]').hasMatch(artist) || artist == "BEYOND"){
    artistOptions = artistOptions.where((item)=>RegExp(r'[\u4e00-\u9fff]').hasMatch(item) || item == "BEYOND").toList();
  }else{
    artistOptions = artistOptions.where((item)=>!RegExp(r'[\u4e00-\u9fff]').hasMatch(item)).toList();
  }

  //随机选择3个歌手
  List<String> options = [];
  while(options.length < 3){
    int randomKey = Random().nextInt(artistOptions.length);
    if(!options.contains(artistOptions[randomKey]) && artistOptions[randomKey] != artist){
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

Future<Map<String, dynamic>> chooseAlbum(List index, int difficulty, Directory tempDir, List albumOptions) async{
  int key = Random().nextInt(index.length);
  int albumId = index[key]['album_id'];
  String albumTitle = index[key]['album_title'];
  String albumArtist = index[key]['album_artist_name'];
  String music = index[key]['music_title'];
  String artist = index[key]['artist'];
  int musicId = index[key]['music_id'];

  //含中文？
  if(RegExp(r'[\u4e00-\u9fff]').hasMatch(albumTitle)){
    albumOptions = albumOptions.where((item)=>RegExp(r'[\u4e00-\u9fff]').hasMatch(item)).toList();
  }else{
    albumOptions = albumOptions.where((item)=>!RegExp(r'[\u4e00-\u9fff]').hasMatch(item)).toList();
  }

  //随机选择3个专辑
  List<String> options = [];
  while(options.length < 3){
    int randomKey = Random().nextInt(albumOptions.length);
    if(!options.contains(albumOptions[randomKey]) && albumOptions[randomKey] != albumTitle){
      options.add(albumOptions[randomKey]);
    }
  }
  options.add(albumTitle);
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
    "quizType": 2,
    "id": albumId,
    "answer": albumTitle,
    "album_artist": albumArtist,
    "music_id": musicId,
    "music": music,
    "artist": artist,
    "start_at": startAt,
    "answer_time": answerTime,
    "music_playing_time": musicPlayingTime,
    "options": options
  };
}

Future<Map<String, dynamic>> chooseGenre(List index, int difficulty, Directory tempDir, List genreOptions) async{
  int key = Random().nextInt(index.length);
  String genre = index[key]['genre'];
  int musicId = index[key]['music_id'];
  String music = index[key]['music_title'];
  String artist = index[key]['artist'];

  if(genre.contains(", ")){
    List genreList = genre.split(", ");
    genreList.removeWhere((item)=>item == "华语" || item == "欧美");
    int genreKey = Random().nextInt(genreList.length);
    genre = genreList[genreKey];

    //从genreOptions中移除genreList
    genreOptions.removeWhere((item)=>genreList.contains(item));
  }else{
    genreOptions.removeWhere((item)=>item == genre);
  }

  //随机选择3个风格
  List<String> options = [];
  while(options.length < 3){
    int randomKey = Random().nextInt(genreOptions.length);
    if(!options.contains(genreOptions[randomKey]) && genreOptions[randomKey] != genre){
      options.add(genreOptions[randomKey]);
    }
  }
  options.add(genre);
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
      answerTime = 20;
      musicPlayingTime = 9;
      break;
    case 2:
      answerTime = 15;
      musicPlayingTime = 7;
      break;
    case 3:
      answerTime = 10;
      musicPlayingTime = 6;
      break;
    default:
      answerTime = 20;
      musicPlayingTime = 9;
      break;
  }
  return {
    "quizType": 3,
    "id": genre,
    "answer": genre,
    "music_id": musicId,
    "music": music,
    "artist": artist,
    "start_at": startAt,
    "answer_time": answerTime,
    "music_playing_time": musicPlayingTime,
    "options": options
  };
}

Future<Map<String, dynamic>> typeOutMusic(List index, int difficulty, Directory tempDir) async{
  int key = Random().nextInt(index.length);
  int musicId = index[key]['music_id'];
  String musicTitle = index[key]['music_title'];
  String artists = index[key]['artist'];
  int titleLength = musicTitle.length;
  int albumId = index[key]['album_id'];

  //获取音乐时长
  final audio = AudioPlayer();
  await audio.setFilePath("${tempDir.path}/music/$musicId.mp3");
  final duration = audio.duration;
  audio.dispose();
  int startAt = Random().nextInt(duration!.inSeconds - 10);

  int answerTime = 0;
  int musicPlayingTime = 0;
  int replaceCount = 0;
  switch(difficulty){
    case 0:
      musicPlayingTime = 7;
      if(titleLength > 5){
        answerTime = 25;
        replaceCount = (titleLength/2).ceil() - 1;
      }else if(titleLength > 2){
        answerTime = 22;
        replaceCount = titleLength - 1;
      }else{
        answerTime = 20;
        replaceCount = 0;
      }
      break;
    case 1:
      if(titleLength > 6){
          replaceCount=(titleLength/2).ceil();
          answerTime = 21;
      }else if (titleLength > 2){
          replaceCount=1;
          answerTime = 17;
      }else{
          replaceCount=0;
          answerTime = 17;
      }
      musicPlayingTime = 6;
      break;
    case 2:
      if(titleLength > 7){
          replaceCount=(titleLength/2).ceil()+1;
          answerTime = 16;
      }else if (titleLength > 4){
          replaceCount=2;
          answerTime = 13;
      }else{
          replaceCount=0;
          answerTime = 13;
      }
      musicPlayingTime = 5;
      break;
    default: 
      if(titleLength > 9){
          replaceCount=3;
      }else{
          replaceCount=0;
      }
      answerTime = 20;
      musicPlayingTime = 6;
      break;
  }
  String tip = replaceCount == 0 ? "歌手：$artists" : randomBlanks(musicTitle, replaceCount) ?? '歌手：$artists';

  return {
    "quizType": 4,
    "id": musicId,
    "answer": musicTitle,
    "artist": artists,
    "album_id": albumId,
    "start_at": startAt,
    "answer_time": answerTime,
    "music_playing_time": musicPlayingTime,
    "tip": tip
  };
}

Future<Map<String, dynamic>> typeOutArtist(List index, int difficulty, Directory tempDir) async{
  int key = Random().nextInt(index.length);
  String artist = index[key]['artist'];
  int musicId = index[key]['music_id'];
  String music = index[key]['music_title'];
  late int artistId;

  if(artist.contains(", ")){
    List artistList = artist.split(", ");
    List artistIdList = index[key]['artist_id'].split(", ");
    int artistKey = Random().nextInt(artistList.length);
    artist = artistList[artistKey];
    artistId = int.parse(artistIdList[artistKey]);
  }else{
    artistId = int.parse(index[key]['artist_id']);
  }
  int artistLength = artist.length;

  //获取音乐时长
  final audio = AudioPlayer();
  await audio.setFilePath("${tempDir.path}/music/$musicId.mp3");
  final duration = audio.duration;
  audio.dispose();
  int startAt = Random().nextInt(duration!.inSeconds - 10);

  int answerTime = 0;
  int musicPlayingTime = 0;
  int replaceCount = 0;
  switch(difficulty){
    case 0:
      musicPlayingTime = 7;
      if(artistLength > 5){
        answerTime = 25;
        replaceCount = (artistLength/2).ceil() - 1;
      }else if(artistLength > 2){
        answerTime = 22;
        replaceCount = artistLength - 1;
      }else{
        answerTime = 20;
        replaceCount = 0;
      }
      break;
    case 1:
      if(artistLength > 6){
          replaceCount=(artistLength/2).ceil();
          answerTime = 21;
      }else if (artistLength > 2){
          replaceCount=1;
          answerTime = 17;
      }else{
          replaceCount=0;
          answerTime = 17;
      }
      musicPlayingTime = 6;
      break;
    case 2:
      if(artistLength > 7){
          replaceCount=(artistLength/2).ceil()+1;
          answerTime = 16;
      }else if (artistLength > 4){
          replaceCount=2;
          answerTime = 13;
      }else{
          replaceCount=0;
          answerTime = 13;
      }
      musicPlayingTime = 5;
      break;
    default: 
      if(artistLength > 9){
          replaceCount=3;
      }else{
          replaceCount=0;
      }
      answerTime = 20;
      musicPlayingTime = 6;
      break;
  }
  String tip = replaceCount == 0 ? "音乐：$music" : randomBlanks(artist, replaceCount) ?? "音乐：$music";

  return {
    "quizType": 5,
    "id": artistId,
    "answer": artist,
    "music": music,
    "music_id": musicId,
    "artist_id": artistId,
    "start_at": startAt,
    "answer_time": answerTime,
    "music_playing_time": musicPlayingTime,
    "tip": tip
  };
}

Future<Map<String, dynamic>> typeOutAlbum(List index, int difficulty, Directory tempDir) async{
  int key = Random().nextInt(index.length);
  int albumId = index[key]['album_id'];
  String albumTitle = index[key]['album_title'];
  String albumArtist = index[key]['album_artist_name'];
  String music = index[key]['music_title'];
  String artist = index[key]['artist'];
  int musicId = index[key]['music_id'];
  int albumLength = albumTitle.length;
  //获取音乐时长
  final audio = AudioPlayer();
  await audio.setFilePath("${tempDir.path}/music/$musicId.mp3");
  final duration = audio.duration;
  audio.dispose();
  int startAt = Random().nextInt(duration!.inSeconds - 10);

  int answerTime = 0;
  int musicPlayingTime = 0;
  int replaceCount = 0;
  switch(difficulty){
    case 0:
      musicPlayingTime = 7;
      if(albumLength > 5){
        answerTime = 25;
        replaceCount = (albumLength/2).ceil() - 1;
      }else if(albumLength > 2){
        answerTime = 22;
        replaceCount = albumLength - 1;
      }else{
        answerTime = 20;
        replaceCount = 0;
      }
      break;
    case 1:
      if(albumLength > 6){
          replaceCount=(albumLength/2).ceil();
          answerTime = 21;
      }else if (albumLength > 2){
          replaceCount=1;
          answerTime = 17;
      }else{
          replaceCount=0;
          answerTime = 17;
      }
      musicPlayingTime = 6;
      break;
    case 2:
      if(albumLength > 7){
          replaceCount=(albumLength/2).ceil()+1;
          answerTime = 16;
      }else if (albumLength > 4){
          replaceCount=2;
          answerTime = 13;
      }else{
          replaceCount=0;
          answerTime = 13;
      }
      musicPlayingTime = 5;
      break;
    default: 
      if(albumLength > 9){
          replaceCount=3;
      }else{
          replaceCount=0;
      }
      answerTime = 20;
      musicPlayingTime = 6;
      break;
  }
  String tip = replaceCount == 0 ? "音乐：$music" : randomBlanks(albumTitle, replaceCount) ?? "音乐：$music";
  return {
    "quizType": 6,
    "music_id": musicId,
    "answer": albumTitle,
    "artist": artist,
    "id": albumId,
    "album_artist": albumArtist,
    "start_at": startAt,
    "answer_time": answerTime,
    "music_playing_time": musicPlayingTime,
    "tip": tip
  };
}

Future<Map<String, dynamic>> typeOutGenre(List index, int difficulty, Directory tempDir) async{
  int key = Random().nextInt(index.length);
  String genre = index[key]['genre'];
  String genreId = index[key]['genre_id'];
  int musicId = index[key]['music_id'];
  String music = index[key]['music_title'];
  String artist = index[key]['artist'];

  if(genre.contains(", ")){
    List genreList = genre.split(", ");
    List genreIdList = genreId.split(", ");
    genreList.removeWhere((item)=>item == "华语" || item == "欧美");
    genreIdList.removeWhere((item)=>item == "3" || item == "17");
    //将genreList中的元素用逗号分隔，存入genre
    genre = genreList.join(", ");
    genreId = genreIdList.join(", ");
  }

  //获取音乐时长
  final audio = AudioPlayer();
  await audio.setFilePath("${tempDir.path}/music/$musicId.mp3");
  final duration = audio.duration;
  audio.dispose();
  int startAt = Random().nextInt(duration!.inSeconds - 10);

  int answerTime = 0;
  int musicPlayingTime = 0;
  switch(difficulty){
    case 0:
      musicPlayingTime = 9;
      answerTime = 25;
      break;
    case 1:
      musicPlayingTime = 8;
      answerTime = 22;
      break;
    case 2:
      musicPlayingTime = 6;
      answerTime = 18;
      break;
    default:
      musicPlayingTime = 9;
      answerTime = 25;
      break;
  }
  
  return {
    "quizType": 7,
    "id": genreId,
    "answer": genre,
    "music_id": musicId,
    "music": music,
    "artist": artist,
    "start_at": startAt,
    "answer_time": answerTime,
    "music_playing_time": musicPlayingTime,
    "tip": "歌手：artist"
  };
}

Future<Map<String, dynamic>> getQuiz(int playlistId, int difficulty, Directory tempDir) async {
  Directory documentsDirectory = Directory((await getApplicationDocumentsDirectory()).path + "/rhythm_riddle");
  //读取options文件
  final File optionsFile = File("${documentsDirectory.path}/offline_data.json");
  if(!optionsFile.existsSync()){
    //从assets读取options
    final Map<String, dynamic> minOptions = jsonDecode(await rootBundle.loadString("assets/min_offline_data.json"));
    optionsFile.createSync(recursive: true);
    optionsFile.writeAsStringSync(jsonEncode(minOptions));
  }
  final Map options = jsonDecode(await optionsFile.readAsString());
  final List musicOptions = options["music"];
  final List artistOptions = options["artist"];
  final List albumOptions = options["album"];
  final List genreOptions = options["genre"];

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
      Map<String, dynamic> quiz3 = await chooseMusic(index, difficulty, tempDir, musicOptions);
      index.removeWhere((item)=>item['music_id'] == quiz3['id']);
      Map<String, dynamic> quiz4 = await chooseAlbum(index, difficulty, tempDir, albumOptions);
      index.removeWhere((item)=>item['music_id'] == quiz4['music_id']);
      Map<String, dynamic> quiz5 = await chooseArtist(index, difficulty, tempDir, artistOptions);
      index.removeWhere((item)=>item['music_id'] == quiz5['music_id']);
      Map<String, dynamic> quiz6 = await typeOutArtist(index, difficulty, tempDir);
      index.removeWhere((item)=>item['music_id'] == quiz6['music_id']);
      Map<String, dynamic> quiz7 = await typeOutMusic(index, difficulty, tempDir);
      
      return {
        "0": quiz1,
        "1": quiz2,
        "2": quiz3,
        "3": quiz4,
        "4": quiz5,
        "5": quiz6,
        "6": quiz7,
      };
    case 1:
      Map<String, dynamic> quiz1 = await chooseGenre(index, difficulty, tempDir, genreOptions);
      index.removeWhere((item)=>item['music_id'] == quiz1['music_id']);
      Map<String, dynamic> quiz2 = await chooseMusic(index, difficulty, tempDir, musicOptions);
      index.removeWhere((item)=>item['music_id'] == quiz2['id']);
      Map<String, dynamic> quiz3 = await chooseAlbum(index, difficulty, tempDir, albumOptions);
      index.removeWhere((item)=>item['music_id'] == quiz3['music_id']);
      Map<String, dynamic> quiz4 = await typeOutMusic(index, difficulty, tempDir);
      index.removeWhere((item)=>item['music_id'] == quiz4['id']);
      Map<String, dynamic> quiz5 = await chooseArtist(index, difficulty, tempDir, artistOptions);
      index.removeWhere((item)=>item['music_id'] == quiz5['music_id']);
      Map<String, dynamic> quiz6 = await typeOutGenre(index, difficulty, tempDir);
      index.removeWhere((item)=>item['music_id'] == quiz6['music_id']);
      Map<String, dynamic> quiz7 = await typeOutAlbum(index, difficulty, tempDir);
      return {
        "0": quiz1,
        "1": quiz2,
        "2": quiz3,
        "3": quiz4,
        "4": quiz5,
        "5": quiz6,
        "6": quiz7,
      };
    case 2: 
      Map<String, dynamic> quiz1 = await typeOutArtist(index, difficulty, tempDir);
      index.removeWhere((item)=>item['music_id'] == quiz1['music_id']);
      Map<String, dynamic> quiz2 = await chooseMusic(index, difficulty, tempDir, musicOptions);
      index.removeWhere((item)=>item['music_id'] == quiz2['id']);
      Map<String, dynamic> quiz3 = await typeOutAlbum(index, difficulty, tempDir);
      index.removeWhere((item)=>item['music_id'] == quiz3['music_id']);
      Map<String, dynamic> quiz4 = await typeOutGenre(index, difficulty, tempDir);
      index.removeWhere((item)=>item['music_id'] == quiz4['music_id']);
      Map<String, dynamic> quiz5 = await typeOutMusic(index, difficulty, tempDir);
      index.removeWhere((item)=>item['music_id'] == quiz5['id']);
      Map<String, dynamic> quiz6 = await chooseGenre(index, difficulty, tempDir, genreOptions);
      index.removeWhere((item)=>item['music_id'] == quiz6['music_id']);
      Map<String, dynamic> quiz7 = await chooseAlbum(index, difficulty, tempDir, albumOptions);
      index.removeWhere((item)=>item['music_id'] == quiz7['music_id']);
      return {
        "0": quiz1,
        "1": quiz2,
        "2": quiz3,
        "3": quiz4,
        "4": quiz5,
        "5": quiz6,
        "6": quiz7,
      };
    default:return{"error": "difficulty error"};
  }
}
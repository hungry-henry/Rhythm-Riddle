import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';
import 'package:window_size/window_size.dart' as window_size;

import 'pages/login.dart';
import 'pages/home.dart';
import 'pages/search.dart';
import 'pages/game/PlaylistInfo.dart';
import 'pages/game/SinglePlayer.dart';
import 'pages/game/MultiPlayer.dart';

void main(){  
  if(Platform.isWindows || Platform.isMacOS || Platform.isLinux){
    WidgetsFlutterBinding.ensureInitialized();
    window_size.setWindowMinSize(const Size(400, 500)); // 设置最小窗口大小
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('zh'),
      ],
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      routes: {
        'login': (context) => LoginPage(),
        'home': (context) => const Home(),
        'search': (context) => Search(),
        'PlaylistInfo': (context) => PlaylistInfo(),
        'SinglePlayer': (context) => SinglePlayer(),
        'SinglePlayerGame': (context) => SinglePlayerGame(),
        'MultiPlayer': (context) => MultiPlayer(),
      },
    );
  }
}
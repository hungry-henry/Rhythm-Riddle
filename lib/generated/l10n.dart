// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Rhythm Riddle`
  String get name {
    return Intl.message(
      'Rhythm Riddle',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Loggin In...`
  String get loggingIn {
    return Intl.message(
      'Loggin In...',
      name: 'loggingIn',
      desc: '',
      args: [],
    );
  }

  /// `or`
  String get or {
    return Intl.message(
      'or',
      name: 'or',
      desc: '',
      args: [],
    );
  }

  /// `No account? Click here to sign up!`
  String get register {
    return Intl.message(
      'No account? Click here to sign up!',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `offline mode`
  String get guest {
    return Intl.message(
      'offline mode',
      name: 'guest',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `E-mail/Username`
  String get emailOrName {
    return Intl.message(
      'E-mail/Username',
      name: 'emailOrName',
      desc: '',
      args: [],
    );
  }

  /// `incorrect`
  String get incorrect {
    return Intl.message(
      'incorrect',
      name: 'incorrect',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email`
  String get emptyemail {
    return Intl.message(
      'Please enter your email',
      name: 'emptyemail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your password`
  String get emptypassword {
    return Intl.message(
      'Please enter your password',
      name: 'emptypassword',
      desc: '',
      args: [],
    );
  }

  /// `Cannot connect to server. Pls contact hungryhenry101@outlook.com`
  String get unknownError {
    return Intl.message(
      'Cannot connect to server. Pls contact hungryhenry101@outlook.com',
      name: 'unknownError',
      desc: '',
      args: [],
    );
  }

  /// `login info expired, pls login again`
  String get loginExpired {
    return Intl.message(
      'login info expired, pls login again',
      name: 'loginExpired',
      desc: '',
      args: [],
    );
  }

  /// `Cannot connect to server. Pls try again later or use offline mode`
  String get connectError {
    return Intl.message(
      'Cannot connect to server. Pls try again later or use offline mode',
      name: 'connectError',
      desc: '',
      args: [],
    );
  }

  /// `Cannot check version. Pls try again later or contact hungryhenry101@outlook.com`
  String get versionCheckError {
    return Intl.message(
      'Cannot check version. Pls try again later or contact hungryhenry101@outlook.com',
      name: 'versionCheckError',
      desc: '',
      args: [],
    );
  }

  /// `Lack of {permission}. Pls grant perm(s) manually`
  String permissionError(Object permission) {
    return Intl.message(
      'Lack of $permission. Pls grant perm(s) manually',
      name: 'permissionError',
      desc: '',
      args: [permission],
    );
  }

  /// `Pls grant notification permission to prevent the process from killing by system`
  String get permissionExplain {
    return Intl.message(
      'Pls grant notification permission to prevent the process from killing by system',
      name: 'permissionExplain',
      desc: '',
      args: [],
    );
  }

  /// `Storage Permission`
  String get storagePerm {
    return Intl.message(
      'Storage Permission',
      name: 'storagePerm',
      desc: '',
      args: [],
    );
  }

  /// `Notification Permission`
  String get ntfPerm {
    return Intl.message(
      'Notification Permission',
      name: 'ntfPerm',
      desc: '',
      args: [],
    );
  }

  /// `Install Packages Permission`
  String get installPerm {
    return Intl.message(
      'Install Packages Permission',
      name: 'installPerm',
      desc: '',
      args: [],
    );
  }

  /// `Restart the App After Granting`
  String get restart {
    return Intl.message(
      'Restart the App After Granting',
      name: 'restart',
      desc: '',
      args: [],
    );
  }

  /// `Dload and Install by Browser`
  String get installManually {
    return Intl.message(
      'Dload and Install by Browser',
      name: 'installManually',
      desc: '',
      args: [],
    );
  }

  /// `OK👌`
  String get ok {
    return Intl.message(
      'OK👌',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Re-Login`
  String get relogin {
    return Intl.message(
      'Re-Login',
      name: 'relogin',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message(
      'Retry',
      name: 'retry',
      desc: '',
      args: [],
    );
  }

  /// `Back to Home`
  String get backToHome {
    return Intl.message(
      'Back to Home',
      name: 'backToHome',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message(
      'Back',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get loading {
    return Intl.message(
      'Loading...',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `Checking updates...`
  String get checkingUpdate {
    return Intl.message(
      'Checking updates...',
      name: 'checkingUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Curr ver.: {version}, new ver. available: {latestVersion}`
  String update(Object version, Object latestVersion) {
    return Intl.message(
      'Curr ver.: $version, new ver. available: $latestVersion',
      name: 'update',
      desc: '',
      args: [version, latestVersion],
    );
  }

  /// `Download Progress: `
  String get downloadProgress {
    return Intl.message(
      'Download Progress: ',
      name: 'downloadProgress',
      desc: '',
      args: [],
    );
  }

  /// `Update Now`
  String get dlUpdate {
    return Intl.message(
      'Update Now',
      name: 'dlUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Release Date: {date}`
  String releaseDate(Object date) {
    return Intl.message(
      'Release Date: $date',
      name: 'releaseDate',
      desc: '',
      args: [date],
    );
  }

  /// `Downloading {version}...`
  String downloading(Object version) {
    return Intl.message(
      'Downloading $version...',
      name: 'downloading',
      desc: '',
      args: [version],
    );
  }

  /// `Please wear your headphones for a better experience`
  String get wearHeadphone {
    return Intl.message(
      'Please wear your headphones for a better experience',
      name: 'wearHeadphone',
      desc: '',
      args: [],
    );
  }

  /// `Account Management`
  String get accountManage {
    return Intl.message(
      'Account Management',
      name: 'accountManage',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get history {
    return Intl.message(
      'History',
      name: 'history',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get setting {
    return Intl.message(
      'Settings',
      name: 'setting',
      desc: '',
      args: [],
    );
  }

  /// `Local Playlists`
  String get localPlaylists {
    return Intl.message(
      'Local Playlists',
      name: 'localPlaylists',
      desc: '',
      args: [],
    );
  }

  /// `Appearance`
  String get appearance {
    return Intl.message(
      'Appearance',
      name: 'appearance',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Dark Mode`
  String get darkMode {
    return Intl.message(
      'Dark Mode',
      name: 'darkMode',
      desc: '',
      args: [],
    );
  }

  /// `Follow System`
  String get followSystem {
    return Intl.message(
      'Follow System',
      name: 'followSystem',
      desc: '',
      args: [],
    );
  }

  /// `Game Settings`
  String get gameSettings {
    return Intl.message(
      'Game Settings',
      name: 'gameSettings',
      desc: '',
      args: [],
    );
  }

  /// `Home🏠`
  String get home {
    return Intl.message(
      'Home🏠',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Me`
  String get me {
    return Intl.message(
      'Me',
      name: 'me',
      desc: '',
      args: [],
    );
  }

  /// `Rank`
  String get rank {
    return Intl.message(
      'Rank',
      name: 'rank',
      desc: '',
      args: [],
    );
  }

  /// `Recommend`
  String get recm {
    return Intl.message(
      'Recommend',
      name: 'recm',
      desc: '',
      args: [],
    );
  }

  /// `Hot🔥`
  String get hot {
    return Intl.message(
      'Hot🔥',
      name: 'hot',
      desc: '',
      args: [],
    );
  }

  /// `Sort`
  String get sort {
    return Intl.message(
      'Sort',
      name: 'sort',
      desc: '',
      args: [],
    );
  }

  /// `Search playlist, song and artist`
  String get search {
    return Intl.message(
      'Search playlist, song and artist',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Songs`
  String get songs {
    return Intl.message(
      'Songs',
      name: 'songs',
      desc: '',
      args: [],
    );
  }

  /// `Played`
  String get played {
    return Intl.message(
      'Played',
      name: 'played',
      desc: '',
      args: [],
    );
  }

  /// `Likes`
  String get likes {
    return Intl.message(
      'Likes',
      name: 'likes',
      desc: '',
      args: [],
    );
  }

  /// `Downloaded`
  String get downloaded {
    return Intl.message(
      'Downloaded',
      name: 'downloaded',
      desc: '',
      args: [],
    );
  }

  /// `Download`
  String get download {
    return Intl.message(
      'Download',
      name: 'download',
      desc: '',
      args: [],
    );
  }

  /// `A bug appeared, pls report to hungryhenry101@outlook.com`
  String get bug {
    return Intl.message(
      'A bug appeared, pls report to hungryhenry101@outlook.com',
      name: 'bug',
      desc: '',
      args: [],
    );
  }

  /// `Single Player`
  String get singlePlayer {
    return Intl.message(
      'Single Player',
      name: 'singlePlayer',
      desc: '',
      args: [],
    );
  }

  /// `Multi Player (Coming Soon)`
  String get multiPlayer {
    return Intl.message(
      'Multi Player (Coming Soon)',
      name: 'multiPlayer',
      desc: '',
      args: [],
    );
  }

  /// `Single Player Options`
  String get singlePlayerOptions {
    return Intl.message(
      'Single Player Options',
      name: 'singlePlayerOptions',
      desc: '',
      args: [],
    );
  }

  /// `Multi Player Options`
  String get multiPlayerOptions {
    return Intl.message(
      'Multi Player Options',
      name: 'multiPlayerOptions',
      desc: '',
      args: [],
    );
  }

  /// `Creator`
  String get creator {
    return Intl.message(
      'Creator',
      name: 'creator',
      desc: '',
      args: [],
    );
  }

  /// `Created at`
  String get createTime {
    return Intl.message(
      'Created at',
      name: 'createTime',
      desc: '',
      args: [],
    );
  }

  /// `Contains {count} songs including {title} - {artist} and more`
  String contains(Object count, Object title, Object artist) {
    return Intl.message(
      'Contains $count songs including $title - $artist and more',
      name: 'contains',
      desc: '',
      args: [count, title, artist],
    );
  }

  /// `No Description`
  String get noDes {
    return Intl.message(
      'No Description',
      name: 'noDes',
      desc: '',
      args: [],
    );
  }

  /// `Choose Difficulty`
  String get chooseDifficulty {
    return Intl.message(
      'Choose Difficulty',
      name: 'chooseDifficulty',
      desc: '',
      args: [],
    );
  }

  /// `Difficulty`
  String get difficulty {
    return Intl.message(
      'Difficulty',
      name: 'difficulty',
      desc: '',
      args: [],
    );
  }

  /// `Easy`
  String get easy {
    return Intl.message(
      'Easy',
      name: 'easy',
      desc: '',
      args: [],
    );
  }

  /// `Normal`
  String get normal {
    return Intl.message(
      'Normal',
      name: 'normal',
      desc: '',
      args: [],
    );
  }

  /// `Hard`
  String get hard {
    return Intl.message(
      'Hard',
      name: 'hard',
      desc: '',
      args: [],
    );
  }

  /// `Custom`
  String get custom {
    return Intl.message(
      'Custom',
      name: 'custom',
      desc: '',
      args: [],
    );
  }

  /// `Easy mode: 5 times mistake chances, 4 options to choose for Artist or Music title`
  String get easyInfo {
    return Intl.message(
      'Easy mode: 5 times mistake chances, 4 options to choose for Artist or Music title',
      name: 'easyInfo',
      desc: '',
      args: [],
    );
  }

  /// `Normal mode: 3 times mistake chances, 4 options to choose or fill in the blanks with hints for Artist or Music title or Album`
  String get normalInfo {
    return Intl.message(
      'Normal mode: 3 times mistake chances, 4 options to choose or fill in the blanks with hints for Artist or Music title or Album',
      name: 'normalInfo',
      desc: '',
      args: [],
    );
  }

  /// `Hard mode: 2 times mistake chances, fill in the blanks for Artist or Music title or Album`
  String get hardInfo {
    return Intl.message(
      'Hard mode: 2 times mistake chances, fill in the blanks for Artist or Music title or Album',
      name: 'hardInfo',
      desc: '',
      args: [],
    );
  }

  /// `Start`
  String get start {
    return Intl.message(
      'Start',
      name: 'start',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message(
      'Submit',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `End👉`
  String get end {
    return Intl.message(
      'End👉',
      name: 'end',
      desc: '',
      args: [],
    );
  }

  /// `Choose the music currently playing`
  String get chooseMusic {
    return Intl.message(
      'Choose the music currently playing',
      name: 'chooseMusic',
      desc: '',
      args: [],
    );
  }

  /// `Choose the artist of the playing music`
  String get chooseArtist {
    return Intl.message(
      'Choose the artist of the playing music',
      name: 'chooseArtist',
      desc: '',
      args: [],
    );
  }

  /// `Choose the album of the playing music`
  String get chooseAlbum {
    return Intl.message(
      'Choose the album of the playing music',
      name: 'chooseAlbum',
      desc: '',
      args: [],
    );
  }

  /// `Choose the genre of the playing music`
  String get chooseGenre {
    return Intl.message(
      'Choose the genre of the playing music',
      name: 'chooseGenre',
      desc: '',
      args: [],
    );
  }

  /// `Enter the name of the playing music`
  String get enterMusic {
    return Intl.message(
      'Enter the name of the playing music',
      name: 'enterMusic',
      desc: '',
      args: [],
    );
  }

  /// `Enter the artist of the playing music`
  String get enterArtist {
    return Intl.message(
      'Enter the artist of the playing music',
      name: 'enterArtist',
      desc: '',
      args: [],
    );
  }

  /// `Enter the album of the playing music`
  String get enterAlbum {
    return Intl.message(
      'Enter the album of the playing music',
      name: 'enterAlbum',
      desc: '',
      args: [],
    );
  }

  /// `Enter the genre of the playing music`
  String get enterGenre {
    return Intl.message(
      'Enter the genre of the playing music',
      name: 'enterGenre',
      desc: '',
      args: [],
    );
  }

  /// `Tips: `
  String get tip {
    return Intl.message(
      'Tips: ',
      name: 'tip',
      desc: '',
      args: [],
    );
  }

  /// `Correct Answer: `
  String get correctAnswer {
    return Intl.message(
      'Correct Answer: ',
      name: 'correctAnswer',
      desc: '',
      args: [],
    );
  }

  /// `Correct✔`
  String get correct {
    return Intl.message(
      'Correct✔',
      name: 'correct',
      desc: '',
      args: [],
    );
  }

  /// `Wrong❌`
  String get wrong {
    return Intl.message(
      'Wrong❌',
      name: 'wrong',
      desc: '',
      args: [],
    );
  }

  /// `Result of {playlist}`
  String quizResult(Object playlist) {
    return Intl.message(
      'Result of $playlist',
      name: 'quizResult',
      desc: '',
      args: [playlist],
    );
  }

  /// `Answer Details`
  String get details {
    return Intl.message(
      'Answer Details',
      name: 'details',
      desc: '',
      args: [],
    );
  }

  /// `points`
  String get pts {
    return Intl.message(
      'points',
      name: 'pts',
      desc: '',
      args: [],
    );
  }

  /// `quizzes`
  String get quizzes {
    return Intl.message(
      'quizzes',
      name: 'quizzes',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}

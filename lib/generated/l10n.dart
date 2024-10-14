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

  /// `Cannot connect to server. Pls use offline mode or contact hamrui@outlook.com`
  String get unknownError {
    return Intl.message(
      'Cannot connect to server. Pls use offline mode or contact hamrui@outlook.com',
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

  /// `OK👌`
  String get ok {
    return Intl.message(
      'OK👌',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Retry🔄`
  String get retry {
    return Intl.message(
      'Retry🔄',
      name: 'retry',
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

  /// `Account`
  String get account {
    return Intl.message(
      'Account',
      name: 'account',
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

  /// `A bug appeared, pls report to hamrui@outlook.com`
  String get bug {
    return Intl.message(
      'A bug appeared, pls report to hamrui@outlook.com',
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

  /// `Multi Player`
  String get multiPlayer {
    return Intl.message(
      'Multi Player',
      name: 'multiPlayer',
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

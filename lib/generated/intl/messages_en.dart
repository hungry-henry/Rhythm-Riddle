// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(count, title, artist) =>
      "Contains ${count} songs including ${title} - ${artist} and more";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "MultiPlayerGame":
            MessageLookupByLibrary.simpleMessage("Multi Player Game"),
        "account": MessageLookupByLibrary.simpleMessage("Account"),
        "back": MessageLookupByLibrary.simpleMessage("Back"),
        "backToHome": MessageLookupByLibrary.simpleMessage("Back to Home"),
        "bug": MessageLookupByLibrary.simpleMessage(
            "A bug appeared, pls report to hamrui@outlook.com"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "chooseAlbum": MessageLookupByLibrary.simpleMessage(
            "Choose the album of the playing music"),
        "chooseArtist": MessageLookupByLibrary.simpleMessage(
            "Choose the artist of the playing music"),
        "chooseDifficulty":
            MessageLookupByLibrary.simpleMessage("Choose Difficulty"),
        "chooseGenre": MessageLookupByLibrary.simpleMessage(
            "Choose the genre of the playing music"),
        "chooseMusic": MessageLookupByLibrary.simpleMessage(
            "Choose the music that is playing"),
        "connectError": MessageLookupByLibrary.simpleMessage(
            "Cannot connect to server. Pls try again later or use offline mode"),
        "contains": m0,
        "custom": MessageLookupByLibrary.simpleMessage("Custom"),
        "difficulty": MessageLookupByLibrary.simpleMessage("Difficulty"),
        "easy": MessageLookupByLibrary.simpleMessage("Easy"),
        "easyInfo": MessageLookupByLibrary.simpleMessage(
            "Easy mode: 5 times mistake chances, 4 options to choose for Artist or Music title"),
        "emailOrName": MessageLookupByLibrary.simpleMessage("E-mail/Username"),
        "emptyemail":
            MessageLookupByLibrary.simpleMessage("Please enter your email"),
        "emptypassword":
            MessageLookupByLibrary.simpleMessage("Please enter your password"),
        "guest": MessageLookupByLibrary.simpleMessage("offline mode"),
        "hard": MessageLookupByLibrary.simpleMessage("Hard"),
        "hardInfo": MessageLookupByLibrary.simpleMessage(
            "Hard mode: 2 times mistake chances, fill in the blanks for Artist or Music title or Album"),
        "home": MessageLookupByLibrary.simpleMessage("Home🏠"),
        "hot": MessageLookupByLibrary.simpleMessage("Hot🔥"),
        "incorrect": MessageLookupByLibrary.simpleMessage("incorrect"),
        "likes": MessageLookupByLibrary.simpleMessage("Likes"),
        "loading": MessageLookupByLibrary.simpleMessage("Loading..."),
        "loggingIn": MessageLookupByLibrary.simpleMessage("Loggin In..."),
        "login": MessageLookupByLibrary.simpleMessage("Login"),
        "loginExpired": MessageLookupByLibrary.simpleMessage(
            "login info expired, pls login again"),
        "multiPlayer": MessageLookupByLibrary.simpleMessage("Multi Player"),
        "multiPlayerOptions":
            MessageLookupByLibrary.simpleMessage("Multi Player Options"),
        "name": MessageLookupByLibrary.simpleMessage("Rhythm Riddle"),
        "noDes": MessageLookupByLibrary.simpleMessage("No Description"),
        "normal": MessageLookupByLibrary.simpleMessage("Normal"),
        "normalInfo": MessageLookupByLibrary.simpleMessage(
            "Normal mode: 3 times mistake chances, 4 options to choose or fill in the blanks with hints for Artist or Music title or Album"),
        "ok": MessageLookupByLibrary.simpleMessage("OK👌"),
        "or": MessageLookupByLibrary.simpleMessage("or"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "played": MessageLookupByLibrary.simpleMessage("Played"),
        "rank": MessageLookupByLibrary.simpleMessage("Rank"),
        "recm": MessageLookupByLibrary.simpleMessage("Recommend"),
        "register": MessageLookupByLibrary.simpleMessage(
            "No account? Click here to sign up!"),
        "relogin": MessageLookupByLibrary.simpleMessage("Re-Login"),
        "retry": MessageLookupByLibrary.simpleMessage("Retry"),
        "search": MessageLookupByLibrary.simpleMessage(
            "Search playlist, song and artist"),
        "singlePlayer": MessageLookupByLibrary.simpleMessage("Single Player"),
        "singlePlayerGame":
            MessageLookupByLibrary.simpleMessage("Single Player Game"),
        "singlePlayerOptions":
            MessageLookupByLibrary.simpleMessage("Single Player Options"),
        "songs": MessageLookupByLibrary.simpleMessage("Songs"),
        "sort": MessageLookupByLibrary.simpleMessage("Sort"),
        "start": MessageLookupByLibrary.simpleMessage("Start"),
        "submit": MessageLookupByLibrary.simpleMessage("Submit"),
        "unknownError": MessageLookupByLibrary.simpleMessage(
            "Cannot connect to server. Pls use offline mode or contact hamrui@outlook.com")
      };
}

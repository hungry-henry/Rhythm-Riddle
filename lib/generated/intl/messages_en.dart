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

  static String m0(title, artist) => "Contains ${title} - ${artist} and more";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "account": MessageLookupByLibrary.simpleMessage("Account"),
        "backToHome": MessageLookupByLibrary.simpleMessage("Back to Home"),
        "bug": MessageLookupByLibrary.simpleMessage(
            "A bug appeared, pls report to hamrui@outlook.com"),
        "connectError": MessageLookupByLibrary.simpleMessage(
            "Cannot connect to server. Pls try again later or use offline mode"),
        "contains": m0,
        "emailOrName": MessageLookupByLibrary.simpleMessage("E-mail/Username"),
        "emptyemail":
            MessageLookupByLibrary.simpleMessage("Please enter your email"),
        "emptypassword":
            MessageLookupByLibrary.simpleMessage("Please enter your password"),
        "guest": MessageLookupByLibrary.simpleMessage("offline mode"),
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
        "name": MessageLookupByLibrary.simpleMessage("Rhythm Riddle"),
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
        "songs": MessageLookupByLibrary.simpleMessage("Songs"),
        "sort": MessageLookupByLibrary.simpleMessage("Sort"),
        "unknownError": MessageLookupByLibrary.simpleMessage(
            "Cannot connect to server. Pls use offline mode or contact hamrui@outlook.com")
      };
}

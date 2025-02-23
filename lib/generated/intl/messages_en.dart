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

  static String m1(version) => "Downloading ${version}...";

  static String m2(permission) =>
      "Lack of ${permission} Permission, failed to update. Pls grant permission(s) manually";

  static String m3(playlist) => "Result of ${playlist}";

  static String m4(date) => "Release Date: ${date}";

  static String m5(version, latestVersion) =>
      "Curr ver.: ${version}, new ver. available: ${latestVersion}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "accountManage":
            MessageLookupByLibrary.simpleMessage("Account Management"),
        "appearance": MessageLookupByLibrary.simpleMessage("Appearance"),
        "back": MessageLookupByLibrary.simpleMessage("Back"),
        "backToHome": MessageLookupByLibrary.simpleMessage("Back to Home"),
        "bug": MessageLookupByLibrary.simpleMessage(
            "A bug appeared, pls report to hungryhenry101@outlook.com"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "checkingUpdate":
            MessageLookupByLibrary.simpleMessage("Checking updates..."),
        "chooseAlbum": MessageLookupByLibrary.simpleMessage(
            "Choose the album of the playing music"),
        "chooseArtist": MessageLookupByLibrary.simpleMessage(
            "Choose the artist of the playing music"),
        "chooseDifficulty":
            MessageLookupByLibrary.simpleMessage("Choose Difficulty"),
        "chooseGenre": MessageLookupByLibrary.simpleMessage(
            "Choose the genre of the playing music"),
        "chooseMusic": MessageLookupByLibrary.simpleMessage(
            "Choose the music currently playing"),
        "connectError": MessageLookupByLibrary.simpleMessage(
            "Cannot connect to server. Pls try again later or use offline mode"),
        "contains": m0,
        "correct": MessageLookupByLibrary.simpleMessage("Correct✔"),
        "correctAnswer":
            MessageLookupByLibrary.simpleMessage("Correct Answer: "),
        "createTime": MessageLookupByLibrary.simpleMessage("Created at"),
        "creator": MessageLookupByLibrary.simpleMessage("Creator"),
        "custom": MessageLookupByLibrary.simpleMessage("Custom"),
        "darkMode": MessageLookupByLibrary.simpleMessage("Dark Mode"),
        "details": MessageLookupByLibrary.simpleMessage("Answer Details"),
        "difficulty": MessageLookupByLibrary.simpleMessage("Difficulty"),
        "dlUpdate": MessageLookupByLibrary.simpleMessage("Update Now"),
        "downloadProgress":
            MessageLookupByLibrary.simpleMessage("Download Progress: "),
        "downloading": m1,
        "easy": MessageLookupByLibrary.simpleMessage("Easy"),
        "easyInfo": MessageLookupByLibrary.simpleMessage(
            "Easy mode: 5 times mistake chances, 4 options to choose for Artist or Music title"),
        "emailOrName": MessageLookupByLibrary.simpleMessage("E-mail/Username"),
        "emptyemail":
            MessageLookupByLibrary.simpleMessage("Please enter your email"),
        "emptypassword":
            MessageLookupByLibrary.simpleMessage("Please enter your password"),
        "end": MessageLookupByLibrary.simpleMessage("End👉"),
        "enterAlbum": MessageLookupByLibrary.simpleMessage(
            "Enter the album of the playing music"),
        "enterArtist": MessageLookupByLibrary.simpleMessage(
            "Enter the artist of the playing music"),
        "enterGenre": MessageLookupByLibrary.simpleMessage(
            "Enter the genre of the playing music"),
        "enterMusic": MessageLookupByLibrary.simpleMessage(
            "Enter the name of the playing music"),
        "followSystem": MessageLookupByLibrary.simpleMessage("Follow System"),
        "gameSettings": MessageLookupByLibrary.simpleMessage("Game Settings"),
        "guest": MessageLookupByLibrary.simpleMessage("offline mode"),
        "hard": MessageLookupByLibrary.simpleMessage("Hard"),
        "hardInfo": MessageLookupByLibrary.simpleMessage(
            "Hard mode: 2 times mistake chances, fill in the blanks for Artist or Music title or Album"),
        "history": MessageLookupByLibrary.simpleMessage("History"),
        "home": MessageLookupByLibrary.simpleMessage("Home🏠"),
        "hot": MessageLookupByLibrary.simpleMessage("Hot🔥"),
        "incorrect": MessageLookupByLibrary.simpleMessage("incorrect"),
        "installManually": MessageLookupByLibrary.simpleMessage(
            "Dload and Install by Browser"),
        "installPerm":
            MessageLookupByLibrary.simpleMessage("Install Packages Permission"),
        "language": MessageLookupByLibrary.simpleMessage("Language"),
        "likes": MessageLookupByLibrary.simpleMessage("Likes"),
        "loading": MessageLookupByLibrary.simpleMessage("Loading..."),
        "loggingIn": MessageLookupByLibrary.simpleMessage("Loggin In..."),
        "login": MessageLookupByLibrary.simpleMessage("Login"),
        "loginExpired": MessageLookupByLibrary.simpleMessage(
            "login info expired, pls login again"),
        "me": MessageLookupByLibrary.simpleMessage("Me"),
        "multiPlayer":
            MessageLookupByLibrary.simpleMessage("Multi Player (Coming Soon)"),
        "multiPlayerOptions":
            MessageLookupByLibrary.simpleMessage("Multi Player Options"),
        "myPlaylists": MessageLookupByLibrary.simpleMessage("My Playlists"),
        "name": MessageLookupByLibrary.simpleMessage("Rhythm Riddle"),
        "next": MessageLookupByLibrary.simpleMessage("Next"),
        "noDes": MessageLookupByLibrary.simpleMessage("No Description"),
        "normal": MessageLookupByLibrary.simpleMessage("Normal"),
        "normalInfo": MessageLookupByLibrary.simpleMessage(
            "Normal mode: 3 times mistake chances, 4 options to choose or fill in the blanks with hints for Artist or Music title or Album"),
        "ntfPerm":
            MessageLookupByLibrary.simpleMessage("Notification Permission"),
        "ok": MessageLookupByLibrary.simpleMessage("OK👌"),
        "or": MessageLookupByLibrary.simpleMessage("or"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "permissionError": m2,
        "permissionExplain": MessageLookupByLibrary.simpleMessage(
            "Pls grant notification permission to prevent the process from killing by system"),
        "played": MessageLookupByLibrary.simpleMessage("Played"),
        "pts": MessageLookupByLibrary.simpleMessage("points"),
        "quizResult": m3,
        "quizzes": MessageLookupByLibrary.simpleMessage("quizzes"),
        "rank": MessageLookupByLibrary.simpleMessage("Rank"),
        "recm": MessageLookupByLibrary.simpleMessage("Recommend"),
        "register": MessageLookupByLibrary.simpleMessage(
            "No account? Click here to sign up!"),
        "releaseDate": m4,
        "relogin": MessageLookupByLibrary.simpleMessage("Re-Login"),
        "restart": MessageLookupByLibrary.simpleMessage(
            "Restart the App After Granting"),
        "retry": MessageLookupByLibrary.simpleMessage("Retry"),
        "search": MessageLookupByLibrary.simpleMessage(
            "Search playlist, song and artist"),
        "setting": MessageLookupByLibrary.simpleMessage("Settings"),
        "singlePlayer": MessageLookupByLibrary.simpleMessage("Single Player"),
        "singlePlayerOptions":
            MessageLookupByLibrary.simpleMessage("Single Player Options"),
        "songs": MessageLookupByLibrary.simpleMessage("Songs"),
        "sort": MessageLookupByLibrary.simpleMessage("Sort"),
        "start": MessageLookupByLibrary.simpleMessage("Start"),
        "storagePerm":
            MessageLookupByLibrary.simpleMessage("Storage Permission"),
        "submit": MessageLookupByLibrary.simpleMessage("Submit"),
        "tip": MessageLookupByLibrary.simpleMessage("Tips: "),
        "unknownError": MessageLookupByLibrary.simpleMessage(
            "Cannot connect to server. Pls contact hungryhenry101@outlook.com"),
        "update": m5,
        "versionCheckError": MessageLookupByLibrary.simpleMessage(
            "Cannot check version. Pls try again later or contact hungryhenry101@outlook.com"),
        "wearHeadphone": MessageLookupByLibrary.simpleMessage(
            "Please wear your headphones for a better experience"),
        "wrong": MessageLookupByLibrary.simpleMessage("Wrong❌")
      };
}

// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
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
  String get localeName => 'zh';

  static String m0(title, artist) => "包含 ${title} - ${artist} 等歌曲";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "account": MessageLookupByLibrary.simpleMessage("账户"),
        "backToHome": MessageLookupByLibrary.simpleMessage("返回主页"),
        "bug": MessageLookupByLibrary.simpleMessage(
            "游戏出现BUG了，请反馈给hamrui@outlook.com"),
        "connectError":
            MessageLookupByLibrary.simpleMessage("无法连接至服务器，请稍后再试或离线游玩"),
        "contains": m0,
        "emailOrName": MessageLookupByLibrary.simpleMessage("邮箱/用户名"),
        "emptyemail": MessageLookupByLibrary.simpleMessage("请输入邮箱"),
        "emptypassword": MessageLookupByLibrary.simpleMessage("请输入密码"),
        "guest": MessageLookupByLibrary.simpleMessage("离线模式"),
        "home": MessageLookupByLibrary.simpleMessage("主页🏠"),
        "hot": MessageLookupByLibrary.simpleMessage("热门🔥"),
        "incorrect": MessageLookupByLibrary.simpleMessage("错误"),
        "likes": MessageLookupByLibrary.simpleMessage("赞"),
        "loading": MessageLookupByLibrary.simpleMessage("加载中..."),
        "loggingIn": MessageLookupByLibrary.simpleMessage("登录中..."),
        "login": MessageLookupByLibrary.simpleMessage("登录"),
        "loginExpired": MessageLookupByLibrary.simpleMessage("登录已过期，请重新登录"),
        "multiPlayer": MessageLookupByLibrary.simpleMessage("多人模式"),
        "name": MessageLookupByLibrary.simpleMessage("旋律疑谜"),
        "ok": MessageLookupByLibrary.simpleMessage("确定👌"),
        "or": MessageLookupByLibrary.simpleMessage("或"),
        "password": MessageLookupByLibrary.simpleMessage("密码"),
        "played": MessageLookupByLibrary.simpleMessage("玩过"),
        "rank": MessageLookupByLibrary.simpleMessage("排行榜"),
        "recm": MessageLookupByLibrary.simpleMessage("推荐"),
        "register": MessageLookupByLibrary.simpleMessage("没有账号? 点此注册!"),
        "relogin": MessageLookupByLibrary.simpleMessage("重新登录"),
        "retry": MessageLookupByLibrary.simpleMessage("重试"),
        "search": MessageLookupByLibrary.simpleMessage("搜索歌单、歌曲或歌手"),
        "singlePlayer": MessageLookupByLibrary.simpleMessage("单人模式"),
        "songs": MessageLookupByLibrary.simpleMessage("歌曲"),
        "sort": MessageLookupByLibrary.simpleMessage("分类"),
        "unknownError": MessageLookupByLibrary.simpleMessage(
            "软件/服务器问题，请重试或免登录进入或联系hamrui@outlook.com")
      };
}

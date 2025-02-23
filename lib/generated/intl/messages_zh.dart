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

  static String m0(count, title, artist) =>
      "包含 ${title} - ${artist} 等 ${count} 首歌曲";

  static String m1(version) => "正在下载${version}...";

  static String m2(permission) => "缺少${permission}权限，无法更新，请手动授予权限";

  static String m3(playlist) => "${playlist} 的答题结果";

  static String m4(date) => "发布日期：${date}";

  static String m5(version, latestVersion) =>
      "当前版本：${version}，有新版本：${latestVersion}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "accountManage": MessageLookupByLibrary.simpleMessage("账户管理"),
        "appearance": MessageLookupByLibrary.simpleMessage("外观"),
        "back": MessageLookupByLibrary.simpleMessage("返回"),
        "backToHome": MessageLookupByLibrary.simpleMessage("返回主页"),
        "bug": MessageLookupByLibrary.simpleMessage(
            "游戏出现BUG了，请反馈给hungryhenry101@outlook.com"),
        "cancel": MessageLookupByLibrary.simpleMessage("取消"),
        "checkingUpdate": MessageLookupByLibrary.simpleMessage("检查更新中..."),
        "chooseAlbum": MessageLookupByLibrary.simpleMessage("选择当前播放的所属专辑"),
        "chooseArtist": MessageLookupByLibrary.simpleMessage("选择当前播放歌曲的歌手"),
        "chooseDifficulty": MessageLookupByLibrary.simpleMessage("选择难度"),
        "chooseGenre": MessageLookupByLibrary.simpleMessage("选择当前播放的所属流派"),
        "chooseMusic": MessageLookupByLibrary.simpleMessage("选择当前播放的歌曲名"),
        "connectError":
            MessageLookupByLibrary.simpleMessage("无法连接至服务器，请稍后再试或使用本地歌单游玩"),
        "contains": m0,
        "correct": MessageLookupByLibrary.simpleMessage("正确✔"),
        "correctAnswer": MessageLookupByLibrary.simpleMessage("正确答案: "),
        "createTime": MessageLookupByLibrary.simpleMessage("创建时间"),
        "creator": MessageLookupByLibrary.simpleMessage("创建者"),
        "custom": MessageLookupByLibrary.simpleMessage("自定义"),
        "darkMode": MessageLookupByLibrary.simpleMessage("深色模式"),
        "details": MessageLookupByLibrary.simpleMessage("答题细节"),
        "difficulty": MessageLookupByLibrary.simpleMessage("难度"),
        "dlUpdate": MessageLookupByLibrary.simpleMessage("立即下载"),
        "downloadProgress": MessageLookupByLibrary.simpleMessage("下载进度："),
        "downloading": m1,
        "easy": MessageLookupByLibrary.simpleMessage("简单"),
        "easyInfo":
            MessageLookupByLibrary.simpleMessage("简单模式：5次失误机会，曲名或歌手4选1"),
        "emailOrName": MessageLookupByLibrary.simpleMessage("邮箱/用户名"),
        "emptyemail": MessageLookupByLibrary.simpleMessage("请输入邮箱"),
        "emptypassword": MessageLookupByLibrary.simpleMessage("请输入密码"),
        "end": MessageLookupByLibrary.simpleMessage("结束👉"),
        "enterAlbum": MessageLookupByLibrary.simpleMessage("填写当前播放的所属专辑"),
        "enterArtist": MessageLookupByLibrary.simpleMessage("填写当前播放的歌曲的歌手"),
        "enterGenre": MessageLookupByLibrary.simpleMessage("填写当前播放的所属流派"),
        "enterMusic": MessageLookupByLibrary.simpleMessage("填写当前播放的歌曲名"),
        "followSystem": MessageLookupByLibrary.simpleMessage("跟随系统"),
        "gameSettings": MessageLookupByLibrary.simpleMessage("游戏设置"),
        "guest": MessageLookupByLibrary.simpleMessage("免登录进入"),
        "hard": MessageLookupByLibrary.simpleMessage("困难"),
        "hardInfo":
            MessageLookupByLibrary.simpleMessage("困难模式：2次失误机会，曲名或歌手或专辑填空"),
        "history": MessageLookupByLibrary.simpleMessage("历史记录"),
        "home": MessageLookupByLibrary.simpleMessage("主页"),
        "hot": MessageLookupByLibrary.simpleMessage("热门🔥"),
        "incorrect": MessageLookupByLibrary.simpleMessage("错误"),
        "installManually": MessageLookupByLibrary.simpleMessage("手动下载安装"),
        "installPerm": MessageLookupByLibrary.simpleMessage("安装应用权限"),
        "language": MessageLookupByLibrary.simpleMessage("语言"),
        "likes": MessageLookupByLibrary.simpleMessage("赞"),
        "loading": MessageLookupByLibrary.simpleMessage("加载中..."),
        "loggingIn": MessageLookupByLibrary.simpleMessage("登录中..."),
        "login": MessageLookupByLibrary.simpleMessage("登录"),
        "loginExpired": MessageLookupByLibrary.simpleMessage("登录已过期，请重新登录"),
        "me": MessageLookupByLibrary.simpleMessage("我"),
        "multiPlayer": MessageLookupByLibrary.simpleMessage("多人模式（敬请期待）"),
        "multiPlayerOptions": MessageLookupByLibrary.simpleMessage("多人模式选项"),
        "myPlaylists": MessageLookupByLibrary.simpleMessage("我的歌单"),
        "name": MessageLookupByLibrary.simpleMessage("这歌我熟"),
        "next": MessageLookupByLibrary.simpleMessage("下一题"),
        "noDes": MessageLookupByLibrary.simpleMessage("暂无简介"),
        "normal": MessageLookupByLibrary.simpleMessage("普通"),
        "normalInfo": MessageLookupByLibrary.simpleMessage(
            "普通模式：3次失误机会，曲名或歌手或专辑 4选1或有提示的填空"),
        "ntfPerm": MessageLookupByLibrary.simpleMessage("通知权限"),
        "ok": MessageLookupByLibrary.simpleMessage("确定👌"),
        "or": MessageLookupByLibrary.simpleMessage("或"),
        "password": MessageLookupByLibrary.simpleMessage("密码"),
        "permissionError": m2,
        "permissionExplain":
            MessageLookupByLibrary.simpleMessage("请授予通知权限，以防止软件更新时被系统结束进程"),
        "played": MessageLookupByLibrary.simpleMessage("玩过"),
        "pts": MessageLookupByLibrary.simpleMessage("分"),
        "quizResult": m3,
        "quizzes": MessageLookupByLibrary.simpleMessage("题"),
        "rank": MessageLookupByLibrary.simpleMessage("排行榜"),
        "recm": MessageLookupByLibrary.simpleMessage("推荐"),
        "register": MessageLookupByLibrary.simpleMessage("没有账号? 点此注册!"),
        "releaseDate": m4,
        "relogin": MessageLookupByLibrary.simpleMessage("重新登录"),
        "restart": MessageLookupByLibrary.simpleMessage("授权后请重启软件"),
        "retry": MessageLookupByLibrary.simpleMessage("重试"),
        "search": MessageLookupByLibrary.simpleMessage("搜索歌单、歌曲或歌手"),
        "setting": MessageLookupByLibrary.simpleMessage("设置"),
        "singlePlayer": MessageLookupByLibrary.simpleMessage("单人模式"),
        "singlePlayerOptions": MessageLookupByLibrary.simpleMessage("单人模式选项"),
        "songs": MessageLookupByLibrary.simpleMessage("歌曲"),
        "sort": MessageLookupByLibrary.simpleMessage("分类"),
        "start": MessageLookupByLibrary.simpleMessage("开始游戏"),
        "storagePerm": MessageLookupByLibrary.simpleMessage("文件读写"),
        "submit": MessageLookupByLibrary.simpleMessage("提交"),
        "tip": MessageLookupByLibrary.simpleMessage("提示: "),
        "unknownError": MessageLookupByLibrary.simpleMessage(
            "软件/服务器问题，请重试或联系hungryhenry101@outlook.com"),
        "update": m5,
        "versionCheckError": MessageLookupByLibrary.simpleMessage(
            "版本检查失败，请稍后再试或联系hungryhenry101@outlook.com"),
        "wearHeadphone": MessageLookupByLibrary.simpleMessage("请佩戴耳机以获得最佳体验"),
        "wrong": MessageLookupByLibrary.simpleMessage("错误❌")
      };
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import '/generated/l10n.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:install_plugin/install_plugin.dart';

const storage = FlutterSecureStorage();

///下载通知栏
class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> showProgressNotification({
    required int id,
    required String title,
    required String body,
    required int progress,
  }) async {
    if(!Platform.isAndroid && !Platform.isIOS) return;
    AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'download_channel', // 通知频道ID
      'Downloads', // 通知频道名称
      channelDescription: 'Shows download progress, and make sure not to be killed by system.',
      importance: Importance.low,
      priority: Priority.low,
      showProgress: true,
      maxProgress: 100,
      progress: progress,
      onlyAlertOnce: true,
    );

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: null,
    );
  }

  static Future<void> cancelNotification(int id) async {
    if(!Platform.isAndroid && !Platform.isIOS) return;
    await _notificationsPlugin.cancel(id);
  }

  static Future<void> cancelAll() async{
    if(!Platform.isAndroid && !Platform.isIOS) return;
    await _notificationsPlugin.cancelAll();
  }
}


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  Future<void>? _launched;
  final Uri _url2Launch = Uri(scheme: 'http', host: 'hungryhenry.xyz', path: 'blog/admin');
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';
  String _loginText = S.current.login;
  Logger logger = Logger();

  String? _currentVersion;
  String? _latestVesion;
  String? _changelog;
  String? _date;
  bool _force = false;

  int _progress = 0;
  double _speed = 0.0;
  final CancelToken _cancelToken = CancelToken();
  DateTime? _startTime;


  Future<bool> _checkUpdate() async {
    _loginText = S.current.checkingUpdate;
    Response res = await Dio().get('http://hungryhenry.xyz/rhythm_riddle/versions.json').catchError((e){
      logger.e("version check error: $e");
      showDialog(context: context, builder: (context){
        return AlertDialog(
          content: Text(S.current.unknownError),
          actions: [
            TextButton(onPressed: () {Navigator.pushNamed(context, '/login');}, child: Text(S.current.retry)),
            TextButton(onPressed: () {Navigator.of(context).pop(false);}, child: Text(S.current.ok)),
          ],
        );
      });
    });
    if(res.statusCode == 200){
      Map data = res.data;
      _latestVesion = data['latest']['version'];

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      _currentVersion = packageInfo.version;

      if(_latestVesion != _currentVersion && mounted){
        setState(() {
          _changelog = data['latest']['changlog'];
          _date = data['latest']['date'];
          if(data['latest']['force'] == true){
            _force = true;
          }
        });
        return true;
      }else{
        return false;
      }
    }else{
      logger.e("version check error: ${res.statusCode} ${res.data}");
      return false;
    }
  }

  Future<bool> _checkPermission(Permission permission) async {
    if (Platform.isAndroid) {
      var status = await permission.status;
      if (!status.isGranted) {
        // 申请权限
        await permission.request();
        // 重新获取权限状态
        var newStatus = await permission.status;
        if (newStatus.isGranted) {
          return true;
        } else {
          return false;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
  }

  Future<void> _downloadUpdate() async {
    if(await _checkPermission(Permission.storage)){
      final Directory tempDir = await path_provider.getTemporaryDirectory();
      String? savePath;
      String url = "";

      if(Platform.isAndroid){
        savePath = "${tempDir.path}/Rhythm-Riddle_$_latestVesion.apk";
        url = "http://hungryhenry.xyz/rhythm_riddle/rhythm_riddle_android_latest.apk";

        if(await _checkPermission(Permission.notification) == false){
          Fluttertoast.showToast(msg: S.current.permissionExplain);
        }
        await NotificationService.init();
      }else if(Platform.isWindows){
        savePath = "${tempDir.path}/Rhythm-Riddle_$_latestVesion.exe";
        url = "http://hungryhenry.xyz/rhythm_riddle/rhythm_riddle_windows_latest.exe";
      }else{
        if(!mounted) return;
        Navigator.of(context).pop();
        showDialog(context: context, builder: (context){
          return AlertDialog(
            content: Text(S.current.unknownError),
            actions: [
              TextButton(onPressed: () {Navigator.pushNamed(context, '/login');}, child: Text(S.current.retry)),
              TextButton(onPressed: () {Navigator.of(context).pop();}, child: Text(S.current.ok)),
            ],
          );
        });
      }

      logger.i("savePath: $savePath");
      if(savePath != null && url != ""){
        try{
          await Dio().download(
            url,
            savePath,
            cancelToken: _cancelToken,
            onReceiveProgress: (received, total){
              _startTime ??= DateTime.now(); // 如果starttime为null，则赋值为当前时间 :))))真高级
              Duration diff = DateTime.now().difference(_startTime!);

              if(mounted){
                setState(() {
                  _progress = ((received / total) * 100).toInt();
                  if(received > 0 && total > 0 && diff.inSeconds > 0){
                    _speed = (received / 1024 / 1024) / diff.inSeconds; // mb/s
                  }
                });
              }else{
                _progress = ((received / total) * 100).toInt();
                if(received > 0 && total > 0 && diff.inSeconds > 0){
                  _speed = (received / 1024 / 1024) / diff.inSeconds;
                }
              }

              NotificationService.showProgressNotification(
                id: 1, 
                title: S.current.dlUpdate, 
                body: "${S.current.downloading(_latestVesion!)} | ${_speed.toStringAsFixed(1)}mb/s", 
                progress: _progress
              );
            }
          );
          if(Platform.isAndroid){
            if(await _checkPermission(Permission.requestInstallPackages) == false){
              logger.e("request install packages permission error");
              if(mounted){
                setState(() {
                  _loginText = S.current.restart;
                });
                showDialog(context: context, builder: (context){
                  return AlertDialog(
                    content: Text(S.current.permissionError(S.current.installPerm)),
                    actions: [
                      TextButton(
                        onPressed: () async{
                          if(await _checkPermission(Permission.requestInstallPackages) == false){
                            Fluttertoast.showToast(msg: S.current.permissionError(S.current.installPerm));
                            Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                          }
                        },
                        child: Text(S.current.retry)
                      ),
                      TextButton(
                        onPressed: () {
                          _launchInBrowser(Uri(scheme: "http", host: "hungryhenry.xyz", path: "/rhythm_riddle/"));
                        },
                        child: Text(S.current.installManually)
                      )
                    ],
                  );
                });
              }
            }else{
              //安装apk
              if(await InstallPlugin.install(savePath) == false){
                logger.e("install apk error");
                if(mounted){
                  showDialog(context: context, builder: (context){
                    return AlertDialog(
                      content: Text(S.current.unknownError),
                      actions: [
                        TextButton(onPressed: () {Navigator.pushNamed(context, '/login');}, child: Text(S.current.retry)),
                        TextButton(onPressed: () {Navigator.of(context).pop(false);}, child: Text(S.current.ok)),
                      ],
                    );
                  });
                }
              }
            }
          }else{
            //win
            Process process = await Process.start(savePath, [], mode: ProcessStartMode.detached);
            logger.i("start process: $process");
            exit(0);
          }
        }catch(e){
          if(e is! DioException){
            logger.e("download error: $e");
            NotificationService.cancelAll();
            if(mounted){
              await showDialog(context: context, builder: (context){
                return AlertDialog(
                  content: Text(S.current.unknownError),
                  actions: [
                    TextButton(onPressed: () {Navigator.pushNamed(context, '/login');}, child: Text(S.current.retry)),
                    TextButton(onPressed: () {Navigator.of(context).pop(false);}, child: Text(S.current.ok)),
                  ],
                );
              });
            }
          }else{
            logger.e("download error: ${e.message}");
            NotificationService.cancelAll();
            if(mounted){
              await showDialog(context: context, builder: (context){
                return AlertDialog(
                  content: Text(S.current.unknownError),
                  actions: [
                    TextButton(onPressed: () {Navigator.pushNamed(context, '/login');}, child: Text(S.current.retry)),
                    TextButton(onPressed: () {Navigator.of(context).pop(false);}, child: Text(S.current.ok)),
                  ],
                );
              });
            }
          }
        }
        NotificationService.cancelNotification(1);
      }else{
        logger.e('savePath or url is null');
        if(mounted){
          await showDialog(context: context, builder: (context){
            return AlertDialog(
              content: Text(S.current.unknownError),
              actions: [
                TextButton(onPressed: () {Navigator.pushNamed(context, '/login');}, child: Text(S.current.retry)),
                TextButton(onPressed: () {Navigator.of(context).pop(false);}, child: Text(S.current.ok)),
              ],
            );
          });
        }
      }
    }else{
      if(mounted){
        setState(() {
          _loginText = S.current.restart;
        });
        showDialog(context: context, builder: (context){
          return AlertDialog(
            content: Text(S.current.permissionError(S.current.storagePerm)),
            actions: [
              TextButton(
                onPressed: () async{
                  Navigator.of(context).pushNamed('/login');
                },
                child: Text(S.current.retry)
              ),
              TextButton(
                onPressed: (){
                  Navigator.of(context).pop(false);
                  openAppSettings();
                },
                child: Text(S.current.ok)
              )
            ],
          );
        });
      }
    }
  }

  Future<void> login(String username, String password, BuildContext context) async {
    setState(() {
      _loginText = S.current.loggingIn;
    });
    try{
      final response = await http.post(
        Uri.parse('http://hungryhenry.xyz/api/login.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
        })
      ).timeout(const Duration(seconds:7));

      if(!mounted) return;

      if (response.statusCode == 200) {
        // LET'S GOOOOOO
        await storage.write(key: 'uid', value: jsonDecode(response.body)['data']['uid'].toString());
        await storage.write(key: 'password', value: jsonDecode(response.body)['data']['password']);
        await storage.write(key: 'username', value: jsonDecode(response.body)['data']['username']);
        await storage.write(key: 'mail', value: jsonDecode(response.body)['data']['mail']);

        DateTime now = DateTime.now();
        String formattedDate = DateFormat('yyyy-MM-dd').format(now);
        await storage.write(key: 'date', value: formattedDate);
        Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
      } else if (response.statusCode == 401) {
        // 验证错误
        if(mounted){
          setState(() {
            _errorMessage = S.current.emailOrName + S.current.or + S.current.password + S.current.incorrect;
            _loginText = S.current.login;
          });
        }
      } else {
        // 未知错误
        if(mounted){
          setState((){
            _loginText = S.current.login;
          });
          await showDialog(context: context, builder: (context){
            return AlertDialog(
              content: Text(S.current.unknownError),
              actions: [
                TextButton(onPressed: () {Navigator.pushNamed(context, '/login');}, child: Text(S.current.retry)),
                TextButton(onPressed: () {Navigator.of(context).pop(false);}, child: Text(S.current.ok)),
              ],
            );
          });
        }
      }
    }catch (e){
      logger.e("login error $e");
      if(mounted){
        setState(() {
          _loginText = S.current.login;
        });
        if(e is TimeoutException){
          if(!mounted){
            logger.e("login timeout");
          }else{
            await showDialog(context: context, builder: (context){
              return AlertDialog(
                content: Text(S.current.connectError),
                actions: [
                  TextButton(onPressed: () {Navigator.pushNamed(context, '/login');}, child: Text(S.current.retry)),
                  TextButton(onPressed: () {Navigator.of(context).pop(false);}, child: Text(S.current.ok)),
                ],
              );
            });
          }
        }else{
          if(mounted){
            await showDialog(context: context, builder: (context){
              return AlertDialog(
                content: Text(S.current.unknownError),
                actions: [
                  TextButton(onPressed: () {Navigator.pushNamed(context, '/login');}, child: Text(S.current.retry)),
                  TextButton(onPressed: () {Navigator.of(context).pop(false);}, child: Text(S.current.ok)),
                ],
              );
            });
          }else{
            logger.e("login error: $e");
          }
        }
      }
    }
  }

  Future<void> _launchInBrowser(Uri url) async {
      if (!await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      ) && mounted) {
        showDialog(context: context, builder: (context){
          return AlertDialog(
            content: Text(S.current.unknownError),
            actions: [
              TextButton(onPressed: () {Navigator.pushNamed(context, '/login');}, child: Text(S.current.retry)),
              TextButton(onPressed: () {Navigator.of(context).pop(false);}, child: Text(S.current.ok)),
            ],
          );
        });
      }
  }

  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      final String username = _emailController.text;
      final String password = _passwordController.text;

      if (username.isNotEmpty && password.isNotEmpty) {
        login(username, password, context);
      }
    }
  }


  Future<void> loginUsingStorage() async {
    String? username = await storage.read(key: 'username');
    String? password = await storage.read(key: 'password');
    String? date = await storage.read(key: 'date');
    DateTime now = DateTime.now();
    if(date != null && mounted){
      //如果storage中的日期在现在的7天前
      if(now.difference(DateTime.parse(date)).inDays < 7){
        if (username != null && password != null) {
          login(username, password, context);
        }
      }else{
        await showDialog(context: context, builder: (context){
          return AlertDialog(
              content: Text(S.current.loginExpired),
              actions: [
                TextButton(onPressed: () async {
                  _emailController.text = username!;
                  await storage.delete(key: 'username');
                  await storage.delete(key: 'password');
                  await storage.delete(key: 'date');
                  Navigator.of(context).pop(false);
                }, child: Text(S.current.relogin)),
                TextButton(onPressed: () {Navigator.of(context).pop(false);}, child: Text(S.current.cancel)),
              ],
          );
        });
      }
    }
  }

  Widget _buildLoginPage() {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 500
      ),
      child:Form(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25, bottom:20),
              child: Text(
                _loginText,
                style: const TextStyle(fontSize: 42),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    // Email TextField
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: S.current.emailOrName,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return S.current.emptyemail;
                        }
                        if(_errorMessage != ''){
                          return '';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Password TextField
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: S.current.password,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return S.current.emptypassword;
                        }
                        if(_errorMessage != ''){
                          return _errorMessage;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height:10),

                    //register
                    TextButton(
                      onPressed: () => setState(() {
                        _launched = _launchInBrowser(_url2Launch);
                      }),
                      style:ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(const Color.fromARGB(0, 0, 0, 0)),
                      ),
                      child: Text(
                        S.current.register,
                        style: const TextStyle(fontSize: 14),
                      )
                    ),

                    // 登录按钮
                    SizedBox(
                      width:150,
                      child: ElevatedButton(
                        onPressed: (){
                          if(_loginText != S.current.loggingIn){
                            _login();
                          }
                        },
                        child: Text(S.current.login),
                      )
                    ),

                    Text(
                      S.current.or,
                      style: const TextStyle(fontSize: 12),
                    ),

                    // 免登录进入
                    SizedBox(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(const Color.fromARGB(166, 151, 151, 151)),
                        ),
                        onPressed: (){Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);},
                        child: Text(
                          S.current.guest,
                          style:const TextStyle(
                            color: Colors.white,
                            fontSize: 12
                            ),
                          ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadPage() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: min(500, MediaQuery.of(context).size.width - 20)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            S.current.downloading(_latestVesion!),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          LinearProgressIndicator(
            value: _progress / 100,
            backgroundColor: Colors.grey[300],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Text(
                "$_progress%",
              ),
              const Spacer(),
              Text(
                "${_speed.toStringAsFixed(1)}mb/s",
              )
            ],
          ),
          const SizedBox(height: 20),
          TextButton(
            child: Text(_startTime == null ? "${S.current.cancel}ing..." : S.current.cancel),
            onPressed: (){
              if(_startTime != null){
                setState(() {
                  _startTime = null;
                  _progress = 0;
                  _speed = 0.0;
                  _loginText = S.current.login;
                });
              _cancelToken.cancel();
              }
            },
          )
        ]
      ),
    );
  }

  @override
  void initState(){
    super.initState();
    _checkUpdate().then((needUpdate) {
      if(needUpdate){
        showDialog(
          context: context,
          barrierDismissible: false, // 禁止点击对话框外部关闭
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0), // 圆角样式
              ),
              title: Text(
                S.current.update(_currentVersion!, _latestVesion!),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              content: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 300),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        (_changelog ?? "") + "\n" + S.current.releaseDate(_date!),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if(!_force)...[
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // 关闭对话框
                          loginUsingStorage();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[400],
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          S.current.cancel,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 16.0,
                          ),
                        ),
                      )
                    ],
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _loginText = S.current.downloading(_latestVesion!);
                        });
                        // 执行更新逻辑
                        Navigator.of(context).pop();
                        _downloadUpdate();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // 突出显示立即更新按钮
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        S.current.dlUpdate,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
        );
      }else{
        setState(() {
          _loginText = S.current.login;
        });
        loginUsingStorage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: _startTime == null ? _buildLoginPage() : _buildDownloadPage(),
        ),
      ),
    );
  }
}
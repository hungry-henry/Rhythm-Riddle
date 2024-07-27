import 'package:flutter/material.dart';
import '../generated/l10n.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<void>? _launched;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';
  String loginText = S.current.login;
  
  
  Future<void> login(String username, String password, BuildContext context) async {
    setState(() {
      loginText = S.current.loggingIn;
    });
    final response = await http.post(
      Uri.parse('http://hungryhenry.xyz/api/login.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if(!context.mounted) return;

    if (response.statusCode == 200) {
      // LET'S GOOOOOO
      await storage.write(key: 'username', value: username);
      await storage.write(key: 'password', value: password);
      Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => route == null);
    } else if (response.statusCode == 401) {
      // 验证错误
      setState(() {
        _errorMessage = S.current.emailOrName + S.current.or + S.current.password + S.current.incorrect;
        loginText = S.current.login;
      });
    } else {
      // 未知错误
      setState((){
        _errorMessage = S.current.unknownError;
        loginText = S.current.login;
      });
    }
  }

  Future<void> _launchInBrowser(Uri url) async {
      if (!await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      )) {
        throw Exception('Could not launch $url');
      }
  }
  // Function to handle login logic
  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      final String username = _emailController.text;
      final String password = _passwordController.text;

      if (username.isNotEmpty && password.isNotEmpty) {
        login(username, password, context);
      }
    }
  }

  void _guest(){
    Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => route == null);
  }

  Future<void> loginUsingStorage() async {
    String? username = await storage.read(key: 'username');
    String? password = await storage.read(key: 'password');
    if (username != null && password != null) {
      login(username, password, context);
    }
  }
  @override
  void initState(){
    super.initState();
    loginUsingStorage();
  }

  @override
  Widget build(BuildContext context) {
    final Uri toLaunch = Uri(scheme: 'http', host: 'hungryhenry.xyz', path: 'blog/admin');
  return Scaffold(
    backgroundColor: Colors.white,
    body: Center(
      child: Form(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25, bottom:20),
              child: Text(
                loginText,
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
                        _launched = _launchInBrowser(toLaunch);
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
                        onPressed: _login,
                        child: Text(loginText),
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
                        onPressed: _guest,
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
    ),
  );
}
}
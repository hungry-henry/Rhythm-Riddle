import 'package:flutter/material.dart';
import '../generated/l10n.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> login(String username, String password) async {
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

  if (response.statusCode == 200) {
    // Handle successful login
    print('Login successful: ${response.body}');
  } else {
    // Handle error
    print('Login failed: ${response.body}');
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  // Function to handle login logic
  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      final String username = _emailController.text;
      final String password = _passwordController.text;

      if (username.isNotEmpty && password.isNotEmpty) {
        login(username, password);
      }
    }
  }

  void _guest(){
    //blahbalh
  }

  @override
  Widget build(BuildContext context) {
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
                S.current.login,
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
                        labelText: S.current.email,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return S.current.emptyemail;
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
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // 登录按钮
                    SizedBox(
                      width:200,
                      child: ElevatedButton(
                        onPressed: _login,
                        child: Text(S.current.login),
                      )
                    ),

                    const Text(
                      "或",
                      style: TextStyle(fontSize: 14),
                    ),
                    // 免登录进入
                    SizedBox(
                      width:200,
                      child: ElevatedButton(
                        onPressed: _guest,
                        child: Text(S.current.guest),
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
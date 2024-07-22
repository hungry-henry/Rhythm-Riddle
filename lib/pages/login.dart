import 'package:flutter/material.dart';
import '../generated/l10n.dart';

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
      // Perform login action
      // For demonstration, we will just print the credentials
      print('${S.current.email}: ${_emailController.text}');
      print('${S.current.password}: ${_passwordController.text}');
      // You can add your login logic here, such as making an API call
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
              padding: EdgeInsets.only(left: 25, bottom:20),
              child: Text(
                S.current.login,
                style: TextStyle(fontSize: 42),
              ),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
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
                    SizedBox(height: 20),

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
                    SizedBox(height: 20),

                    // 登录按钮
                    SizedBox(
                      width:200,
                      child: ElevatedButton(
                        onPressed: _login,
                        child: Text(S.current.login),
                      )
                    ),

                    Text(
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
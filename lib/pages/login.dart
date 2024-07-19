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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Email TextField
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: S.current.email,
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your email';
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
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // Login Button
                ElevatedButton(
                  onPressed: _login,
                  child: Text(S.current.login),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

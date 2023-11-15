import 'package:flutter/material.dart';
import 'package:flutter_learning/auth_service/service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Whatsapp Login"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _email,
                  decoration: const InputDecoration(
                      labelText: 'UserName',
                      hintText: 'Enter UserName',
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 10))),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _password,
                  decoration: const InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter password',
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 10))),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () async {
                    var data = {
                      "username": _email.text,
                      "password": _password.text,
                    };
                    await AuthService().LoginApi(context, data);
                  },
                  child: Text("Submit")),
            ],
          )
        ],
      ),
    );
  }
}

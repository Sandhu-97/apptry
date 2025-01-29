import 'package:apptry/backend/auth.dart';
import 'package:apptry/components/button.dart';
import 'package:apptry/components/input_field.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Shri Guru Har Rai Ji Cold Store",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              InputField(controller: _emailController, label: "Email"),
              InputField(controller: _passwordController, label: "Password"),
              Button(
                label: "Signup",
                onPressed: () async {
                  try {
                    String message = await createUser(
                        _emailController.text, _passwordController.text);
                    if (message != "success") {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(message),
                      ));
                      return;
                    }
                    Navigator.popAndPushNamed(context, 'home');
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("User created successfully!"),
                    ));
                  } catch (e) {
                    print(e);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

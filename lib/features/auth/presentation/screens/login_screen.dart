import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                onChanged: (value) => _email = value,

                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16.0),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                onChanged: (value) => _password = value,

                obscureText: true,
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: _email,
                      password: _password,
                    );
                    // Navigate to the appropriate screen after successful login
                    // For example: context.go('/dashboard');
                  } on FirebaseAuthException catch (e) {
                    String message = 'Login failed. Please try again.';
                    if (e.code == 'user-not-found') {
                      message = 'No user found for that email.';
                    } else if (e.code == 'wrong-password') {
                      message = 'Wrong password provided for that user.';
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(message)),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('An error occurred: ${e.toString()}')),
                    );
                  }
                },
                child: const Text('Login'),
              ),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  context.go('/register');
                },
                child: const Text("Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  late String _email;
  late String _password;
}

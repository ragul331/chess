import 'package:chess/pages/player_mode.dart';
import 'package:chess/pages/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  TextEditingController mailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  String wrongText = '';
  late dynamic credentials;

  Future<void> login(ScaffoldMessengerState scaffoldMessenger,
      NavigatorState navigator) async {
    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: mailController.text.trim(),
        password: passController.text,
      );
      navigator.pushReplacement(MaterialPageRoute(builder: (context) {
        return const PlayerMode();
      }));
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-login-credentials':
          // Display an error message to the user.
          scaffoldMessenger.showSnackBar(
            const SnackBar(
              content: Text('Invalid login credentials. Please try again.'),
            ),
          );
          break;
        case 'user-disabled':
          // Display an error message to the user.
          scaffoldMessenger.showSnackBar(
            const SnackBar(
              content: Text(
                  'Your account has been disabled. Please contact support for assistance.'),
            ),
          );
          break;
        case 'user-not-found':
          // Display an error message to the user.
          scaffoldMessenger.showSnackBar(
            const SnackBar(
              content: Text(
                  'The user account does not exist. Please create an account.'),
            ),
          );
          break;
        case 'wrong-password':
          // Display an error message to the user.
          scaffoldMessenger.showSnackBar(
            const SnackBar(
              content: Text('The password is incorrect. Please try again.'),
            ),
          );
          break;
        default:
          // Handle other errors here.
          scaffoldMessenger.showSnackBar(
            const SnackBar(
              content:
                  Text('An unknown error occurred. Please try again later.'),
            ),
          );
      }
    }
  }

  Future<void> forgotPass() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: mailController.text,
      );
      setState(() {
        wrongText = 'Verify mail';
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          wrongText = 'User not found';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final size = MediaQuery.of(context).size;
    final border = OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.black,
      ),
      borderRadius: BorderRadius.circular(30),
    );
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: size.width > 400 ? 350 : size.width,
            height: size.width > 400 ? 600 : size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.grey[600]!,
                  Colors.grey[600]!,
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  TextField(
                    controller: mailController,
                    decoration: InputDecoration(
                      hintText: 'Enter Email',
                      enabledBorder: border,
                      focusedBorder: border,
                      filled: true,
                      fillColor: Colors.grey[300],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: passController,
                    obscureText: true,
                    decoration: InputDecoration(
                      helperText: wrongText,
                      helperStyle: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                      hintText: 'Enter PassWord',
                      enabledBorder: border,
                      focusedBorder: border,
                      filled: true,
                      fillColor: Colors.grey[300],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    style: ButtonStyle(
                      textStyle: const MaterialStatePropertyAll(
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      side: const MaterialStatePropertyAll(
                          BorderSide(color: Colors.black)),
                      minimumSize: const MaterialStatePropertyAll(
                        Size(100, 45),
                      ),
                      backgroundColor: MaterialStatePropertyAll(
                        Colors.grey[300],
                      ),
                    ),
                    onPressed: () {
                      login(scaffoldMessenger,navigator);
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  TextButton(
                    style: const ButtonStyle(
                      textStyle: MaterialStatePropertyAll(
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ),
                    onPressed: forgotPass,
                    child: const Text(
                      'Forget Password',
                      style: TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  TextButton(
                    style: const ButtonStyle(
                      textStyle: MaterialStatePropertyAll(
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return const RegisterPage();
                      }));
                    },
                    child: const Text(
                      'New User?Register',
                      style: TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

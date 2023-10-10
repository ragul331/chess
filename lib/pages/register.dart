import 'package:chess/pages/login.dart';
import 'package:chess/pages/player_mode.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String wrongText = '';
  TextEditingController mailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  final playerRef = FirebaseDatabase.instance.ref('players');
  void signUp(NavigatorState navigator) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: mailController.text,
        password: passController.text,
      );
      String mail = santizedMail(mailController.text);
      playerRef.update({
        mail: {
          'mail': mailController.text,
          'name': nameController.text,
          'board': ['dummy'],
          'challenge': [
            ['admin@vsbec.com', true]
          ],
        }
      });
      navigator.pushReplacement(MaterialPageRoute(builder: (context) {
        return const PlayerMode();
      }));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(() {
          wrongText = 'weak password';
        });
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          wrongText = 'Email already in use';
        });
      }
    }
  }

  String santizedMail(String mail) {
    String removed = '';
    for (int i = 0; i < mail.length; i++) {
      if (mail[i] == '.') {
        continue;
      } else {
        removed += mail[i];
      }
    }
    return removed;
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    final border = OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.black,
      ),
      borderRadius: BorderRadius.circular(30),
    );
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: size.width > 400 ? 350 : size.width,
          height: size.height,
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
                const SingleChildScrollView(
                  child: Column(
                    children: [],
                  ),
                ),
                const Text(
                  'Register Page',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: mailController,
                  decoration: InputDecoration(
                    hintText: 'Enter Email',
                    helperText: wrongText,
                    helperStyle: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                    enabledBorder: border,
                    focusedBorder: border,
                    filled: true,
                    fillColor: Colors.grey[300],
                  ),
                ),
                TextField(
                  controller: passController,
                  obscureText: true,
                  decoration: InputDecoration(
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
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter Name',
                    enabledBorder: border,
                    focusedBorder: border,
                    filled: true,
                    fillColor: Colors.grey[300],
                  ),
                ),
                const SizedBox(
                  height: 10,
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
                      Size(100, 53),
                    ),
                    backgroundColor: MaterialStatePropertyAll(
                      Colors.grey[300],
                    ),
                  ),
                  onPressed: () {
                    return signUp(navigator);
                  },
                  child: const Text(
                    'Register',
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
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return const LogIn();
                        },
                      ),
                    );
                  },
                  child: const Text(
                    'Already a user Login',
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
    );
  }
}

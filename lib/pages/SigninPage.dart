import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helmetdetect/utilities/CustomSnackbar.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SiginInPageState();
}

class _SiginInPageState extends State<SigninPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isSigninLoading = false;
  String signinMessage = '';
  Future<bool> signinWithEmailAndPassword(email, password) async {

    isSigninLoading = true;
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      // signinMessage = "Successfully Signin";
      isSigninLoading = false;
      setState(() {});
      return true;
    } catch (e) {
      if (e is FirebaseAuthException) {
        signinMessage = e.message.toString();
      } else {
        signinMessage = e.toString();
      }
      isSigninLoading = false;
      setState(() {});
      return false;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(45, 50, 45, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Aligns children in the center vertically
              children: [
                Text("Sign in",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                const Text(
                  "Enter your email and password to continue",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, color: Colors.grey),
                ),
                const SizedBox(height: 20),

                //Email Text Field
                Container(
                  padding: const EdgeInsets.only(left: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromRGBO(237, 237, 237, 1),
                  ),
                  child: TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Email",
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Password Text Field
                Container(
                  padding: const EdgeInsets.only(left: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromRGBO(237, 237, 237, 1),
                  ),
                  child: TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Password",
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Forgot Password Button
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/forgotPassword');
                    },
                    child: const Text('Forgot Password'),
                  )
                ]),
                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Aligns children in the center horizontally
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          child: Text("Signin"),
                          onPressed: () async {
                            bool isSignin = await signinWithEmailAndPassword(
                                emailController.text, passwordController.text);
                            ScaffoldMessenger.of(context).showSnackBar(
                                customSnackbar(
                                    signinMessage,
                                    isSignin
                                        ? Theme.of(context).primaryColor
                                        : Colors.red));
                            if (isSignin) {
                              Navigator.pushReplacementNamed(
                                  context, '/home');
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );

  }
}

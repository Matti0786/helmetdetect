import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utilities/CustomSnackbar.dart';


class ForgotPasswordPage extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  String _resetPasswordMessage = "";

  Future<bool> _resetPassword(email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _resetPasswordMessage = "Password reset send successfully to $email";
      return true;
    } on FirebaseAuthException catch (e) {
      _resetPasswordMessage = e.message.toString();
      return false;
    }
  }

  ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(60),
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Reset Your Password",
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.only(left: 15),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                      color: Color.fromRGBO(237, 237, 237, 1)),
                  child: TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: "Email",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                    onPressed: () async {
                      bool isReset = await _resetPassword(emailController.text);
                      ScaffoldMessenger.of(context).showSnackBar(
                        customSnackbar(
                            _resetPasswordMessage,
                            isReset
                                ? Theme.of(context).primaryColor
                                : Colors.red),
                      );
                      if (isReset) {
                        Navigator.pushReplacementNamed(context, '/signin');
                      }
                    },
                    child: const Text("Send Email")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

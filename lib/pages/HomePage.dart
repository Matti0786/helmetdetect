import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helmetdetect/utilities/CustomSnackbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void signOutUser() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, 'signin');
      ScaffoldMessenger.of(context)
          .showSnackBar(customSnackbar("Signout Successfully", Colors.green));
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(customSnackbar(e, Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            "Helmet Detector",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacementNamed(context, '/signin');
                    ScaffoldMessenger.of(context).showSnackBar(customSnackbar(
                        "Signout Successfully",
                        Theme.of(context).primaryColor));
                  } catch (e) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(customSnackbar(e, Colors.red));
                  }
                },
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ))
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/dummy');
                },
                child: Text("Open Camera"),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/defaulterList');
                },
                child: Text("Defaulter List"),
              ),
            ],
          ),
        ));
  }
}

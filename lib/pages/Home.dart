import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utilities/CustomSnackbar.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "SafeWay",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/signin');
                ScaffoldMessenger.of(context).showSnackBar(customSnackbar(
                    "Signout Successfully", Theme.of(context).primaryColor));
              } catch (e) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(customSnackbar(e, Colors.red));
              }
            },
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              // Optional: adjust the radius as needed
              bottomLeft: Radius.circular(0),
              // Adjust this radius to control the circular effect
              bottomRight: Radius.circular(
                  0), // Adjust this radius to control the circular effect
            ),
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Image.asset(
                'assets/images/bg.jpg', // Replace with your image path
                height: MediaQuery.of(context).size.height * 0.45,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/predictionPage');
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  colors: [Colors.deepPurpleAccent, Colors.deepPurple.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),
              child: Text(
                'Predictions',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/defaulterList');
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  colors: [Colors.deepPurpleAccent, Colors.deepPurple.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),
              child: Text(
                'Defaulters',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

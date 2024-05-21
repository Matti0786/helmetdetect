import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:helmetdetect/pages/Camera.dart';
import 'package:helmetdetect/pages/CameraPage.dart';
import 'package:helmetdetect/pages/Dummy.dart';
import 'package:helmetdetect/pages/ForgotPasswordPage.dart';
import 'package:helmetdetect/pages/HomePage.dart';
import 'package:helmetdetect/pages/SigninPage.dart';

import 'firebase_options.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(HelmetDetector(camera: firstCamera));
}

class HelmetDetector extends StatelessWidget {
  final CameraDescription camera;

  const HelmetDetector({Key? key, required this.camera}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        // '/':(context)=>SigninPage(),
        // '/':(context)=>Camera(),
        '/':(context)=> Dummy(),
        '/signin':(context)=>SigninPage(),
        '/home':(context)=>HomePage(),
        '/forgotPassword':(context)=>ForgotPasswordPage(),
        '/camera':(context)=>CameraPage(camera: camera),



      },
    );
  }
}



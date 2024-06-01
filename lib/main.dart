import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:helmetdetect/pages/Camera.dart';
import 'package:helmetdetect/pages/CameraPage.dart';
import 'package:helmetdetect/pages/DateFilter.dart';
import 'package:helmetdetect/pages/DefaulterList.dart';
import 'package:helmetdetect/pages/Dummy.dart';
import 'package:helmetdetect/pages/ForgotPasswordPage.dart';
import 'package:helmetdetect/pages/Home.dart';

import 'package:helmetdetect/pages/PredictionPage.dart';
import 'package:helmetdetect/pages/SigninPage.dart';
import 'package:helmetdetect/pages/SingleImageDetector.dart';

import 'firebase_options.dart';

void main() async {
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
        // '/': (context) => HomePage(),
        '/': (context) => Home(),
        '/home': (context) => Home(),
        '/signin': (context) => SigninPage(),
        '/forgotPassword': (context) => ForgotPasswordPage(),
        '/defaulterList': (context) => Datefilter(),
        '/singleImagePrediction': (context) => SingleImageDetector(),
        '/predictionPage': (context) => PredictionPage(),

        // '/camera':(context)=>CameraPage(camera: camera),
      },
    );
  }
}

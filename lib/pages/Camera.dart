import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_pytorch/flutter_pytorch.dart';
import 'package:flutter_pytorch/pigeon.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:helmetdetect/pages/DefaulterList.dart';
import 'package:helmetdetect/utilities/CustomSnackbar.dart';

class CameraApp extends StatefulWidget {
  final CameraDescription camera;

  const CameraApp({
    Key? key,
    required this.camera,
  }) : super(key: key);

  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  File? _image;
  late CameraController _controller;
  late Timer _timer;
  int count = 0;

  @override
  void initState() {
    super.initState();
    // Initialize the camera controller
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    // Start the camera controller
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
      // Start the timer to capture pictures every 5 seconds
      _timer = Timer.periodic(Duration(seconds: 5), (timer) {
        _capturePicture();
      });
    });
  }

  late ClassificationModel classificationModel;

  Future loadModel() async {
    // classificationModel = await FlutterPytorch.loadClassificationModel(
    //     "assets/models/best.pt", 224, 224,
    //     labelPath: "assets/labels/lebels.txt");
    ModelObjectDetection objectModel =
        await FlutterPytorch.loadObjectDetectionModel(
            "assets/models/best.torchscript", 80, 640, 640,
            labelPath: "assets/labels/lebels.txt");
    return objectModel;
  }

  classifyImage(XFile image) async {
    loadModel().then((value) async {
      // print('Predictiong');
      // // String? prediction = await value.getImagePrediction(await File('assets/images/OIP.jpeg').readAsBytesSync());
      // String prediction = await value.getImagePrediction(await image.readAsBytes());
      //
      // // print(image!.path);
      // print(prediction);

      List<ResultObjectDetection?> objDetect = await value.getImagePrediction(
          await File('assets/images/OIP.jped').readAsBytes(),
          minimumScore: 0.1,
          IOUThershold: 0.3);
      print("Detecteddd");
      print(objDetect);
    });
    setState(() {});
  }

  //
  @override
  void dispose() {
    // Dispose of the camera controller and cancel the timer
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  //Firebase Storage

  Future<void> _uploadImage(XFile _image) async {
    // if (_image == null) return;

    try {
      // Create a reference to the Firebase Storage
      final storageRef = FirebaseStorage.instance.ref();

      // Create a reference to "uploads/filename"
      final imageRef = storageRef
          .child("uploads/${DateTime.now().millisecondsSinceEpoch}.jpg");

      // Upload the file to Firebase Storage
      UploadTask uploadTask = imageRef.putFile(File(_image!.path));

      // Get the download URL
      final downloadURL = await (await uploadTask).ref.getDownloadURL();

      // Use the download URL as needed
      print("Download URL: $downloadURL");

      // Optionally, show a snackbar or dialog to indicate success
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Upload complete!")));
      customSnackbar("Uploaded", Colors.green);
    } catch (e) {
      // Handle errors
      customSnackbar("Failed", Colors.red);
      // print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Upload failed: $e")));
    }
  }

  Future<void> _capturePicture() async {
    if (!_controller.value.isInitialized) {
      return;
    }
    // Construct the file path
    final path = DateTime.now().millisecondsSinceEpoch.toString();
    try {
      // Attempt to take a picture and save it to the specified path
      await _controller.takePicture().then((value) {
        print('Image is captured');
        _uploadImage(value).then((value) {
          print("Image is Uploaded");
        });
        // Now there integrate a Model that will take image and give prediction that helmet is wearing or not

        print(value);
        // classifyImage(value);
        // value.saveTo('path');
      });
    } catch (e) {
      print('Error capturing picture: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Container();
    }
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Camera'),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_outlined)),
        ),
        body: Column(
          children: [
            CameraPreview(_controller),
          ],
        ),
      ),
    );
  }
}

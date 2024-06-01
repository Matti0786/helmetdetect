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
import 'package:http/http.dart' as http;

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

  //
  @override
  void dispose() {
    // Dispose of the camera controller and cancel the timer
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  //Firebase Storage

  Future<void> _saveImageToDatabase(XFile _image) async {
    if (_image == null) return;

    try {
      // Create a reference to the Firebase Storage
      final storageRef = FirebaseStorage.instance.ref();

      // Create a reference to "uploads/filename"
      final imageRef = storageRef.child("uploads/${DateTime.now()}.jpg");

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

  Future<void> _detectHelmet(value) async {
    _saveImageToDatabase(value).then((_) {
      print("Saved**************");
    });
    final bytes = await value.readAsBytes();
    String base64Image = base64Encode(bytes);
    String url = 'http://192.168.0.113:5000/upload';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({'image': base64Image}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        bool withoutHelmetDetected = responseBody['without_helmet_detected'];
        print('withoutHelmetDetected: $withoutHelmetDetected');
        if (withoutHelmetDetected) _saveImageToDatabase(value);
      } else {
        print('Failed to upload image');
        print(response.body);
      }
    } catch (e) {
      print('Error: $e');
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
      await _controller.takePicture().then((value) async {
        // Now there integrate a Model that will take image and give prediction that helmet is wearing or not
        _detectHelmet(value);
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
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            'Camera',
            style: TextStyle(color: Colors.white),
          ),
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

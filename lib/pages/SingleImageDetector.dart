import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class SingleImageDetector extends StatefulWidget {
  @override
  _SingleImageDetectorState createState() => _SingleImageDetectorState();
}

class _SingleImageDetectorState extends State<SingleImageDetector> {
  XFile? _imageFile;
  final picker = ImagePicker();
  String prediction = '';
  bool predicting = false;

  Future<void> pickImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          _imageFile = pickedFile;
        } else {
          print('No image selected.');
        }
      });
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> uploadImage() async {
    setState(() {
      predicting = true;
    });

    if (_imageFile == null) return;

    try {
      final bytes = await _imageFile!.readAsBytes();
      String base64Image = base64Encode(bytes);

      // Use 10.0.2.2 for Android Emulator to connect to localhost
      String url = 'http://10.13.42.129:5000/upload';

      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({'image': base64Image}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        bool withoutHelmetDetected = responseBody['without_helmet_detected'];
        print('withoutHelmetDetected: $withoutHelmetDetected');
        setState(() {
          predicting = false;
          if (withoutHelmetDetected)
            prediction = 'Not Wearing Helmet';
          else if (!withoutHelmetDetected)
            prediction = 'Wearing Helmet';
          else
            prediction = 'Not Detected';
        });
      } else {
        print('Failed to upload image');
        print(response.body);
      }
    } catch (e) {
      print('Error uploading image: $e');
      predicting = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _imageFile == null
                ? Text('No image selected.')
                : Image.file(File(_imageFile!.path)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: pickImage,
              child: Text('Pick Image'),
            ),
            SizedBox(height: 20),
            predicting
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: uploadImage,
                    child: Text('Upload Image'),
                  ),
            Text(prediction)
          ],
        ),
      ),
    );
  }
}

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

  Future<void> _detectHelmet() async {
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
        setState(() {
          prediction = 'Something went wrong';
        });
      }
    } catch (e) {
      setState(() {
        predicting = false;
        prediction = 'Something went wrong';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'Image Upload',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _imageFile == null
                  ? Text('No image selected.')
                  : Image.file(File(_imageFile!.path)),
              SizedBox(height: 20),
              InkWell(
                onTap: pickImage,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      colors: [
                        Colors.deepPurpleAccent,
                        Colors.deepPurple.shade700
                      ],
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
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 13),
                  child: Text(
                    'Select Image',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              predicting
                  ? CircularProgressIndicator()
                  : InkWell(
                      onTap: _detectHelmet,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(
                            colors: [
                              Colors.deepPurpleAccent,
                              Colors.deepPurple.shade700
                            ],
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 80, vertical: 13),
                        child: Text(
                          'Predict',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
              SizedBox(height: 20),
              prediction == ""
                  ? Text("")
                  : Text(
                      "Results are: $prediction",
                      style: TextStyle(fontSize: 20),
                    ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}

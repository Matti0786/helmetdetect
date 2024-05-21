// import 'dart:html';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'package:flutter_pytorch/flutter_pytorch.dart';
import 'package:image_picker/image_picker.dart';


class CameraPage extends StatefulWidget {
  final CameraDescription camera;

  const CameraPage({Key? key, required this.camera}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}
 
class _CameraScreenState extends State<CameraPage> {

  List? _outputs;
  XFile? _image ;
  bool _loading = false;


  late ClassificationModel classificationModel;
  Future loadModel()async{
    classificationModel = await FlutterPytorch.loadClassificationModel(
        "assets/models/best.pt", 224, 224,
        labelPath: "assets/labels/lebels.txt");
    // print(classificationModel);
    return classificationModel;
  }

  classifyImage(XFile? image) async {
    loadModel().then((value)async {
      print('--------------');
        // String? prediction = await value.getImagePrediction(await File('assets/images/OIP.jpeg').readAsBytesSync());
      String prediction = await value.getImagePrediction(await File('/assets/images/OIP.jpeg').readAsBytesSync());

      print(image!.path);
      print('------');
      print(prediction);
        // _outputs[0] = prediction;
    });
    setState(() {
      _loading = false;
      // _outputs = output;
    });
  }
  pickImage() async {
    final ImagePicker picker = ImagePicker();
// Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _loading = true;
      _image = image;
    });
    classifyImage(_image);
  }


  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.max,
    );

    _initializeControllerFuture = _controller.initialize().then((value){
      if(!mounted){
        return;
      }
      _controller.startImageStream((image) {
        // setState(() {});
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: ()async{
        // final image = await _controller.takePicture();
        print('-------------------------------');
        pickImage();
        // classifyImage()
        // predict().then((value) async{
        //   // File imageFile = File('assets/images/OIP.jpeg');
        //   // List<int> imageBytes = imageFile.readAsBytesSync();
        //   String prediction = await value.getImagePrediction(await File('assets/images/OIP.jpeg').readAsBytesSync());
        //   print(prediction);
        // });
        print('------------------------');

      },
        child: Icon(Icons.camera),
      ),

      appBar: AppBar(title: Text('Helmet Detection')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _controller.value.isInitialized?CameraPreview(_controller):CircularProgressIndicator();
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

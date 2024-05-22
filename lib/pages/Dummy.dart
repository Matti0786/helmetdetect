import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:helmetdetect/pages/Camera.dart';

class Dummy extends StatefulWidget {
  const Dummy({super.key});

  @override
  State<Dummy> createState() => _DummyState();
}

class _DummyState extends State<Dummy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_outlined),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text("Launch Camera"),
              onPressed: () async {
                await availableCameras().then((value) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CameraApp(
                        camera: value[0],
                      ),
                    ),
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

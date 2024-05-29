import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'Camera.dart';

class DefaulterList extends StatefulWidget {
  const DefaulterList({super.key});

  @override
  State<DefaulterList> createState() => _DefaulterListState();
}

class _DefaulterListState extends State<DefaulterList> {
  // late Future<List<String>> _imageUrls;
  late Future<List<Map<String, String>>> _imageData;

  @override
  void initState() {
    super.initState();
    _imageData = _loadImages();
  }

  Future<List<Map<String, String>>> _loadImages() async {
    ListResult result = await FirebaseStorage.instance.ref('uploads').listAll();
    List<Map<String, String>> data = [];
    for (var ref in result.items) {
      final url = await ref.getDownloadURL();
      data.add({'url': url, 'path': ref.fullPath});
    }
    return data;
  }

  Future<void> _deleteImage(String path) async {
    try {
      await FirebaseStorage.instance.ref(path).delete();
      setState(() {
        _imageData = _loadImages();
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Image deleted successfully")));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to delete image: $e")));
    }
  }

  Future<void> _deleteAllImages() async {
    try {
      ListResult result =
          await FirebaseStorage.instance.ref('uploads').listAll();
      for (var ref in result.items) {
        await ref.delete();
      }
      setState(() {
        _imageData = _loadImages();
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("All images deleted successfully")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to delete all images: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Defaulters'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: _deleteAllImages,
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: _imageData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error loading images'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No images found'));
          }

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final imageData = snapshot.data![index];
              return Stack(
                children: [
                  Image.network(imageData['url']!),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteImage(imageData['path']!),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
    //   Column(
    //   children: [
    //     ElevatedButton(
    //       child: Text("Launch Camera"),
    //       onPressed: () async {
    //         await availableCameras().then((value) {
    //           Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //               builder: (context) => CameraApp(
    //                 camera: value[0],
    //               ),
    //             ),
    //           );
    //         });
    //       },
    //     ),
    //     ElevatedButton(onPressed: _loadImages, child: Icon(Icons.front_loader)),
    //   ],
    // );
  }
}

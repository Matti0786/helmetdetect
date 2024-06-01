import 'package:flutter/material.dart';

class SingleImageShow extends StatelessWidget {
  final String imageUrl;

  const SingleImageShow({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'Defaulter',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Hero(
          tag: imageUrl, // Use the same tag as in the GridView builder
          child: Image.network(
            imageUrl,
          ),
        ),
      ),
    );
  }
}

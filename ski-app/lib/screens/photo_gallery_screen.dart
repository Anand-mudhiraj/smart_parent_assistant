import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PhotoGalleryScreen extends StatefulWidget {
  const PhotoGalleryScreen({super.key});

  @override
  State<PhotoGalleryScreen> createState() => _PhotoGalleryScreenState();
}

class _PhotoGalleryScreenState extends State<PhotoGalleryScreen> {

  File? image;

  pickImage() async {

    final picker = ImagePicker();

    final file = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if(file != null){

      setState(() {
        image = File(file.path);
      });

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Child Photos")),

      body: Column(
        children: [

          ElevatedButton(
            onPressed: pickImage,
            child: const Text("Upload Photo"),
          ),

          if(image != null)
            Image.file(image!,height:200)

        ],
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class InsertDataPage extends StatefulWidget {
  @override
  _InsertDataPageState createState() => _InsertDataPageState();
}

class _InsertDataPageState extends State<InsertDataPage> {
  TextEditingController contentController = TextEditingController();
  File? selectedImage;

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        selectedImage = File(pickedImage.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _submitData() async {
    String content = contentController.text;

    // You can do something with the entered content and image file
    print('Content: $content');
    if (selectedImage != null) {
      print('Image path: ${selectedImage!.path}');
    } else {
      print('No image selected.');
    }

    // Navigate back to the all posts page
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: contentController,
              decoration: InputDecoration(labelText: 'Content'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            SizedBox(height: 16.0),
            selectedImage != null
                ? Image.file(selectedImage!,
                    height: 100.0, width: 100.0, fit: BoxFit.cover)
                : Container(
                    height: 100.0,
                    width: 100.0,
                    color: Colors.grey[200],
                    child: Icon(Icons.camera_alt, color: Colors.grey[800]),
                  ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _submitData,
              child: Text('Done'),
            ),
          ],
        ),
      ),
    );
  }
}

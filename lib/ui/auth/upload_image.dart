// ignore_for_file: unused_local_variable, unused_field, avoid_print
import 'dart:io';
//import 'dart:js_util';
//import 'dart:js_interop';
import 'package:firebase_app/utils/utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  bool _isLoading = false;
  File? _image;
  final picker = ImagePicker();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref('Post');

  Future<void> getImageFromGallery() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("No image picked");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text(
          "Upload Image",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: InkWell(
                onTap: () {
                  getImageFromGallery();
                },
                child: Container(
                  height: 200,
                  width: 200,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Center(
                      child: _image != null
                          ? Image.file(_image!.absolute)
                          : const Icon(Icons.image)),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            InkWell(
              onTap: () async {
                setState(() {
                  _isLoading = true;
                });
                // Generate a unique ID for the image
                String imageId =
                    DateTime.now().millisecondsSinceEpoch.toString();

// Create a reference with the generated ID
                firebase_storage.Reference ref = firebase_storage
                    .FirebaseStorage.instance
                    .ref('/Ajay/Images/$imageId');

// Upload the image using the generated reference
                firebase_storage.UploadTask uploadTask =
                    ref.putFile(_image!.absolute);

                // firebase_storage.Reference ref = firebase_storage
                //     .FirebaseStorage.instance
                //     .ref('/FolderName' '1224');
                // firebase_storage.UploadTask uploadTask =
                //     ref.putFile(_image!.absolute);

                Future.value(uploadTask).then((value) async {
                  var newUrl = await ref.getDownloadURL();
                  databaseRef
                      .child('1')
                      .set({'id': '1224', 'title': newUrl.toString()}).then(
                    (value) {
                      setState(() {
                        _isLoading = false;
                      });
                      Utils().toastMessage('Uploaded');
                    },
                  ).onError(
                    (error, stackTrace) {
                      Utils().toastMessage(error.toString());
                      setState(() {
                        _isLoading = false;
                      });
                    },
                  );
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                  setState(() {
                    _isLoading = false;
                  });
                });
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: const BorderRadius.all(Radius.circular(50))),
                child: Center(
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Upload Image'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

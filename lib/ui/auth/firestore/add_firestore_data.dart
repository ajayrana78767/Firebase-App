import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/utils/utils.dart';
import 'package:flutter/material.dart';

class AddFireStoreDataScreen extends StatefulWidget {
  const AddFireStoreDataScreen({super.key});

  @override
  State<AddFireStoreDataScreen> createState() => _AddFireStoreDataScreenState();
}

class _AddFireStoreDataScreenState extends State<AddFireStoreDataScreen> {
  bool _isLoading = false;
  final fireStore = FirebaseFirestore.instance.collection('users');
  final postController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text(
          "Add Firestore Data",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.navigate_before_outlined,
              size: 35,
              color: Colors.white,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: postController,
              maxLines: 4,
              decoration: const InputDecoration(
                  hintText: "What's in your mind",
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              color: Colors.lightBlue,
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue),
                  onPressed: () {
                    setState(() {
                      _isLoading = true;
                    });
                    final id = DateTime.now().microsecondsSinceEpoch.toString();
                    fireStore.doc(id).set({
                      'title': postController.text.toString(),
                      'id': id,
                      
                    }).then((value) {
                      setState(() {
                        _isLoading = false;
                      });
                      Utils().toastMessage('Post Added');
                    }).onError((error, stackTrace) {
                      Utils().toastMessage(error.toString());
                    });
                  },
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Add",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        )),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: override_on_non_overriding_member
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/ui/auth/firestore/add_firestore_data.dart';
import 'package:firebase_app/ui/auth/login_screen.dart';
import 'package:firebase_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FireStoreScreen extends StatefulWidget {
  const FireStoreScreen({super.key});

  @override
  State<FireStoreScreen> createState() => _FireStoreScreenState();
}

class _FireStoreScreenState extends State<FireStoreScreen> {
  @override
  final auth = FirebaseAuth.instance;
  final editController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('users').snapshots();
  CollectionReference ref = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.lightBlue,
        title: const Text(
          "Firestore",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut().then((value) => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen())));
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              )),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddFireStoreDataScreen()));
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          StreamBuilder<QuerySnapshot>(
              stream: fireStore,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return const Text('error');
                }
                return Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final title =
                            snapshot.data!.docs[index]["title"].toString();
                        return ListTile(
                          onTap: () {
                            // ref.doc(snapshot.data!.docs[index]["id"].toString()).update({
                            //   'title':''
                            // });
                          },
                          title: Text(
                              snapshot.data!.docs[index]["title"].toString()),
                          subtitle:
                              Text(snapshot.data!.docs[index]["id"].toString()),
                          trailing: PopupMenuButton(
                              itemBuilder: (context) => [
                                    PopupMenuItem(
                                        value: 1,
                                        child: ListTile(
                                          onTap: () {
                                            Navigator.pop(context);
                                            showMyDialog(
                                              title,
                                              snapshot.data!.docs[index]["id"]
                                                  .toString(),
                                            );
                                            // showMyDialog(
                                            //     ,
                                            //     snapshot
                                            //         .child('id')
                                            //         .value
                                            //         .toString()); // Call showMyDialog() when the menu item is tapped
                                          },
                                          leading: const Icon(Icons.edit),
                                          title: const Text('Edit'),
                                        )),
                                    PopupMenuItem(
                                        value: 1,
                                        child: ListTile(
                                          onTap: () {
                                             ref.doc(snapshot.data!.docs[index]["id"].toString()).delete();
                                            Navigator.pop(context);
                                            
                                          },
                                          leading: const Icon(Icons.delete),
                                          title: const Text('Delete'),
                                        )),
                                  ]),
                        );
                      }),
                );
              })
        ],
      ),
    );
  }

  Future<void> showMyDialog(String title, String id) async {
    editController.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Update'),
            content: TextField(
              controller: editController,
              decoration: const InputDecoration(
                hintText: 'Edit',
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ref.doc(id).update({
                      'title': editController.text.toString(),
                    }).then((value) {
                      Utils().toastMessage('Post Updated');
                    }).onError((error, stackTrace) {
                      Utils().toastMessage(error.toString());
                    });
                  },
                  child: const Text('Update')),
            ],
          );
        });
  }
}

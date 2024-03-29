// ignore_for_file: non_constant_identifier_names, unused_local_variable

//import 'dart:math';

import 'package:firebase_app/ui/auth/login_screen.dart';
import 'package:firebase_app/ui/auth/posts/add_posts.dart';
import 'package:firebase_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Post');
  final searchFilter = TextEditingController();
  final editController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.lightBlue,
        title: const Text(
          "Post Screen",
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
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddPostScreen()));
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: searchFilter,
              decoration: const InputDecoration(
                hintText: "Search",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          // Expanded(
          //   child: StreamBuilder(
          //     stream: ref.onValue,
          //     // initialData: initialData,
          //     builder: (BuildContext context,
          //         AsyncSnapshot<DatabaseEvent> snapshot) {

          //       if (!snapshot.hasData) {
          //         return const CircularProgressIndicator();
          //       } else {
          //          Map<dynamic, dynamic> map=snapshot.data!.snapshot.value as dynamic;
          //          var List=<dynamic>[];
          //             List.clear();
          //             List=map.values.toList();
          //         return ListView.builder(
          //             itemCount: snapshot.data!.snapshot.children.length,
          //             itemBuilder: (context, index) {
          //               return  ListTile(
          //                 title: Text(List[index]['Title']),
          //                 subtitle: Text(List[index]['id']),
          //               );
          //             });
          //       }
          //     },
          //   ),
          // ),
          Expanded(
            child: FirebaseAnimatedList(
                shrinkWrap: true,
                query: ref,
                defaultChild: const Center(
                    child: CircularProgressIndicator(
                  color: Colors.lightBlue,
                )),
                itemBuilder: (context, snapshot, animation, index) {
                  final title = snapshot.child('Title').value.toString();
                  if (searchFilter.text.isEmpty) {
                    return ListTile(
                      title: Text(snapshot.child('Title').value.toString()),
                      subtitle: Text(snapshot.child('id').value.toString()),
                      trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                                PopupMenuItem(
                                    value: 1,
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.pop(context);
                                        showMyDialog(
                                            title,
                                            snapshot
                                                .child('id')
                                                .value
                                                .toString()); // Call showMyDialog() when the menu item is tapped
                                      },
                                      leading: const Icon(Icons.edit),
                                      title: const Text('Edit'),
                                    )),
                                 PopupMenuItem(
                                    value: 1,
                                    child: ListTile(
                                      onTap:(){
                                         Navigator.pop(context);
                                         ref.child(snapshot.child('id').value.toString()).remove();
                                      } ,
                                      leading: const Icon(Icons.delete),
                                      title: const Text('Delete'),
                                    )),
                              ]),
                    );
                  } else if (title
                      .toLowerCase()
                      .contains(searchFilter.text.toLowerCase().toString())) {
                    return ListTile(
                      title: Text(snapshot.child('Title').value.toString()),
                      subtitle: Text(snapshot.child('id').value.toString()),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }),
          ),
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
                    ref.child(id).update({
                      'Title': editController.text.toString(),
                    }).then((e) {
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

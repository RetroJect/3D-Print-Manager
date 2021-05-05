import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class MainView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main View"),
        actions: [
          Builder(
            builder: (context) {
              return TextButton(
                  onPressed: () => _auth.signOut().then((value) {
                        Navigator.pushReplacementNamed(context, "/Login");
                      }),
                  child: Text("Sign Out"));
            },
          )
        ],
      ),
      body: Center(
        child: Text("This is the main view"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, "/ItemCreate"),
        child: Icon(Icons.add),
      ),
    );
  }
}

class PrintsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Stream userItems = FirebaseFirestore.instance
        .collection('items')
        .where('userid', isEqualTo: _auth.currentUser.uid)
        .snapshots();

    return StreamBuilder(
      stream: userItems,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) return Text("Fetching your projects...");

        return ListView(
          children: snapshot.data.docs.map((document) {
            return ListTile(
              leading: FlutterLogo(
                size: 56.0,
              ),
              title: Text(document["title"]),
              subtitle: Text(document["description"]),
            );
          }).toList(),
        );
      },
    );
  }
}

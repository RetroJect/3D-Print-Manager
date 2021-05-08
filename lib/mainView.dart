import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:print_manager_3d/itemEdit.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class MainView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Prints"),
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
      body: PrintsList(),
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
        if (snapshot.hasError)
          return Center(
            child: Text("Sorry, something went wrong"),
          );

        if (!snapshot.hasData || snapshot.data.docs.length == 0)
          return Center(
            child: RichText(
              text: TextSpan(children: [
                TextSpan(text: "Tap the "),
                WidgetSpan(child: Icon(Icons.add)),
                TextSpan(text: " to get started!")
              ]),
            ),
          );

        List items = snapshot.data.docs;
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: ListTile(
                leading: Image.network(items[index]["image"]),
                title: Text(items[index]["title"]),
                subtitle: Text(items[index]["description"]),
                onLongPress: () {
                  Navigator.of(context).pushNamed('/ItemEdit',
                      arguments: ItemEditViewArguments(items[index].id));
                },
              ),
            );
          },
        );
      },
    );
  }
}

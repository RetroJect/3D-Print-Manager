import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:print_manager_3d/signIn.dart';
import 'package:print_manager_3d/mainView.dart';
import 'package:print_manager_3d/itemEdit.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class ItemDetailViewArguments {
  final String itemId;

  ItemDetailViewArguments(this.itemId);
}

class ItemDetailView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ItemDetailViewState();
}

class _ItemDetailViewState extends State<ItemDetailView> {
  bool collectedItem = false;
  var item;

  @override
  Widget build(BuildContext context) {
    final ItemDetailViewArguments args =
        ModalRoute.of(context).settings.arguments as ItemDetailViewArguments;

    FirebaseFirestore.instance
        .collection('items')
        .doc(args.itemId)
        .get()
        .then((value) {
      setState(() {
        item = value;
        collectedItem = true;
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Item Detail View"),
      ),
      body: (collectedItem)
          ? ListView(
              children: [
                Text(
                  item['title'],
                  textScaleFactor: 2.0,
                ),
                SizedBox(height: 10),
                Text(item['description']),
                SizedBox(height: 10),
                Image.network(item['image']),
              ],
              padding: EdgeInsets.all(16),
            )
          : Center(
              child: Column(
                children: [CircularProgressIndicator(), Text("One moment...")],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, "/ItemEdit",
            arguments: ItemEditViewArguments(args.itemId)),
        child: Icon(Icons.edit),
      ),
    );
  }
}

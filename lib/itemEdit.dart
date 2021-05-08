import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class ItemEditViewArguments {
  final String itemId;

  ItemEditViewArguments(this.itemId);
}

class ItemEditView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ItemEditViewState();
}

class _ItemEditViewState extends State<ItemEditView> {
  String imageUrl = '';
  bool disableSubmit = false;

  DocumentReference item;
  bool collectedItem = false;

  Widget curView = Center(
      child: Column(
    children: [CircularProgressIndicator(), Text("One moment...")],
  ));

  TextEditingController titleController;
  TextEditingController descriptionController;

  @override
  Widget build(BuildContext context) {
    final ItemEditViewArguments args =
        ModalRoute.of(context).settings.arguments as ItemEditViewArguments;

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    void uploadImage() async {
      final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
      final ImagePicker _imagePicker = ImagePicker();
      PickedFile image;

      await Permission.photos.request();
      PermissionStatus photoStatus = await Permission.photos.status;

      if (photoStatus.isGranted) {
        image = await _imagePicker.getImage(source: ImageSource.gallery);

        if (image != null) {
          File file = File(image.path);

          Uuid uuid = Uuid();
          var fileName = '${_auth.currentUser.uid}-${uuid.v4()}';
          await _firebaseStorage.ref(fileName).putFile(file);
          var downloadUrl =
              await _firebaseStorage.ref(fileName).getDownloadURL();

          setState(() {
            imageUrl = downloadUrl;
          });
        } else {
          print('No Image Path');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text("Unable to get image. Please grant image permissions.")));
      }
    }

    void submitForm() {
      if (_formKey.currentState.validate()) {
        setState(() {
          disableSubmit = true;
        });
        item.update({
          'image': imageUrl,
          'title': titleController.text,
          'description': descriptionController.text
        }).then((value) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Print updated")));
          Navigator.pop(context);
        }).catchError((error) {
          print(error);
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Something went wrong, try again soon')));
          Future.delayed(Duration(seconds: 1), () {
            setState(() {
              disableSubmit = false;
            });
          });
        });
      }
    }

    if (collectedItem) {
      setState(() {
        curView = Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              Image.network(imageUrl),
              ElevatedButton(
                onPressed: uploadImage,
                child: Text("Choose thumbnail"),
              ),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: "The name of the printed item",
                  labelText: "Title",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please enter a Title';
                  return null;
                },
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  hintText: "A short description of the object",
                  labelText: "Description",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please enter a Description';
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: (disableSubmit) ? null : submitForm,
                child: Text('Submit'),
              )
            ],
          ),
        );
      });
    } else {
      item = FirebaseFirestore.instance.collection('items').doc(args.itemId);
      item.get().then((value) {
        setState(() {
          imageUrl = value['image'];
          titleController = TextEditingController(text: value['title']);
          descriptionController =
              TextEditingController(text: value['description']);
          collectedItem = true;
        });
      });
    }

    AlertDialog deleteAlert = AlertDialog(
      title: Text('Delete this print?'),
      content: Text(
          'Are you sure you want to delete this print? It cannot be recovered.'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Cancel")),
        TextButton(
            onPressed: () {
              item.delete().then((value) =>
                  Navigator.of(context).popUntil(ModalRoute.withName('/Main')));
            },
            child: Text("Delete")),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => deleteAlert);
            },
          ),
        ],
        title: Text("Edit"),
      ),
      body: curView,
    );
  }
}

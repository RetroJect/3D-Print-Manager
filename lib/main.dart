import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_manager_3d/signIn.dart';
import 'package:print_manager_3d/mainView.dart';
import 'package:uuid/uuid.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '3D Print Manager',
      theme: ThemeData.dark(),
      initialRoute: "/",
      routes: {
        "/": (context) => AppSetup(),
        "/FlutterFireError": (context) => FlutterFireError(),
        "/Login": (context) => SignInPage(),
        "/Main": (context) => MainView(),
        "/ItemDetail": (context) => ItemDetailView(),
        "/ItemCreate": (context) => ItemCreateView(),
        "/ItemEdit": (context) => ItemEditView(),
      },
    );
  }
}

class AppSetup extends StatefulWidget {
  _AppSetupState createState() => _AppSetupState();
}

class _AppSetupState extends State<AppSetup> {
  bool _initialized = false;
  bool _error = false;

  void initFlutterFire() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      print(e);
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      Future.delayed(Duration.zero,
          () => Navigator.pushReplacementNamed(context, "/FlutterFireError"));
    }

    if (_initialized) {
      // Check if our auth is cached
      if (_auth.currentUser != null) {
        // Skip login step and used cached user
        Future.delayed(Duration.zero,
            () => Navigator.pushReplacementNamed(context, "/Main"));
      } else {
        // No cached user, show login
        Future.delayed(Duration(seconds: 5),
            () => Navigator.pushReplacementNamed(context, "/Login"));
      }
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Hold tight, we're getting everything ready!"),
            SizedBox(height: 10),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

class FlutterFireError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Fire Error"),
      ),
      body: Center(
        child: Text("Something went wrong getting setup."),
      ),
    );
  }
}

class ItemDetailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Item Detail View"),
      ),
      body: Center(
        child: Text("This is the Item Detail View"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, "/ItemEdit"),
        child: Icon(Icons.edit),
      ),
    );
  }
}

class ItemEditView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Item Edit View"),
      ),
      body: Center(
        child: Text("This is the Item Edit View"),
      ),
    );
  }
}

class ItemCreateView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ItemCreateViewState();
}

class _ItemCreateViewState extends State<ItemCreateView> {
  String imageUrl = 'https://i.imgur.com/sUFH1Aq.png';
  bool disableSubmit = false;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    final CollectionReference items =
        FirebaseFirestore.instance.collection('items');

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
        disableSubmit = true;
        items.add({
          'userid': _auth.currentUser.uid,
          'title': titleController.text,
          'description': descriptionController.text,
          'image': imageUrl,
        }).then((value) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Print created")));
          Navigator.pop(context);
        }).catchError((error) {
          print(error);
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Something went wrong, try again soon')));
          Future.delayed(Duration(seconds: 1), () {
            disableSubmit = false;
          });
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Print"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
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
      ),
    );
  }
}

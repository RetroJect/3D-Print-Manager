import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return MaterialApp(
            title: '3D Print Manager',
            home: Text("Sorry, something went wrong."),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: '3D Print Manager',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: Scaffold(
              appBar: AppBar(
                title: Text("3D Print Manager"),
              ),
              body: Center(
                child: Text("Welcome Home!"),
              ),
            ),
            /*
            initialRoute: '/',
            routes: {
              '/': (context) => MainView(),
              "/ItemDetail": (context) => ItemDetailView(),
              "/ItemCreate": (context) => ItemCreateView(),
              "/ItemEdit": (context) => ItemEditView(),
            },
            */
          );
        }

        return MaterialApp(
          title: '3D Print Manager',
          home: Text("Getting everything ready..."),
        );
      },
    );
  }
}

class MainView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main View"),
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

class ItemCreateView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Item Create View"),
      ),
      body: Center(
        child: Text("This is the Item Create View"),
      ),
    );
  }
}

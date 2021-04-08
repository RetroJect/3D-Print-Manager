import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '3D Print Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MainView(),
        "/ItemDetail": (context) => ItemDetailView(),
        "/ItemCreate": (context) => ItemCreateView(),
        "/ItemEdit": (context) => ItemEditView(),
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

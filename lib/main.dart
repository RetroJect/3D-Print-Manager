import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => AppSetup(),
        "/FlutterFireError": (context) => FlutterFireError(),
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
      Future.delayed(Duration.zero,
          () => Navigator.pushReplacementNamed(context, "/Main"));
    }

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("Hold tight, we're getting everything ready!"),
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

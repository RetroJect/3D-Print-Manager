import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<UserCredential> signInWithGoogle() async {
  final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
  GoogleSignInAuthentication googleAuth;
  if (googleUser != null)
    googleAuth = await googleUser.authentication;
  else {
    print('Failed GoogleSignIn, user was null');
    return null;
  }

  final GoogleAuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  return await FirebaseAuth.instance.signInWithCredential(credential);
}

class SignInPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  User user;

  @override
  void initState() {
    _auth.userChanges().listen((event) {
      // print(event);
      setState(() => user = event);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Check if User is stored and doesn't need to log in
    if (user != null)
      Future.delayed(Duration.zero,
          () => Navigator.pushReplacementNamed(context, "/Main"));

    // No stored user
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Welcome to your 3D Print Manager! To get started, sign in.",
              style: TextStyle(fontSize: 24, inherit: true),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 25),
            SignInButton(
              Buttons.GoogleDark,
              onPressed: () => signInWithGoogle(),
            ),
          ],
        ),
      ),
    );
  }
}

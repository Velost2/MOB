// ignore_for_file: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:neu/auth_side.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
          initialData: null,
        )
      ],
      child: MaterialApp(
        title: 'hmm',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const AuthenticationWrapper(),
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser == null) {
      return FirstPage();
    } else {
      return LogInPage();
    }
  }
}

class FirstPage extends StatelessWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FH App'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Center(
              child: Text(
                'Erste Seite',
                style: TextStyle(fontSize: 35),
              ),
            ),
            SizedBox(
              height: 150,
              child: ListView(
                children: <Widget>[
                  Container(
                    height: 50,
                    color: Colors.blue[600],
                    child: const Center(
                      child: Text('Blau 600'),
                    ),
                  ),
                  Container(
                    height: 50,
                    color: Colors.blue[500],
                    child: const Center(
                      child: Text('Blau 500'),
                    ),
                  ),
                  Container(
                    height: 50,
                    color: Colors.blue[400],
                    child: const Center(
                      child: Text('Blau 400'),
                    ),
                  ),
                  Container(
                    height: 50,
                    color: Colors.blue[300],
                    child: const Center(
                      child: Text('Blau 300'),
                    ),
                  ),
                  Container(
                    height: 50,
                    color: Colors.blue[200],
                    child: const Center(
                      child: Text('Blau 200'),
                    ),
                  ),
                  Container(
                    height: 50,
                    color: Colors.blue[100],
                    child: const Center(
                      child: Text('Blau 100'),
                    ),
                  ),
                  Container(
                    height: 50,
                    color: Colors.blue[0],
                    child: const Center(
                      child: Text('Blau 0'),
                    ),
                  ),
                ],
                scrollDirection: Axis.vertical,
              ),
            ),
            ElevatedButton(
              child: const Text('Seite 2'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SecondPage()));
              },
            ),
            ElevatedButton(
              child: const Text('Seite 3'),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const ThirdPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seite 2')),
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Align(
            alignment: Alignment.topCenter,
            child: Text('Anmelden mittels NFC', style: TextStyle(fontSize: 35)),
          ),
          ElevatedButton(
            child: const Text('Zurück zu Seite 1'),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const FirstPage()));
            },
          ),
          ElevatedButton(
            child: const Text('Gehe zu Seite 3'),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ThirdPage()));
            },
          )
        ],
      )),
    );
  }
}

class ThirdPage extends StatelessWidget {
  const ThirdPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seite 3')),
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'Dies ist die dritte Seite',
            style: TextStyle(fontSize: 35),
          ),
          ElevatedButton(
            child: const Text('Zurück zu Seite 1'),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => FirstPage()));
            },
          ),
          ElevatedButton(
            child: const Text('Zurück zu Seite 2'),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SecondPage()));
            },
          ),
        ],
      )),
    );
  }
}

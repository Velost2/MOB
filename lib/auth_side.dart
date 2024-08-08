import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:neu/main.dart';
import 'package:provider/src/provider.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String?> signIn(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return 'Angemeldet';
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}

class LogInPage extends StatelessWidget {
  LogInPage({Key? key}) : super(key: key);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anmeldung'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: 50,
            ),
            Text(
              'Bitte melden Sie sich an:',
              style: TextStyle(fontSize: 25, color: Colors.blue[600]),
            ),
            const SizedBox(),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    fontSize: 15,
                    color: Colors.blue[600],
                  )),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: 'Passwort',
                  labelStyle: TextStyle(
                    fontSize: 15,
                    color: Colors.blue[600],
                  ),
                  filled: true),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Column(
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthenticationService>().signIn(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim());
                  },
                  child: Text('Mit Email & Passwort Anmelden'),
                ),
              ],
            ),
            ElevatedButton(
              child: const Text('Mit Fingerabdruck verifizieren'),
              onPressed: () async {
                bool isAuthenticated =
                    await Authentication.authenticateWithBiometrics();

                if (isAuthenticated) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const FirstPage(),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    Authentication.customSnackBar,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Authentication {
  static SnackBar customSnackBar = const SnackBar(
    content: Text('Es ist notwendig sich zu authentifizieren'),
  );
  static Future<bool> authenticateWithBiometrics() async {
    final LocalAuthentication localAuthentication = LocalAuthentication();
    bool isBiometricSupported = await localAuthentication.isDeviceSupported();
    bool canCheckBiometrics = await localAuthentication.canCheckBiometrics;

    bool isAuthenticated = false;

    if (isBiometricSupported && canCheckBiometrics) {
      isAuthenticated = await localAuthentication.authenticate(
        localizedReason: 'Please complete the biometrics to proceed.',
        biometricOnly: true,
      );
    }

    return isAuthenticated;
  }
}

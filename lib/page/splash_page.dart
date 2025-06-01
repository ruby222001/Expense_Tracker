import 'package:flutter/material.dart';
import 'package:hive_practise/homepage.dart';
import 'package:local_auth/local_auth.dart';

class SplashLoginPage extends StatefulWidget {
  @override
  _SplashLoginPageState createState() => _SplashLoginPageState();
}

class _SplashLoginPageState extends State<SplashLoginPage> {
  final LocalAuthentication auth = LocalAuthentication();
  String _message = "Authenticating...";

  @override
  void initState() {
    super.initState();
    _authenticate();
  }

  Future<void> _authenticate() async {
    bool canCheckBiometrics = false;
    bool authenticated = false;

    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
      if (!canCheckBiometrics) {
        setState(() {
          _message = "Biometric authentication not available.";
        });
        return;
      }

      authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to continue',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (authenticated) {
        setState(() {
          _message = "Authentication successful!";
        });
        // Navigate to the next page, e.g. HomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MyHomePage()),
        );
      } else {
        setState(() {
          _message = "Authentication failed. Try again.";
        });
      }
    } catch (e) {
      setState(() {
        _message = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          _message,
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
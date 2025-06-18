import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fully_tamil/pages/login/forget_password.dart';
import 'package:fully_tamil/pages/home.dart';
import 'package:fully_tamil/pages/login/routes.dart';
import 'package:fully_tamil/pages/login/shared_preferences_service.dart';

import 'home_page.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final PrefService _prefService = PrefService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscurePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  Future<bool> loginWithEmailPassword(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog('Email and Password cannot be empty');
      return false;
    }

    if (password.length < 6) {
      _showErrorDialog('Password must be at least 6 characters long');
      return false;
    }

    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;

      if (user != null) {
        if (user.emailVerified) {
          return true; // Login successful and email is verified
        } else {
          _showErrorDialog(
              'Email not verified. Please verify your email before logging in.');
          return false;
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showErrorDialog('No user found with this email');
      } else if (e.code == 'wrong-password') {
        _showErrorDialog('Incorrect password');
      } else {
        _showErrorDialog('Error logging in: ${e.message}');
      }
      return false;
    } catch (e) {
      _showErrorDialog('An unexpected error occurred');
      return false;
    }
    return false; // Return false if something unexpected happened
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return WillPopScope(
      onWillPop: () async {
        // Handle back button press
        // In this case, navigate to the home page instead of going back to the previous page.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
        return false; // Prevent the default back button behavior
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Container(
              width: double.infinity,
              height: 800 * fem,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(-0, -1),
                  end: Alignment(-1.158, 1.141),
                  colors: <Color>[Color(0xFF3EAF0E), Color(0xffb8c9b0)],
                  stops: <double>[0.008, 0.896],
                ),
              ),
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(
                      20 * fem,
                      425 * fem,
                      20 * fem,
                      13 * fem,
                    ),
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextField(
                            // keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email),
                            ),
                            controller: emailController,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                      20 * fem,
                      525 * fem,
                      20 * fem,
                      13 * fem,
                    ),
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextFormField(
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: GestureDetector(
                                onTap: _togglePasswordVisibility,
                                child: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                            ),
                            controller: passwordController,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 105 * fem,
                    top: 162 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 150 * fem,
                        height: 150 * fem,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(75 * fem),
                            image: const DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                'assets/Tamil_Logo.png',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 70.5 * fem,
                    top: 329 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 220 * fem,
                        height: 41 * fem,
                        child: Text(
                          'FULLY TAMIL\n',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontSize: 35 * ffem,
                            fontWeight: FontWeight.w700,
                            height: 1.15 * ffem / fem,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 120 * fem,
                    top: 376 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 120 * fem,
                        height: 14 * fem,
                        child: Text(
                          '       ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontSize: 12 * ffem,
                            fontWeight: FontWeight.w700,
                            height: 1.15 * ffem / fem,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                      228 * fem,
                      580 * fem,
                      10 * fem,
                      0 * fem,
                    ),
                    width: double.infinity,
                    height: 50 * fem,
                    child: TextButton(
                      style: ButtonStyle(
                        overlayColor:
                            WidgetStateProperty.all(Colors.transparent),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ForgetPassword()),
                        );
                      },
                      child: Center(
                        child: Text(
                          'Forget password?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontSize: 12 * ffem,
                            fontWeight: FontWeight.w500,
                            height: 1.15 * ffem / fem,
                            color: const Color(0xcc000000).withOpacity(0.50),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                      45 * fem,
                      650 * fem,
                      45 * fem,
                      0 * fem,
                    ),
                    width: double.infinity,
                    height: 41 * fem,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        backgroundColor: const Color(0xff77ce6c),
                      ),
                      onPressed: () async {
                        String email = emailController.text;
                        String password = passwordController.text;

                        bool success =
                            await loginWithEmailPassword(email, password);

                        if (success) {
                          _prefService.createCache(password).whenComplete(() {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyHomePage()),
                            );
                          });
                        }
                      },
                      child: Center(
                        child: Text(
                          'Log in',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontSize: 25 * ffem,
                            fontWeight: FontWeight.w500,
                            height: 1.15 * ffem / fem,
                            color: const Color(0xcc000000),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

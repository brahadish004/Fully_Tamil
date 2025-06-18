import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fully_tamil/pages/login/login_page.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  SignupState createState() => SignupState();
}

class SignupState extends State<Signup> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  final numbController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmpasswordController.dispose();
    numbController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  Future signUp() async {
    // Your existing validation and user creation logic

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Send email verification
      await userCredential.user?.sendEmailVerification();

      // Add user details to Firestore
      await addUserDetails(
        nameController.text.trim(),
        emailController.text.trim(),
        int.parse(numbController.text.trim()),
      );

      // Show a dialog to inform the user to check their email
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Email Sent"),
            content: const Text(
                "A verification email has been sent. Please check your inbox and verify your email before logging in."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Handle errors
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Sign Up Failed"),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  Future addUserDetails(String name, String email, int numb) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'Name': name,
        'email': email,
        'Phone Number': numb,
      });
    }
  }

  bool passwordConfirmed() {
    return passwordController.text.trim() ==
        confirmpasswordController.text.trim();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 360.0045166016;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Container(
            padding: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 109 * fem),
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0, -1),
                end: Alignment(-1.158, 1.141),
                colors: <Color>[Color(0xFF3EAF0E), Color(0xffb8c9b0)],
                stops: <double>[0.008, 0.896],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(
                      21 * fem, 36 * fem, 23 * fem, 16 * fem),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(
                            84 * fem, 10 * fem, 82 * fem, 0 * fem),
                        width: double.infinity,
                        height: 150 * fem,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(75 * fem),
                          image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/Tamil_Logo.png'),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(
                            1 * fem, 10 * fem, 0 * fem, 0 * fem),
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
                      Container(
                        margin: EdgeInsets.fromLTRB(
                            0 * fem, 9 * fem, 0 * fem, 14 * fem),
                        width: double.infinity,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Name',
                                  prefixIcon: Icon(Icons.person),
                                ),
                                controller: nameController,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(
                            0 * fem, 9 * fem, 0 * fem, 14 * fem),
                        width: double.infinity,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Phone Number',
                                  prefixIcon: Icon(Icons.person),
                                ),
                                controller: numbController,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(
                            0 * fem, 9 * fem, 0 * fem, 13 * fem),
                        width: double.infinity,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextField(
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
                            0 * fem, 9 * fem, 0 * fem, 13 * fem),
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
                      Container(
                        margin: EdgeInsets.fromLTRB(
                            0 * fem, 9 * fem, 0 * fem, 13 * fem),
                        width: double.infinity,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextFormField(
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: 'Confirm Password',
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
                                controller: confirmpasswordController,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(
                            104 * fem, 0 * fem, 99 * fem, 6 * fem),
                        child: ElevatedButton(
                          onPressed: signUp,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14 * fem),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15 * fem),
                            ),
                            backgroundColor: const Color(0xFF3EAF0E),
                            textStyle: TextStyle(
                              fontFamily: 'Ubuntu',
                              fontSize: 20 * ffem,
                              fontWeight: FontWeight.w700,
                              height: 1.15 * ffem / fem,
                              color: const Color(0xffffffff),
                            ),
                          ),
                          child: const Text('SIGN UP'),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(
                            57 * fem, 0 * fem, 0 * fem, 6 * fem),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account?",
                              style: TextStyle(color: Colors.black),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Login()),
                                );
                              },
                              child: const Text(
                                "Log in",
                                style: TextStyle(
                                  color: Color(0xFF3EAF0E),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

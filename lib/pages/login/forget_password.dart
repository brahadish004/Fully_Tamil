import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final emailController = TextEditingController();
  bool isResetting = false;

  Future<void> resetPassword(BuildContext context) async {
    final email = emailController.text.trim();

    if (email.isNotEmpty) {
      try {
        // Set the flag to indicate reset is in progress
        setState(() {
          isResetting = true;
        });

        // Send a password reset email using Firebase Authentication
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

        // Password reset email sent successfully
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Password Recovery'),
            content: Text('A password recovery email has been sent to $email.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    isResetting = false; // Reset the flag
                  });
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } catch (e) {
        // Failed to send password reset email
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text(
                'Failed to send password recovery email. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    isResetting = false; // Reset the flag
                  });
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } else {
      // Email field is empty
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Please enter your email address.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return Scaffold(
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
                colors: <Color>[
                  Color(0xffb8c9b0),
              Color(0xFF3EAF0E)
              ],
                stops: <double>[0.008, 0.896],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 105 * fem,
                  top: 102 * fem,
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
                  left: 41.5 * fem,
                  top: 289 * fem,
                  child: Align(
                    child: SizedBox(
                      width: 276 * fem,
                      height: 81 * fem,
                      child: const Text(
                        'Password Recovery\n',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Ubuntu',
                          fontSize: 29,
                          fontWeight: FontWeight.w700,
                          height: 1.15,
                          color: Color(0xff000000),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: -15 * fem,
                  top: 379 * fem,
                  child: Align(
                    child: SizedBox(
                      width: 396 * fem,
                      height: 81 * fem,
                      child: const Text(
                        'Enter your Email for Password Recovery\n',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Ubuntu',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.15,
                          color: Color(0xff000000),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(
                      20 * fem, 425 * fem, 20 * fem, 13 * fem),
                  width: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Recovery Email',
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
                      45 * fem, 550 * fem, 45 * fem, 0 * fem),
                  width: double.infinity,
                  height: 41 * fem,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      backgroundColor: Colors.white.withOpacity(0.81),
                    ),
                    onPressed: isResetting
                        ? null
                        : () {
                            resetPassword(context);
                          },
                    child: const Center(
                      child: Text(
                        'Reset Password',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Ubuntu',
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          height: 1.15,
                          color: Color(0xcc000000),
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
    );
  }
}

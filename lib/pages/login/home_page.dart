import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fully_tamil/pages/login/signup_page.dart';
import 'package:fully_tamil/pages/login/login_page.dart';

class Home extends StatelessWidget {
  const Home({super.key});
  Future<bool> _onWillPop() async {
    SystemNavigator.pop(); // This line will exit the app directly
    return true; // Return true to prevent the default back button behavior
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            // androidlarge157w (1:2)
            padding:
                EdgeInsets.fromLTRB(34 * fem, 162 * fem, 23 * fem, 181 * fem),
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-0.942, 1),
                end: Alignment(0.517, -0.936),
                colors: <Color>[
                  Color(0xffb8c9b0),
                  Color(0xFF3EAF0E)
                ], //[Color(0xff98a2d6), Color(0x00a6b0e7)]
                stops: <double>[0.262, 0.983],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  // ellipse1BTo (1:8)
                  margin: EdgeInsets.fromLTRB(
                      77 * fem, 0 * fem, 76 * fem, 17 * fem),
                  width: double.infinity,
                  height: 150 * fem,
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
                Container(
                  // fineeaserpq (1:7)
                  margin:
                      EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 4 * fem),
                  child: Text(
                    'FULLY TAMIL\n',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Schyler',
                      fontSize: 35 * ffem,
                      fontWeight: FontWeight.w700,
                      height: 1.15 * ffem / fem,
                      color: const Color(0xff000000),
                    ),
                  ),
                ),
                Container(
                  // welcomeW2D (10:3)
                  margin:
                      EdgeInsets.fromLTRB(0 * fem, 20 * fem, 0 * fem, 62 * fem),
                  child: Text(
                    'வாழ்க தமிழ் ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      fontSize: 25 * ffem,
                      fontWeight: FontWeight.w700,
                      height: 1.15 * ffem / fem,
                      color: const Color(0xff000000),
                    ),
                  ),
                ),
                Container(
                  // autogroupfhsozTB (LrefUW6cjUgdVx1rTKfhso)
                  margin:
                      EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 29 * fem),
                  width: double.infinity,
                  height: 41 * fem,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20.0), // Adjust the value as needed
                      ),
                      backgroundColor: Color(0xff77ce6c),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()));
                    },
                    child: Text(
                      'Log in',
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
                SizedBox(
                  // autogroupfaroqCu (Lrefgaapt1tcXp5fKDfaRo)
                  width: double.infinity,
                  height: 41 * fem,

                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              20.0), // Adjust the value as needed
                        ),
                        backgroundColor: Color(0xff77ce6c)),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Signup()));
                    },
                    child: Text(
                      'Sign up',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
  static String profileName = 'Profile Name';

  static Future<String> fetchProfileName() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? userDoc =
            snapshot.data() as Map<String, dynamic>?;
        profileName = userDoc?['Name'] ?? 'No Name';
      }
    }
    return profileName;
  }
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController numbController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? userDoc =
            snapshot.data() as Map<String, dynamic>?;

        setState(() {
          nameController.text = userDoc?['Name'] ?? 'No Name';
          emailController.text = userDoc?['email'] ?? 'No Email';
          numbController.text =
              userDoc?['Phone Number']?.toString() ?? 'No Number';

          // Update the static profileName field
          ProfilePage.profileName = nameController.text;
        });
      }
    }
  }

  Future<void> _saveProfile() async {
    User? user = _auth.currentUser;

    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'Name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'Phone Number': int.parse(numbController.text.trim()),
      });

      setState(() {
        _isEditing = false;
        ProfilePage.profileName = nameController.text; // Update profile name
      });
    }
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 360.0045166016;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0, -1),
            end: Alignment(-1.158, 1.141),
            colors: <Color>[Color(0xFF3EAF0E), Color(0xffb8c9b0)],
            stops: <double>[0.008, 0.896],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        EdgeInsets.fromLTRB(21 * fem, 36 * fem, 23 * fem, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Profile Picture Section
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              84 * fem, 10 * fem, 82 * fem, 20 * fem),
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
                        // Name Field
                        SizedBox(height: 10 * fem),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Name',
                            prefixIcon: Icon(Icons.person),
                          ),
                          controller: nameController,
                          readOnly: !_isEditing,
                        ),
                        // Phone Number Field
                        SizedBox(height: 10 * fem),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Phone Number',
                            prefixIcon: Icon(Icons.phone),
                          ),
                          controller: numbController,
                          readOnly: !_isEditing,
                        ),
                        // Email Field
                        SizedBox(height: 10 * fem),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                          ),
                          controller: emailController,
                          readOnly: !_isEditing,
                        ),
                        // Save/Edit Button
                        SizedBox(height: 20 * fem),
                        ElevatedButton(
                          onPressed: _isEditing ? _saveProfile : _toggleEdit,
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
                          child: Text(_isEditing ? 'SAVE' : 'EDIT'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fully_tamil/pages/history.dart';
import 'package:fully_tamil/pages/login/routes.dart';
import 'package:fully_tamil/pages/login/home_page.dart';
import 'package:fully_tamil/pages/profile.dart';
import 'package:fully_tamil/pages/login/shared_preferences_service.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<NavBar> {
  final PrefService _prefService = PrefService();
  String profileName = '';

  @override
  void initState() {
    super.initState();
    _loadProfileName();
  }

  Future<void> _loadProfileName() async {
    final name = await ProfilePage.fetchProfileName();
    setState(() {
      profileName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.green,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'வாழ்க தமிழ்',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: Image.asset(
                        'assets/Tamil_Logo.png', // Replace with the path to your logo
                        height: 50, // Adjust the height as needed
                        width: 50, // Adjust the width as needed
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      profileName, // Display the fetched profile name here
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('History Page'),
            onTap: () {
              // Navigate to the history page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HistoryPage(
                    history: [],
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('YOUR PROFILE'),
            onTap: () {
              // Navigate to the profile page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ),
              ).then((_) {
                _loadProfileName(); // Refresh profile name after returning
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              // Handle the "Logout" option here.
              // Perform logout action.
              _confirmLogout(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    // logout
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Perform logout action here.
                // After logging out, navigate back to the login page.
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const Home()),
                );
                await _prefService.removeCache("password").whenComplete(() {
                  Navigator.of(context).pushNamed(LoginRoute);
                });
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}

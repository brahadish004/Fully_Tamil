import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fully_tamil/pages/tamtolantranslate.dart';
import 'package:fully_tamil/pages/testtranslate.dart';
import 'package:fully_tamil/pages/NavBar.dart';
import 'package:fully_tamil/pages/upaudio.dart';
import 'package:fully_tamil/pages/texttospeech.dart';
import 'package:fully_tamil/pages/realtime.dart';
import 'package:fully_tamil/pages/spellcheck_ui.dart';
import 'package:fully_tamil/pages/thirukural_bot.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<bool> _onBackPressed() async {
    bool? result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Fully Tamil?'),
        content: const Text('Do you want to exit the app?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    return result ?? false; // If result is null, default to false
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        drawer: const NavBar(),
        appBar: AppBar(
          backgroundColor: const Color(0xFF3EAF0E),
          title: const Text('Fully Tamil'),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0, -1),
              end: Alignment(-1.158, 1.141),
              colors: <Color>[Color(0xFF3EAF0E), Color(0xffb8c9b0)],
              stops: <double>[0.008, 0.896],
            ),
          ),
          child: Column(
            children: [
              Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.only(top: 20),
                child: Image.asset(
                  'assets/Tamil_Logo.png', // Replace with the path to your logo
                  height: 250, // Adjust the height as needed
                  width: 150, // Adjust the width as needed
                ),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(16.0),
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  children: <Widget>[
                    _buildGridButton(
                      context,
                      'Translator',
                      Icons.translate,
                      () => _showTranslationDialog(context),
                    ),
                    _buildGridButton(
                      context,
                      'Insert Existing Audio File',
                      Icons.audiotrack,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UploadPage(),
                        ),
                      ),
                    ),
                    _buildGridButton(
                      context,
                      'Real-time Transcription',
                      Icons.mic,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const RealTimeTranscriptionPage(),
                        ),
                      ),
                    ),
                    _buildGridButton(
                      context,
                      'Spell Checker',
                      Icons.spellcheck,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SpellCheckPage(),
                        ),
                      ),
                    ),
                    _buildGridButton(
                      context,
                      'Text to Speech',
                      Icons.text_fields,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TextToSpeechPage(),
                        ),
                      ),
                    ),
                    _buildGridButton(
                      context,
                      'Thirukural Bot',
                      Icons.library_books,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ThirukkuralBotPage(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16.0),
        backgroundColor: const Color(0xFFC4EEB4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48.0, color: Colors.green),
          const SizedBox(height: 10.0),
          Text(label, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  void _showTranslationDialog(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFC4EEB4),
        title: const Text('Which way do you want to translate?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TamilTranslation()),
            ),
            child: const Text('From Tamil'),
          ),
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TestTranslation()),
            ),
            child: const Text('To Tamil'),
          ),
        ],
      ),
    );
  }
}

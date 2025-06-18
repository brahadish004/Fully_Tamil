import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'package:flutter/services.dart';
import 'package:fully_tamil/pages/language_codes.dart';
import 'package:fully_tamil/pages/texttopdf.dart';

class TestTranslation extends StatefulWidget {
  const TestTranslation({super.key});

  @override
  State<TestTranslation> createState() => _TestTranslationState();
}

class _TestTranslationState extends State<TestTranslation> {
  String translatedText = 'Translated Text';
  String selectedLanguage = supportedLanguages.isNotEmpty
      ? supportedLanguages[0]['code']!
      : ''; // Default target language is English

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: translatedText));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Text copied to clipboard')));
  }

  void _showPdfOptionsAndGenerate() async {
    final options = await showPdfOptionsDialog(context);
    if (options != null) {
      await PdfSaver.generateAndOpenPdf(context, translatedText, options);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF3EAF0E),
          title: const Text(
            'Tamil Translation',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Handle the back arrow press, e.g., navigate back
              Navigator.of(context).pop();
            },
          ),
          actions: [
            IconButton(
              onPressed: _copyToClipboard,
              icon: const Icon(Icons.content_copy),
            ),
            IconButton(
              onPressed: _showPdfOptionsAndGenerate, // Use new method here
              icon: const Icon(Icons.save),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Any language'),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedLanguage,
                  decoration: InputDecoration(
                    hintText: 'Select Language',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: supportedLanguages.map((language) {
                    return DropdownMenuItem<String>(
                      value: language['code'],
                      child: Text(language['name']!),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedLanguage = value!;
                    });
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  style: Theme.of(context).textTheme.bodyLarge,
                  decoration: InputDecoration(
                    hintText: 'Enter Text',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (text) async {
                    final translation = await text.translate(
                      from: selectedLanguage,
                      to: 'ta',
                    );
                    setState(() {
                      translatedText = translation.text;
                    });
                  },
                ),
                const Divider(height: 30),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 410),
                  // Adjust the vertical padding here
                  child: SingleChildScrollView(
                    padding: EdgeInsets
                        .zero, // Reset the padding of the SingleChildScrollView
                    physics:
                        const NeverScrollableScrollPhysics(), // Disable scrolling of SingleChildScrollView
                    scrollDirection: Axis.vertical, // Ensure vertical scrolling
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      // Align content to the top left
                      child: SelectableText(
                        translatedText,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w300,
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

void main() {
  runApp(const TestTranslation());
}

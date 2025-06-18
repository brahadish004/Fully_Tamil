import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'package:flutter/services.dart';
import 'package:fully_tamil/pages/language_codes.dart'; // Ensure you have the language_codes.dart file with supportedLanguages list
import 'package:fully_tamil/pages/texttopdf.dart';

class TamilTranslation extends StatefulWidget {
  const TamilTranslation({super.key});

  @override
  State<TamilTranslation> createState() => _TestTranslationState();
}

class _TestTranslationState extends State<TamilTranslation> {
  String translatedText = 'Translated Text';
  String selectedLanguage = supportedLanguages.isNotEmpty
      ? supportedLanguages[0]['code']!
      : '';

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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text(
            'Tamil Translation',
            style: TextStyle(color: Colors.white),
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
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('From Tamil to:'),
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
                      hintText: 'Enter Tamil Text',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (text) async {
                      final translation = await text.translate(
                        to: selectedLanguage,
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
                    child: SingleChildScrollView(
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
      ),
    );
  }
}

void main() {
  runApp(const TamilTranslation());
}

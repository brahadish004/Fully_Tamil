import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:flutter/services.dart';

// Import your PDF related classes here
import 'package:fully_tamil/pages/texttopdf.dart'; // Make sure this includes PdfSaver and showPdfOptionsDialog

class RealTimeTranscriptionPage extends StatefulWidget {
  const RealTimeTranscriptionPage({super.key});

  @override
  _RealTimeTranscriptionPageState createState() =>
      _RealTimeTranscriptionPageState();
}

class _RealTimeTranscriptionPageState extends State<RealTimeTranscriptionPage> {
  late SpeechToText _speechToText;
  bool _speechEnabled = false;
  String _wordsSpoken = "";

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    _speechToText = SpeechToText();
    _speechEnabled = await _speechToText.initialize(
      onError: (errorNotification) {
        print('Speech error: $errorNotification');
      },
    );
    setState(() {});
  }

  void _startListening() async {
    if (!_speechToText.isListening) {
      await _speechToText.listen(
        onResult: _onSpeechResult,
        localeId: 'ta-IN', // Tamil locale
      );
    }
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _wordsSpoken = result.recognizedWords;
    });
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _wordsSpoken));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Text copied to clipboard')));
  }

  // New method to show options dialog, then generate PDF with selected options
  void _showPdfOptionsAndGenerate() async {
    final options = await showPdfOptionsDialog(context);
    if (options != null) {
      await PdfSaver.generateAndOpenPdf(context, _wordsSpoken, options);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3EAF0E),
        title: const Text('வாழ்க தமிழ்', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
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
      body: Center(
        child: Column(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Text(
                _speechToText.isListening
                    ? "Listening..."
                    : _speechEnabled
                    ? "Tap the microphone to start listening..."
                    : "Speech not available",
                style: const TextStyle(fontSize: 20.0),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 100),
                child: SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: SelectableText(
                      _wordsSpoken,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _speechToText.isListening ? _stopListening : _startListening,
        tooltip: 'Listen',
        backgroundColor: const Color(0xFF3EAF0E),
        child: Icon(
          _speechToText.isNotListening ? Icons.mic_off : Icons.mic,
          color: Colors.white,
        ),
      ),
    );
  }
}

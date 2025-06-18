import 'dart:io';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final stt.SpeechToText _speechToText = stt.SpeechToText();

  bool _speechEnabled = false;
  String _wordsSpoken = "";
  double _confidenceLevel = 0;

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize(
      onStatus: (status) {
        print('Speech status: $status');
      },
      onError: (errorNotification) {
        print('Speech error: $errorNotification');
      },
    );
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(
      onResult: _onSpeechResult,
      localeId: 'ta-IN', // Set the locale to Tamil (India)
    );
    setState(() {
      _confidenceLevel = 0;
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(result) {
    setState(() {
      _wordsSpoken = "${result.recognizedWords}";
      _confidenceLevel = result.confidence;
    });
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _wordsSpoken));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Text copied to clipboard'),
      ),
    );
  }

  Future<void> _convertToPdf() async {
    final pdfWidgets.Document pdf = pdfWidgets.Document();

    // Load the font from the asset
    final ByteData fontData =
    await rootBundle.load('assets/fonts/NotoSansTamil-Regular.ttf');
    final Uint8List fontUint8List = fontData.buffer.asUint8List();

    // Convert Uint8List to ByteData
    final ByteData fontByteData = ByteData.sublistView(fontUint8List);

    // Assuming 'NotoSansTamil' is a font with Tamil characters.
    final pdfWidgets.Font ttfFont = pdfWidgets.Font.ttf(fontByteData);

    pdf.addPage(
      pdfWidgets.Page(
        build: (context) => pdfWidgets.Center(
          child: pdfWidgets.Text(
            _wordsSpoken,
            style: pdfWidgets.TextStyle(font: ttfFont),
          ),
        ),
      ),
    );

    final directory = await getExternalStorageDirectory();
    final file = File('${directory!.path}/transcription.pdf');
    await file.writeAsBytes(await pdf.save());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('PDF saved to ${file.path}'),
      ),
    );
  }

  Future<void> _pickAudioFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
      );

      if (result != null) {
        String filePath = result.files.single.path!;
        // Now you can use the filePath to transcribe the audio content
        // using the speech-to-text library.
        print("Selected Audio File: $filePath");

        // Get audio content from the selected file
        final audioContent = await _getAudioContent(filePath);

        // Start listening for speech
        _startListening();
      }
    } catch (e) {
      print("Error picking audio file: $e");
    }
  }

  Future<List<int>> _getAudioContent(String name) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$name';
    return File(path).readAsBytes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3EAF0E),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.white),
          onPressed: () {
            // Handle the back arrow press, e.g., navigate back
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'வாழ்க தமிழ்',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _copyToClipboard,
            icon: const Icon(Icons.content_copy),
          ),
          IconButton(
            onPressed: _convertToPdf,
            icon: const Icon(Icons.picture_as_pdf),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                _speechToText.isListening
                    ? "Listening..."
                    : _speechEnabled
                    ? "Your Transcription will appear here..."
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
                // Adjust the vertical padding here
                child: SingleChildScrollView(
                  padding: EdgeInsets.zero, // Reset the padding of the SingleChildScrollView
                  physics: const NeverScrollableScrollPhysics(), // Disable scrolling of SingleChildScrollView
                  scrollDirection: Axis.vertical, // Ensure vertical scrolling
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: _wordsSpoken.isNotEmpty
                        ? SelectableText(
                      _wordsSpoken,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w300,
                      ),
                    )
                        : const Text(
                      'Temporarily not available',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w300,
                      ),
                    ),

                  ),
                ),),
            ),
            if (_speechToText.isNotListening && _confidenceLevel > 0)
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 100,
                ),
                child: Text(
                  "Confidence: ${(_confidenceLevel * 100).toStringAsFixed(1)}%",
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickAudioFile,
        tooltip: 'Pick Audio File',
        backgroundColor: Colors.blue,
        child: const Icon(Icons.file_upload, color: Colors.white),
      ),
    );
  }
}

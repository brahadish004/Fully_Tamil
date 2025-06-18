import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fully_tamil/pages/groq_api.dart';
import 'package:fully_tamil/pages/texttopdf.dart';

class SpellCheckPage extends StatefulWidget {
  const SpellCheckPage({super.key});

  @override
  _SpellCheckPageState createState() => _SpellCheckPageState();
}

class _SpellCheckPageState extends State<SpellCheckPage> {
  final _textController = TextEditingController();
  String correctedText = '';
  bool isLoading = false;

  void _checkSpelling() async {
    final inputText = _textController.text.trim();
    if (inputText.isEmpty) return;

    setState(() {
      isLoading = true;
      correctedText = '';
    });

    try {
      final result = await GeminiService.checkTamilSpelling(inputText);
      setState(() {
        correctedText = result;
      });
    } catch (e) {
      setState(() {
        correctedText = 'பிழை: API சேவை தோல்வி.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showPdfOptionsAndGenerate() async {
    final options = await showPdfOptionsDialog(context);
    if (options != null) {
      await PdfSaver.generateAndOpenPdf(context, correctedText, options);
    }
  }

  void _copyToClipboard() {
    if (correctedText.isEmpty) return;

    Clipboard.setData(ClipboardData(text: correctedText));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Text copied to clipboard')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3EAF0E),
        title: const Text('வாழ்க தமிழ்', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            onPressed: _copyToClipboard,
            icon: const Icon(Icons.content_copy, color: Colors.white),
          ),
          IconButton(
            onPressed: _showPdfOptionsAndGenerate, // Use new method here
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'தமிழில் ஒரு வாக்கியம் உள்ளிடுங்கள்',
                border: OutlineInputBorder(),
              ),
              minLines: 1,
              maxLines: 5,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _checkSpelling,
              child: const Text('பிழை திருத்தம்'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3EAF0E),
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            if (isLoading)
              const CircularProgressIndicator()
            else if (correctedText.isNotEmpty)
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: SelectableText(
                      correctedText,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

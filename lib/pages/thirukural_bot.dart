import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fully_tamil/pages/thirukural_service.dart'; // Make sure this path is correct
import 'package:fully_tamil/pages/texttopdf.dart';

class ThirukkuralBotPage extends StatefulWidget {
  const ThirukkuralBotPage({super.key});

  @override
  _ThirukkuralBotPageState createState() => _ThirukkuralBotPageState();
}

class _ThirukkuralBotPageState extends State<ThirukkuralBotPage> {
  final _textController = TextEditingController();
  String botResponse = '';
  bool isLoading = false;

  void _askKuralBot() async {
    final inputText = _textController.text.trim();
    if (inputText.isEmpty) return;

    FocusScope.of(context).unfocus(); // Hide keyboard
    setState(() {
      isLoading = true;
      botResponse = '';
    });

    try {
      final result = await GeminiThirukkuralService.askGeminiSmart(inputText);
      setState(() {
        botResponse = result;
      });
    } catch (e) {
      setState(() {
        botResponse = 'பிழை: API சேவையை அணுக முடியவில்லை.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showPdfOptionsAndGenerate() async {
    if (botResponse.trim().isEmpty) return;

    final options = await showPdfOptionsDialog(context);
    if (options != null) {
      await PdfSaver.generateAndOpenPdf(context, botResponse, options);
    }
  }

  void _copyToClipboard() {
    if (botResponse.trim().isEmpty) return;

    Clipboard.setData(ClipboardData(text: botResponse));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('பதிலை நகலெடுக்கப்பட்டது')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3EAF0E),
        title: const Text(
          'திருக்குறள் பாகுபாடு',
          style: TextStyle(color: Colors.white),
        ),
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
            onPressed: _showPdfOptionsAndGenerate,
            icon: const Icon(Icons.save, color: Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _askKuralBot(),
              decoration: const InputDecoration(
                labelText: 'உங்கள் கேள்வியை தமிழில் உள்ளிடுங்கள்',
                border: OutlineInputBorder(),
              ),
              minLines: 1,
              maxLines: 5,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _askKuralBot,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3EAF0E),
                foregroundColor: Colors.white,
              ),
              child: const Text('திருக்குறள் பதில் பெற'),
            ),
            const SizedBox(height: 20),
            if (isLoading)
              const CircularProgressIndicator()
            else if (botResponse.isNotEmpty)
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
                      botResponse,
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

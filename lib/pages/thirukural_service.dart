import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

class GeminiThirukkuralService {
  static const _apiKey = 'AIzaSyDK3E5yniDImVd1HE80PtyNZBYN_5MvDQE';
  static const _endpoint =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$_apiKey';

  static List<Map<String, String>> _parsedKuralData = [];

  /// Load and parse the Thirukkural data only once
  static Future<void> loadJsonOnlyData() async {
    if (_parsedKuralData.isNotEmpty) return;

    final rawJsonString = await rootBundle.loadString('assets/all_kural.json');
    final List<dynamic> rawList = json.decode(rawJsonString);

    for (final entry in rawList) {
      final cleaned = entry.toString().trim();

      final regExpMap = {
        'number': RegExp(r'குறள் எண்:\s*(\d+)'),
        'section': RegExp(r'அதிகாரம்:\s*(.*)'),
        'chapter': RegExp(r'குறள் இயல்:\s*(.*)'),
        'division': RegExp(r'குறள் பால்:\s*(.*)'),
        'kural': RegExp(r'குறள்\s*-\s*(.*?)\n\s*(.*?)\n'),
        'explanation': RegExp(r'குறள் விளக்கம்:\s*((.|\n)*?)\n\n'),
      };

      final match = {
        'number': regExpMap['number']?.firstMatch(cleaned)?.group(1) ?? '',
        'section':
            regExpMap['section']?.firstMatch(cleaned)?.group(1)?.trim() ?? '',
        'chapter':
            regExpMap['chapter']?.firstMatch(cleaned)?.group(1)?.trim() ?? '',
        'division':
            regExpMap['division']?.firstMatch(cleaned)?.group(1)?.trim() ?? '',
        'line1': '',
        'line2': '',
        'explanation': '',
      };

      final kuralMatch = regExpMap['kural']?.firstMatch(cleaned);
      if (kuralMatch != null) {
        match['line1'] = kuralMatch.group(1)?.trim() ?? '';
        match['line2'] = kuralMatch.group(2)?.trim() ?? '';
      }

      final explanationMatch = regExpMap['explanation']?.firstMatch(cleaned);
      if (explanationMatch != null) {
        match['explanation'] = explanationMatch.group(1)?.trim() ?? '';
      }

      _parsedKuralData.add(match);
    }
  }

  /// Answer user queries smartly using Gemini and all Kural data
  static Future<String> askGeminiSmart(String userQuery) async {
    try {
      await loadJsonOnlyData();

      final lowerQuery = userQuery.toLowerCase().trim();

      // First try matching by exact section (அதிகாரம்) name
      final sectionMatch = _parsedKuralData.firstWhere(
        (entry) => entry['section']!.toLowerCase().contains(lowerQuery),
        orElse: () => {},
      );

      List<Map<String, String>> matchedKurals = [];

      if (sectionMatch.isNotEmpty) {
        final sectionName = sectionMatch['section'];
        matchedKurals = _parsedKuralData
            .where((entry) => entry['section'] == sectionName)
            .toList();
      } else {
        // Fallback: match using line, explanation, or chapter
        matchedKurals = _parsedKuralData
            .where(
              (entry) =>
                  entry['line1']!.toLowerCase().contains(lowerQuery) ||
                  entry['line2']!.toLowerCase().contains(lowerQuery) ||
                  entry['explanation']!.toLowerCase().contains(lowerQuery) ||
                  entry['chapter']!.toLowerCase().contains(lowerQuery),
            )
            .toList();
      }

      if (matchedKurals.isEmpty) {
        return 'மன்னிக்கவும், உங்கள் கேள்விக்கு பொருத்தமான குறள் அல்லது அதிகாரம் கிடைக்கவில்லை.';
      }

      final formattedMatches = matchedKurals.map((e) {
        return {
          'பால்': e['division'],
          'இயல்': e['chapter'],
          'அதிகாரம்': e['section'],
          'குறள் எண்': e['number'],
          'குறள்': '${e['line1']}\n${e['line2']}',
          'விளக்கம்': e['explanation'],
        };
      }).toList();

      final prompt =
          '''
நீங்கள் திருக்குறள் உதவியாளராக செயல்படுகிறீர்கள்.

பயனர் கேள்விக்கு கீழ்க்கண்ட குறள் தரவுகளை வைத்து, நட்பு மற்றும் விளக்கத்துடன் கூடிய பதிலை தமிழில் உருவாக்குங்கள்.

**பதிலின் வடிவம்**:

பால்: <பால்>
இயல்: <இயல்>
அதிகாரம்: <அதிகாரம்>

குறள் எண்: <எண்>  
<குறள் 2 வரிகள்>  
விளக்கம்: <விளக்கம்>  

**அனைத்து குறள்களும் ஒரே அதிகாரத்தில் இருந்தால்**, பால், இயல், அதிகாரத்தை ஒருமுறை மட்டும் கொடுக்கவும். இல்லையெனில் ஒவ்வொரு குறளுக்கும் உரிய பால், இயல், அதிகாரம் குறிப்பிடவும்(all above their respective kurals. not grouped but group if same அதிகாரம் ).

தரவு:
${jsonEncode(formattedMatches)}

பயனர் கேள்வி: "$userQuery"
''';

      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt},
              ],
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'].trim();
      } else {
        return 'பிழை: ${response.statusCode} - ${response.reasonPhrase}';
      }
    } catch (e) {
      return 'பிழை ஏற்பட்டது: $e';
    }
  }
}

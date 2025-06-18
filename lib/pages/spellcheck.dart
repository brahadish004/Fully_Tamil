import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class TamilSpellChecker {
  Set<String> _dictionary = {};

  Future<void> loadDictionary() async {
    final data = await rootBundle.loadString('assets/tamil_words.txt');
    _dictionary = data.split('\n').map((e) => e.trim()).toSet();
  }

  bool isCorrect(String word) {
    return _dictionary.contains(word);
  }

  List<String> getSuggestions(String word) {
    // Optional: implement fuzzy matching here
    return _dictionary
        .where((w) => _levenshtein(w, word) <= 2)
        .take(5)
        .toList();
  }

  int _levenshtein(String s, String t) {
    final m = s.length;
    final n = t.length;
    final dp = List.generate(m + 1, (_) => List.filled(n + 1, 0));

    for (int i = 0; i <= m; i++) dp[i][0] = i;
    for (int j = 0; j <= n; j++) dp[0][j] = j;

    for (int i = 1; i <= m; i++) {
      for (int j = 1; j <= n; j++) {
        final cost = s[i - 1] == t[j - 1] ? 0 : 1;
        dp[i][j] = [
          dp[i - 1][j] + 1,
          dp[i][j - 1] + 1,
          dp[i - 1][j - 1] + cost,
        ].reduce((a, b) => a < b ? a : b);
      }
    }

    return dp[m][n];
  }
}

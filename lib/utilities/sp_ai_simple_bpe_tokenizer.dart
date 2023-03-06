import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart' show rootBundle;
import 'package:sp_ai_simple_bpe_tokenizer/models/sp_token_container.dart';

/// A regular expression pattern that matches text tokens in natural language.
/// The pattern matches words with common English contractions (e.g. "it's", "they're"),
/// words composed of letters, words composed of numbers, words composed of special characters (excluding whitespace), and whitespace characters.
final pat = RegExp(r"'s|'t|'re|'ve|'m|'ll|'d| ?\p{L}+| ?\p{N}+| ?[^\s\p{L}\p{N}]+|\s+(?!\S)|\s+", unicode: true);

/// A function that returns a map of integers to Unicode strings.
/// It generates a mapping from byte values to Unicode characters, including printable ASCII characters, Spanish characters, and some special characters.
final byteEncoder = bytesToUnicode();

/// A function that generates a list of integers between x (inclusive) and y (exclusive) using the List.generate() method. It returns the generated list.
List<int> range(int x, int y) => List.generate(y, (i) => i).sublist(x);

/// A function that returns a map of Unicode strings to integers.
Map<dynamic, dynamic> dictZip(List<dynamic> x, List<dynamic> y) {
  /// A function that zips two lists into a map. It takes two lists x and y of the same length,
  /// creates a new map, and assigns each element in x as a key and the corresponding element in y as a value in the map.
  /// It returns the resulting map.
  Map<dynamic, dynamic> result = {};
  for (int i = 0; i < x.length; i++) {
    result[x[i]] = y[i];
  }
  return result;
}

/// A function that returns a map of integers to Unicode strings.
Map<int, String> bytesToUnicode() {
  /// A function that returns a map of integers to Unicode strings.
  /// It generates a mapping from byte values to Unicode characters, including printable ASCII characters, Spanish characters, and some special characters.
  /// It first generates a list of byte values, creates a second list by copying the first one, and then appends any byte values that are not in the first list to both lists.
  /// It then maps each byte value in the resulting list to its corresponding Unicode character and returns the resulting map.
  final bs = List<int>.from(List.generate(95, (i) => '!'.codeUnitAt(0) + i)).followedBy(List.generate(174 - 161 + 1, (i) => '¡'.codeUnitAt(0) + i)).followedBy(List.generate(255 - 174 + 1, (i) => '®'.codeUnitAt(0) + i)).toList();

  var cs = List<int>.from(bs);
  var n = 0;
  for (var b = 0; b < 256; b++) {
    if (!bs.contains(b)) {
      bs.add(b);
      cs.add(256 + n);
      n = n + 1;
    }
  }

  List<String> tmp = cs.map((x) => String.fromCharCode(x)).toList();

  final result = <int, String>{};
  for (var i = 0; i < bs.length; i++) {
    result[bs[i]] = tmp[i];
  }
  return result;
}

/// A class that implements a simple BPE (Byte Pair Encoding) tokenizer.
class SPAiSimpleBpeTokenizer {
  static SPAiSimpleBpeTokenizer? _instance;

  /// A factory constructor that returns a singleton instance of SPGPTTokenizer.
  /// If an instance has already been created, it returns the existing instance. Otherwise, it creates a new instance of SPGPTTokenizer.
  factory SPAiSimpleBpeTokenizer() => _instance ??= SPAiSimpleBpeTokenizer._();

  /// A private constructor for SPGPTTokenizer that initializes the instance of the class.
  SPAiSimpleBpeTokenizer._();

  /// A private member variable for caching encoded text tokens.
  final Map<dynamic, dynamic> _tokenCache = {};

  /// A private member variable for caching an encoding dictionary that maps tokens to integer values.
  Map<String, dynamic>? _encoder;

  /// A private member variable for caching a dictionary of BPE (Byte Pair Encoding) ranks that maps pairs of tokens to integer values.
  Map<List<String>, int>? _bpeRanks;

  /// A private member variable for caching a list of BPE (Byte Pair Encoding) merges.
  Future<SPTokenContainer> encodeString(String stringToEncode) async {
    /// A function that encodes a given text string into a list of integer tokens.
    /// It first encodes the string using UTF-8, applies BPE to the encoded string, and then maps each BPE token to an integer value using the encoding dictionary.
    /// It returns an SPTokenContainer object that contains the encoded tokens, the number of tokens, and the number of characters in the original string.
    _encoder ??= await _loadEncoder();
    _bpeRanks ??= await _loadBpeRanks();

    List<int> bpeTokens = [];
    List<String?> matches = pat.allMatches(stringToEncode).map((match) => match.group(0)).toList();
    for (String? match in matches) {
      if (match != null) {
        List<int> encodedList = _encodeStr(match);
        String token = encodedList.map((e) => byteEncoder[e]).join('');
        String bpeToken = _bpe(token, _bpeRanks!);
        List<String> charList = bpeToken.split(' ');

        List<int>? newTokens = charList
            .map((String x) {
              if (_encoder!.containsKey(x)) {
                return _encoder![x];
              } else {
                return _encoder!['!'];
              }
            })
            .cast<int>()
            .toList();
        bpeTokens.addAll(newTokens);
      }
    }

    return SPTokenContainer(
      tokens: bpeTokens,
      tokenCount: bpeTokens.length,
      characterCount: stringToEncode.length,
    );
  }

  /// A private member variable for caching a list of BPE (Byte Pair Encoding) merges.
  List<int> _encodeStr(String str) {
    /// A private function that encodes a given string using UTF-8 and returns a list of integer values.
    final encoded = utf8.encode(str);
    return encoded.map((x) => x).toList();
  }

  /// A private member variable for caching a list of BPE (Byte Pair Encoding) merges.
  String _bpe(String token, Map<dynamic, dynamic> bpeRanks) {
    /// A private function that applies BPE to a given token using the BPE ranks dictionary.
    /// It splits the token into individual characters, generates all possible pairs of adjacent characters, and replaces the most frequent pair of characters with a new combined character.
    /// It repeats this process until no more pairs can be merged. It returns the resulting token.
    if (_tokenCache.containsKey(token)) {
      return _tokenCache[token];
    }

    List<String> wordList = token.split('');
    Set<List<String>> pairs = _getPairs(wordList);

    if (pairs.isEmpty) {
      return token;
    }

    while (true) {
      final minPairs = <int, List<String>>{};
      for (List<String> pair in pairs) {
        final rank = bpeRanks[pair];
        minPairs[(rank == null || rank.isNaN ? 1e10.toInt() : rank)] = pair;
      }

      List<String>? bigram = minPairs[minPairs.keys.map((key) => key).reduce(min)];

      if (!bpeRanks.containsKey(bigram)) {
        break;
      }

      final first = bigram![0];
      final second = bigram[1];
      final newWord = <String>[];
      var i = 0;
      while (i < wordList.length) {
        final j = wordList.indexOf(first, i);
        if (j == -1) {
          newWord.addAll(wordList.sublist(i));
          break;
        }
        newWord.addAll(wordList.sublist(i, j));
        i = j;

        if (wordList[i] == first && i < wordList.length - 1 && wordList[i + 1] == second) {
          newWord.add(first + second);
          i += 2;
        } else {
          newWord.add(wordList[i]);
          i++;
        }
      }
      wordList = newWord;

      if (wordList.length == 1) {
        break;
      } else {
        pairs = _getPairs(wordList);
      }
    }

    String word = wordList.join('');
    _tokenCache[token] = word;

    return word;
  }

  /// A private member variable for caching a list of BPE (Byte Pair Encoding) merges.
  Set<List<String>> _getPairs(List<String> wordList) {
    /// A private function that generates all possible pairs of adjacent characters in a given list of characters.
    final pairs = <List<String>>{};
    var prevChar = wordList[0];
    for (var i = 1; i < wordList.length; i++) {
      final char = wordList[i];
      pairs.add([prevChar, char]);
      prevChar = char;
    }
    return pairs.toSet();
  }

  /// A private member variable for caching a list of BPE (Byte Pair Encoding) merges.
  Future<Map<String, dynamic>> _loadEncoder() async {
    /// A private function that loads an encoding dictionary from a JSON file included in the package.
    /// It reads the contents of the file, parses it as a JSON object, and returns the resulting dictionary.
    final String encoderFileContent = await rootBundle.loadString('packages/sp_ai_simple_bpe_tokenizer/assets/files/encoder.json');
    Map<String, dynamic> encoder = jsonDecode(encoderFileContent);
    return encoder;
  }

  /// A private member variable for caching a list of BPE (Byte Pair Encoding) merges.
  Future<Map<List<String>, int>> _loadBpeRanks() async {
    /// A private function that loads a BPE ranks dictionary from a file included in the package.
    /// It reads the contents of the file, extracts the BPE pairs and their corresponding ranks, and returns the resulting dictionary.
    final String bpeFileContent = await rootBundle.loadString('packages/sp_ai_simple_bpe_tokenizer/assets/files/vocab.bpe');
    List<String> lines = bpeFileContent.split('\n');
    List<String> subList = lines.sublist(1, lines.length - 1);
    List<List<String>> bpeMerges = subList.map((String x) => x.split(RegExp(r'(\s+)')).where((e) => e.trim().isNotEmpty).toList()).toList();

    Map<List<String>, int> bpeRanks = {};
    for (int i = 0; i < bpeMerges.length; i++) {
      bpeRanks[bpeMerges[i]] = i;
    }
    return bpeRanks;
  }
}

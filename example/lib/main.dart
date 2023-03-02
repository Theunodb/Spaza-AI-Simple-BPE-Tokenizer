import 'package:example/core/dependency_injection.dart';
import 'package:example/ui/home_page.dart';
import 'package:flutter/material.dart';
import 'package:sp_ai_simple_bpe_tokenizer/sp_ai_simple_bpe_tokenizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DependencyInjection.init();

  /// Basic usage
  String text = 'The quick brown fox jumps over the lazy dog';
  final tokenizedText = await SPAiSimpleBpeTokenizer().encodeString(text);
  print(tokenizedText);

  runApp(const SpAiSimpleTokenizer());
}

class SpAiSimpleTokenizer extends StatelessWidget {
  const SpAiSimpleTokenizer({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'A Simple BPE Tokenizer Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
      home: const HomePage(),
    );
  }
}

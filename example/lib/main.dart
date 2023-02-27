import 'package:example/core/dependency_injection.dart';
import 'package:example/ui/home_page.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DependencyInjection.init();
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

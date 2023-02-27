import 'package:sp_ai_simple_bpe_tokenizer/sp_ai_simple_bpe_tokenizer_init.dart';

class DependencyInjection {
  static Future<void> init() async {
    await _packages();
    await _repos();
    await _cubits();
    await _main();
  }

  static Future<void> _main() async {}

  static _repos() {}

  static _cubits() async {}

  static _packages() async {
    await SPAiSimpleBpeTokenizerInitializer.initialiseDI();
  }
}

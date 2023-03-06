import 'package:sp_ai_simple_bpe_tokenizer/core/dependency_injection.dart';

/// This class is used to initialise the dependency injection.
class SPAiSimpleBpeTokenizerInitializer {
  static initialiseDI() async {
    await DependencyInjection.init();
  }
}

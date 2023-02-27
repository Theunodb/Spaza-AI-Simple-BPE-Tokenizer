
import 'package:sp_ai_simple_bpe_tokenizer/core/dependency_injection.dart';

class SPAiSimpleBpeTokenizerInitializer {
  static initialiseDI() async {
    await DependencyInjection.init();
  }
}
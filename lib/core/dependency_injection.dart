import 'package:get_it/get_it.dart';
import 'package:sp_ai_simple_bpe_tokenizer/cubits/bpe_tokenizer_cubit/bpe_tokenizer_cubit.dart';

class DependencyInjection {
  static init() async {
    await _packages();
    await _repos();
    await _cubits();
    await _main();
  }

  static _main() async {}

  static _repos() {}

  static _cubits() async => GetIt.instance.registerLazySingleton<BpeTokenizerCubit>(() => BpeTokenizerCubit());

  static _packages() async {}
}

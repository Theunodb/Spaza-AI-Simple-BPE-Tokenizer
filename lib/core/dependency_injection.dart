import 'package:get_it/get_it.dart';
import 'package:sp_ai_simple_bpe_tokenizer/cubits/bpe_tokenizer_cubit/bpe_tokenizer_cubit.dart';

/// This class is used to initialise the dependency injection.
class DependencyInjection {
  static init() => GetIt.instance
      .registerLazySingleton<BpeTokenizerCubit>(() => BpeTokenizerCubit());
}

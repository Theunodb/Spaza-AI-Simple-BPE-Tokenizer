import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_ai_simple_bpe_tokenizer/sp_ai_simple_bpe_tokenizer.dart';

part 'bpe_tokenizer_state.dart';

class BpeTokenizerCubit extends Cubit<BpeTokenizerState> {
  BpeTokenizerCubit() : super(const BpeTokenizerInitial());

  getTokenCountForString(String inputString) async {
    /// A function that takes an input string and tokenizes it using the encodeString function of the SPAiSimpleBpeTokenizer class.
    /// It returns the number of tokens in the resulting SPTokenContainer object.
    /// If the operation is successful, it emits a BpeTokenizerLoaded event with the resulting token container.
    /// If an error occurs, it emits a BpeTokenizerError event with the error message and stack trace.
    /// The emit function is a part of the flutter_bloc library and is used to emit state changes in a Bloc or Cubit.
    /// The provided code seems to be a part of a Flutter application that uses flutter_bloc for state management.
    emit(BpeTokenizerLoading(state.mainBpeTokenizerState.copyWith(message: 'Tokenizing input string...', errorMessage: '')));
    try {
      /// The encodeString function of the SPAiSimpleBpeTokenizer class takes an input string and returns a SPTokenContainer object.
      SPTokenContainer tokenContainer = await SPAiSimpleBpeTokenizer().encodeString(inputString);
      emit(BpeTokenizerLoaded(state.mainBpeTokenizerState.copyWith(message: 'Successfully tokenized input string!', tokenContainer: tokenContainer)));
    } catch (error, stackTrace) {
      emit(BpeTokenizerError(state.mainBpeTokenizerState.copyWith(message: 'Error tokenizing input string', errorMessage: error.toString()), stackTrace: stackTrace.toString()));
    }
  }

  clear() async {
    /// A function that clears the state of the BpeTokenizerCubit so that you can start over.
    emit(BpeTokenizerClearing(state.mainBpeTokenizerState.copyWith(message: 'Clearing state...', errorMessage: '')));
    try {
      emit(BpeTokenizerCleared(state.mainBpeTokenizerState.copyWithNull(message: 'Successfully cleared state!', tokenContainer: null)));
    } catch (error, stackTrace) {
      emit(BpeTokenizerError(state.mainBpeTokenizerState.copyWith(message: 'Error clearing state', errorMessage: error.toString()), stackTrace: stackTrace.toString()));
    }
  }
}

part of 'bpe_tokenizer_cubit.dart';

/// This class is used to manage the state of the BpeTokenizerCubit.
class MainBpeTokenizerState extends Equatable {
  final String? message;
  final String? errorMessage;
  final SPTokenContainer? tokenContainer;

  @override
  List<Object?> get props => [message, errorMessage, tokenContainer];

  const MainBpeTokenizerState(
      {this.message, this.errorMessage, this.tokenContainer});

  MainBpeTokenizerState copyWith(
      {String? message,
      String? errorMessage,
      SPTokenContainer? tokenContainer}) {
    return MainBpeTokenizerState(
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
      tokenContainer: tokenContainer ?? this.tokenContainer,
    );
  }

  MainBpeTokenizerState copyWithNull(
      {String? message,
      String? errorMessage,
      SPTokenContainer? tokenContainer}) {
    return MainBpeTokenizerState(
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
      tokenContainer: null,
    );
  }
}

/// This class is used to manage the state of the BpeTokenizerCubit.
abstract class BpeTokenizerState extends Equatable {
  final MainBpeTokenizerState mainBpeTokenizerState;

  const BpeTokenizerState(this.mainBpeTokenizerState);

  @override
  List<Object> get props => [mainBpeTokenizerState];
}

/// The initial state of the BpeTokenizerCubit.
class BpeTokenizerInitial extends BpeTokenizerState {
  const BpeTokenizerInitial() : super(const MainBpeTokenizerState());
}

/// The state of the BpeTokenizerCubit when it is loading.
class BpeTokenizerLoading extends BpeTokenizerState {
  const BpeTokenizerLoading(MainBpeTokenizerState mainBpeTokenizerState)
      : super(mainBpeTokenizerState);
}

/// The state of the BpeTokenizerCubit when it has successfully loaded.
class BpeTokenizerLoaded extends BpeTokenizerState {
  const BpeTokenizerLoaded(MainBpeTokenizerState mainBpeTokenizerState)
      : super(mainBpeTokenizerState);
}

/// The state of the BpeTokenizerCubit when it is clearing.
class BpeTokenizerClearing extends BpeTokenizerState {
  const BpeTokenizerClearing(MainBpeTokenizerState mainBpeTokenizerState)
      : super(mainBpeTokenizerState);
}

/// The state of the BpeTokenizerCubit when it has successfully cleared.
class BpeTokenizerCleared extends BpeTokenizerState {
  const BpeTokenizerCleared(MainBpeTokenizerState mainBpeTokenizerState)
      : super(mainBpeTokenizerState);
}

/// The state of the BpeTokenizerCubit when it has encountered an error. Prints the error to the console in debug mode.
class BpeTokenizerError extends BpeTokenizerState {
  final String? stackTrace;

  BpeTokenizerError(MainBpeTokenizerState mainBpeTokenizerState,
      {this.stackTrace})
      : super(mainBpeTokenizerState) {
    if (kDebugMode) {
      log('ERROR: ${mainBpeTokenizerState.errorMessage}');
      log('ERROR: $stackTrace');
    }
  }
}

part of 'bpe_tokenizer_cubit.dart';

class MainBpeTokenizerState extends Equatable {
  final String? message;
  final String? errorMessage;
  final SPTokenContainer? tokenContainer;

  @override
  List<Object?> get props => [message, errorMessage, tokenContainer];

  const MainBpeTokenizerState({this.message, this.errorMessage, this.tokenContainer});

  MainBpeTokenizerState copyWith({String? message, String? errorMessage, SPTokenContainer? tokenContainer}) {
    return MainBpeTokenizerState(
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
      tokenContainer: tokenContainer ?? this.tokenContainer,
    );
  }
  MainBpeTokenizerState copyWithNull({String? message, String? errorMessage, SPTokenContainer? tokenContainer}) {
    return MainBpeTokenizerState(
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
      tokenContainer: null,
    );
  }
}

abstract class BpeTokenizerState extends Equatable {
  final MainBpeTokenizerState mainBpeTokenizerState;

  const BpeTokenizerState(this.mainBpeTokenizerState);

  @override
  List<Object> get props => [mainBpeTokenizerState];
}

class BpeTokenizerInitial extends BpeTokenizerState {
  const BpeTokenizerInitial() : super(const MainBpeTokenizerState());
}

class BpeTokenizerLoading extends BpeTokenizerState {
  const BpeTokenizerLoading(MainBpeTokenizerState mainBpeTokenizerState) : super(mainBpeTokenizerState);
}

class BpeTokenizerLoaded extends BpeTokenizerState {
  const BpeTokenizerLoaded(MainBpeTokenizerState mainBpeTokenizerState) : super(mainBpeTokenizerState);
}
class BpeTokenizerClearing extends BpeTokenizerState {
  const BpeTokenizerClearing(MainBpeTokenizerState mainBpeTokenizerState) : super(mainBpeTokenizerState);
}

class BpeTokenizerCleared extends BpeTokenizerState {
  const BpeTokenizerCleared(MainBpeTokenizerState mainBpeTokenizerState) : super(mainBpeTokenizerState);
}

class BpeTokenizerError extends BpeTokenizerState {
  final String? stackTrace;

  BpeTokenizerError(MainBpeTokenizerState mainBpeTokenizerState, {this.stackTrace}) : super(mainBpeTokenizerState) {
    if (kDebugMode) {
      log('ERROR: ${mainBpeTokenizerState.errorMessage}');
      log('ERROR: $stackTrace');
    }
  }
}

# Spaza AI - Simple BPE Tokenizer

This package provides a set of tools for processing text using the GPT family of models. The GPT models process text using tokens, which are common sequences of characters found in text. The models understand the statistical relationships between these tokens, and excel at producing the next token in a sequence of tokens.

The `getTokenCountForString` function that takes an input string and tokenizes it. It returns the number of tokens in the resulting `SPTokenContainer` object.

The `SPTokenContainer` model is a simple data class that represents a container for the results of tokenizing a text input. It has three properties:

- `tokens`: An list of integers that represents the encoded text. Each integer in the list corresponds to a unique token in the original text.


- `tokenCount`: An integer that represents the number of tokens in the encoded text.


- `characterCount`: An integer that represents the number of characters in the original text.


The `SPTokenContainer` model is used in the `getTokenCountForString` function to store the results of the tokenization process. It can be used to access the encoded tokens and their counts, as well as the original character count of the input text. 


## Features

The package provides a tool for tokenizing text inputs, which can be used to convert a piece of text into a sequence of tokens.

## Getting started

Add the package to your project by adding the following line to your pubspec.yaml file:
```yaml
dependencies:
  sp_ai_simple_bpe_tokenizer: ^0.0.1+1
```

## Usage

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  String text = 'The quick brown fox jumps over the lazy dog';
  final tokenizedText = await SPAiSimpleBpeTokenizer().encodeString(text);
  print(tokenizedText);
}
```

## Additional information

The package includes a basic vocabulary file that is used for the tokenization process. This file is located in the `assets` folder of the package, and is loaded into memory when the package is initialized. The vocabulary file contains 50,257 tokens, and is based on the GPT2 model vocabulary file.

Because of the limited vocabulary size, the tokenizer might miss some unique words or phrases that's not included in the vocabulary file. This can be mitigated by adding the missing tokens to the vocabulary file, and recompiling the package.

## License

The getTokenCountForString function is a part of the gpt_flutter package, which is licensed under the MIT License.

## Authors
[www.spaza.com](https://www.spaza.com)

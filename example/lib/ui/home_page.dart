import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sp_ai_simple_bpe_tokenizer/cubits/bpe_tokenizer_cubit/bpe_tokenizer_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final BpeTokenizerCubit _bpeTokenizerCubit = GetIt.instance<BpeTokenizerCubit>();
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BpeTokenizerCubit, BpeTokenizerState>(
      bloc: _bpeTokenizerCubit,
      builder: (context, state) {
        return Scaffold(
          appBar: _appBar(),
          body: _content(state),
          bottomSheet: _keyboardSection(state),
        );
      },
    );
  }

  Widget _keyboardSection(BpeTokenizerState state) {
    return SafeArea(
      child: SizedBox(
        height: 144,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _messageController,
                autocorrect: false,
                decoration: const InputDecoration(label: Text('Enter your message')),
                onChanged: (change) {
                  _bpeTokenizerCubit.getTokenCountForString(change);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _content(BpeTokenizerState state) {
    return  Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  const Text('Tokens'),
                  Text('${state.mainBpeTokenizerState.tokenContainer?.tokenCount ?? '0'}'),
                ],
              ),
              const SizedBox(width: 16),
              Column(
                children: [
                  const Text('Characters'),
                  Text('${state.mainBpeTokenizerState.tokenContainer?.characterCount ?? '0'}'),
                ],
              ),
            ],
          ),
          const Text('Tokens '),
          Text('${state.mainBpeTokenizerState.tokenContainer?.tokens ?? '0'}'),
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text('Simple Bpe Tokenizer'),
    );
  }

}

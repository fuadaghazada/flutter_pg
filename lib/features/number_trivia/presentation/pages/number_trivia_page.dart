import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pg/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:flutter_pg/features/number_trivia/presentation/widgets/loading_widget.dart';
import 'package:flutter_pg/features/number_trivia/presentation/widgets/message_display.dart';
import 'package:flutter_pg/features/number_trivia/presentation/widgets/trivia_display.dart';
import 'package:flutter_pg/injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
      ),
      body: buildBody(context),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              // Top half
              SizedBox(height: 10.0),
              Container(
                height: MediaQuery.of(context).size.height / 3,
                child: BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                  builder: (context, state) {
                    if (state is Empty) {
                      return MessageDisplay(
                        message: 'Start searching',
                      );
                    } else if (state is Loading) {
                      return LoadingWidget();
                    } else if (state is Loaded) {
                      return TriviaDisplay(trivia: state.trivia);
                    } else if (state is Error) {
                      return MessageDisplay(
                        message: state.message,
                      );
                    }
                    return Placeholder();
                  },
                ),
              ),
              SizedBox(height: 20.0),
              // Bottom  half
              Column(
                children: [
                  Placeholder(fallbackHeight: 40),
                  SizedBox(height: 10.0),
                  Row(
                    children: [
                      Expanded(
                        child: Placeholder(fallbackHeight: 30),
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: Placeholder(fallbackHeight: 30),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

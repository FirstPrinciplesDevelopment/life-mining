import 'package:flutter/material.dart';

/// A [Scaffold] with an error message, and an [AppBar] to navigate back.
class ErrorIndicator extends StatelessWidget {
  const ErrorIndicator({
    required this.errorMessage,
    this.appBar,
    this.floatingActionButton,
    Key? key,
  }) : super(key: key);

  final String errorMessage;
  final AppBar? appBar;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar ??
          AppBar(
            title: const Text('Error'),
          ),
      body: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  errorMessage,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  '¯\\_(ツ)_/¯',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          color: Colors.red,
          margin: EdgeInsets.zero,
        ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}

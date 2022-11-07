import 'package:flutter/material.dart';

/// A [Scaffold] with a [CircularProgressIndicator] in the [AppBar].
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CircularProgressIndicator(
          strokeWidth: 10,
          backgroundColor: Colors.blueGrey,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      ),
    );
  }
}

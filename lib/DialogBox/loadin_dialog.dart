import 'package:campus_market/Widgets/loading_widget.dart';
import 'package:flutter/material.dart';

class LoadingAlertDialog extends StatelessWidget {

  final String message;
  LoadingAlertDialog({required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          circularProgress(),
          const SizedBox(height: 10,),
          const Text('Please wait......')
        ],
      ),
    );
  }
}

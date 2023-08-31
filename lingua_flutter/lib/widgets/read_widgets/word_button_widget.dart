import 'package:flutter/material.dart';

import 'dialog_word_widget.dart';

// ignore: camel_case_types
class WordButtonWidget extends StatelessWidget {
  final String inButtonText;
  const WordButtonWidget({
    super.key,
    required this.inButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 10,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return DialogWordWidget(
                  argText: inButtonText,
                );
              },
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Center(
                child: Text(
                  inButtonText,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

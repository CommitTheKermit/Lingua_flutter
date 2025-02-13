// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:lingua/widgets/commons/comn_dialog.dart';

class ErrorConfirmDialog extends StatefulWidget {
  const ErrorConfirmDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onTap,
  });

  final String title;
  final String content;
  final Function() onTap;

  @override
  State<ErrorConfirmDialog> createState() => _ErrorConfirmDialogState();
}

class _ErrorConfirmDialogState extends State<ErrorConfirmDialog> {
  @override
  Widget build(BuildContext context) {
    return ComnDialog(
      type: ComnDialogType.single,
      title: widget.title,
      contents: widget.content,
      customContentsPadding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      customTitlePadding: const EdgeInsets.only(
        top: 20,
      ),
      onRightTap: () {
        widget.onTap.call();
        Navigator.pop(context);
      },
    );
  }
}

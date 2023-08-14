import 'package:flutter/material.dart';
import '../services/file_process.dart';

class DialogWordWidget extends StatefulWidget {
  const DialogWordWidget({
    super.key,
  });

  @override
  State<DialogWordWidget> createState() => _DialogWordWidgetState();
}

class _DialogWordWidgetState extends State<DialogWordWidget> {
  final ScrollController _scrollController = ScrollController();
  // late String argTExt;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     dialogButton(
            //       context,
            //       '이전',
            //       Theme.of(context).cardColor,
            //     ),
            //     dialogButton(
            //       context,
            //       '다음',
            //       Theme.of(context).cardColor,
            //     ),
            //   ],
            // ),
            dialogButton(
              context,
              '닫기',
              Theme.of(context).cardColor,
            ),
          ],
        )
      ],
      contentPadding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      title: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: Center(
          child: Text(
            FileProcess.titleNovel,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      content: Container(
        decoration: BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(
              width: 2,
              color: Theme.of(context).cardColor,
            ),
          ),
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: const Column(
            children: [
              // for (var argText in widget.argTextList)
              //   Padding(
              //     padding:
              //         const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              //     child: Text(
              //       argText,
              //       style: const TextStyle(fontSize: 25),
              //     ),
              //   ),
            ],
          ),
        ),
      ),
    );
  }

  TextButton dialogButton(BuildContext context, String argText, Color color) {
    return TextButton(
      child: Text(
        argText,
        style: TextStyle(
          fontSize: 20,
          color: Theme.of(context).cardColor,
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}

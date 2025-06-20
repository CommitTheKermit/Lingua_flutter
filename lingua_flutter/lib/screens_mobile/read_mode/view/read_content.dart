import 'package:flutter/material.dart';
import 'package:lingua/screens_mobile/read_mode/view_model/read_mode_prov.dart';
import 'package:lingua/screens_mobile/read_mode/view_model/widget_build.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ReadContent extends StatefulWidget {
  const ReadContent({Key? key}) : super(key: key);

  @override
  State<ReadContent> createState() => _ReadContentState();
}

class _ReadContentState extends State<ReadContent> {
  @override
  Widget build(BuildContext context) {
    ReadModeProv readProv = Provider.of<ReadModeProv>(context);

    readProv.model.pages[readProv.model.index.toInt()];

    final spans = readProv.buildTextSpans();

    // return Expanded(
    //   child: Center(
    //     child: Padding(
    //       padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0),
    //       child: Text(
    //         readProv.model.pages[readProv.model.index.toInt()],
    //         style: readProv.model.readTextStyle,
    //       ),
    //     ),
    //   ),
    // );
    return Expanded(
      child: Center(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0),
            child: RichText(
              text: TextSpan(children: spans),
            )),
      ),
    );
  }
}

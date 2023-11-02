import 'package:flutter/material.dart';
import 'package:lingua/models/word_model.dart';
import 'package:lingua/services/api/api_util.dart';
import 'package:lingua/widgets/read_widgets/dictionary_result_widget.dart';

enum PageState {
  prev,
  current,
  next,
}

class DialogWordSearch extends StatefulWidget {
  const DialogWordSearch({
    super.key,
  });

  @override
  State<DialogWordSearch> createState() => _DialogWordSearchState();
}

class _DialogWordSearchState extends State<DialogWordSearch> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controller = TextEditingController();
  Future<List<WordModel>>? wordMeans;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // 컨트롤러의 리소스를 제거합니다.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                '닫기',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        )
      ],
      contentPadding: EdgeInsets.zero,
      insetPadding:
          const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
      title: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Center(
            child: TextField(
          controller: _controller,
          style: const TextStyle(fontSize: 22),
          autocorrect: true,
          decoration: InputDecoration(
            hintText: '검색...',
            border: InputBorder.none,
            prefixIcon: Icon(
              Icons.search,
              color: Theme.of(context).primaryColor,
              size: 40,
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  wordMeans = ApiUtil.dictSearch(_controller.text);
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.subdirectory_arrow_left,
                  color: Theme.of(context).primaryColor,
                  size: 40,
                ),
              ),
            ),
            contentPadding: const EdgeInsets.all(15.0),
          ),
        )),
      ),
      content: Container(
        decoration: BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(
              width: 2,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
            controller: _scrollController,
            child: DictionaryResultWidget(
              wordMeans: wordMeans,
              scrollController: _scrollController,
            )),
      ),
    );
  }
}

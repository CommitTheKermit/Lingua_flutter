import 'package:flutter/material.dart';
import 'package:lingua/main.dart';
import 'package:lingua/util/etc/file_process.dart';

enum PageState {
  prev,
  current,
  next,
}

class DialogLineSearch extends StatefulWidget {
  const DialogLineSearch({
    super.key,
    required this.index,
  });

  final int index;

  @override
  State<DialogLineSearch> createState() => _DialogLineSearchState();
}

class _DialogLineSearchState extends State<DialogLineSearch> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controller = TextEditingController();
  double _sliderValue = 0; // 초기값
  int index = 0;

  @override
  void initState() {
    super.initState();
    index = widget.index;
    _sliderValue = index.toDouble();
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
      contentPadding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 20,
        bottom: 10,
      ),
      content: Stack(
        children: [
          Container(
            width: AppLingua.width,
            height: AppLingua.height / 1.7,
            decoration: BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(
                  width: 2,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                  child: Container(
                    height: 300,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Text(
                        FileProcess.originalSentences[index],
                        style: const TextStyle(
                          fontSize: 25,
                          height: 1.7,
                        ),
                      ),
                    ),
                  ),
                ),
                Slider(
                  min: 0,
                  max: FileProcess.originalSentences.length.toDouble(),
                  value: _sliderValue,
                  onChanged: (value) {
                    setState(() {
                      _sliderValue = value;
                      index = _sliderValue.toInt();
                      _scrollController.jumpTo(0);
                    });
                  },
                ),
                SizedBox(
                  width: AppLingua.width / 1.2,
                  child: Column(
                    children: [
                      SizedBox(
                        width: AppLingua.width / 1.2,
                        child: TextField(
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            setState(() {
                              _sliderValue = int.parse(value).toDouble();
                              index = _sliderValue.toInt();
                              _scrollController.jumpTo(0);
                            });
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '${_sliderValue.toInt()}',
                            hintStyle: const TextStyle(
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context, _sliderValue.toInt());
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFF8FC1E4),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          width: 200,
                          height: 60,
                          child: const Center(
                              child: Text(
                            '이동',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop('back');
              },
              icon: Icon(
                Icons.arrow_back_ios_new,
                size: 30,
                color: Colors.black.withAlpha(100),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

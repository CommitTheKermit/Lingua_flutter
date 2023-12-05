import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lingua/main.dart';
import 'package:lingua/util/etc/file_process.dart';
import 'package:lingua/util/string_process/pager.dart';

class ReadModeScreen extends StatefulWidget {
  const ReadModeScreen({super.key});

  @override
  State<ReadModeScreen> createState() => _ReadModeScreenState();
}

class _ReadModeScreenState extends State<ReadModeScreen>
    with TickerProviderStateMixin {
  bool _showMenu = false;
  late AnimationController _controller;
  late Animation<Offset> _topMenuOffset;
  late Animation<Offset> _bottomMenuOffset;
  late TextStyle readTextStyle;
  List<String> pages = [];
  int index = 5;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _topMenuOffset = Tween<Offset>(
      begin: const Offset(0, -1),
      end: const Offset(0, -0.9),
    ).animate(_controller);

    _bottomMenuOffset = Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0, 0.9),
    ).animate(_controller);

    readTextStyle = TextStyle(
      color: const Color(0xFF171A1D),
      fontSize: AppLingua.height * 0.03,
    );

    pages = paginateText(
        text: FileProcess.stringContents,
        style: readTextStyle,
        screenSize: AppLingua.size);

    log(pages[5]);

    log(pages[pages.length - 2]);
    log(pages[pages.length - 1]);
    log(pages.last);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          setState(() {
            _showMenu = !_showMenu;
            if (_showMenu) {
              _controller.forward();
            } else {
              _controller.reverse();
            }
          });
        },
        onHorizontalDragStart: (details) {
          index += 1;
        },
        child: Stack(
          children: [
            Column(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: AppLingua.width * 0.04,
                        vertical: AppLingua.height * 0.05),
                    child: Text(
                      pages[index].toString(),
                      style: readTextStyle,
                    ),
                  ),
                ),
              ],
            ),
            SlideTransition(
                position: _topMenuOffset,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                  ),
                )),
            SlideTransition(
              position: _bottomMenuOffset,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:lingua/widgets/commons/common_widget.dart';

class Mainframe extends StatefulWidget {
  const Mainframe({super.key, required this.child,});
  final Widget child;

  @override
  State<Mainframe> createState() => _MainframeState();
}

class _MainframeState extends State<Mainframe> with WidgetsBindingObserver{

  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        comnLog(
            'MAINFRAME RESUMED MAINFRAME RESUMED MAINFRAME RESUMED MAINFRAME RESUMED MAINFRAME RESUMED');

        break;
      case AppLifecycleState.inactive:
        comnLog(
            'MAINFRAME INACTIVE MAINFRAME INACTIVE MAINFRAME INACTIVE MAINFRAME INACTIVE MAINFRAME INACTIVE');
        break;
      case AppLifecycleState.paused:
        comnLog(
            'MAINFRAME PAUSED MAINFRAME PAUSED MAINFRAME PAUSED MAINFRAME PAUSED MAINFRAME PAUSED');
        break;
      case AppLifecycleState.detached:
        comnLog(
            'MAINFRAME DETACHED MAINFRAME DETACHED MAINFRAME DETACHED MAINFRAME DETACHED MAINFRAME DETACHED ');
        break;
      case AppLifecycleState.hidden:
      comnLog('MAINFRAME HIDDEN MAINFRAME HIDDEN MAINFRAME HIDDEN MAINFRAME HIDDEN MAINFRAME HIDDEN MAINFRAME HIDDEN',);
      break;
    }
  }

    @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    comnLog('MAINFRAME INITALIZED');
  }

  @override
  void dispose() {
    ///메인프레임은 dispose되면 안됨. 항상 살아있어야 함
    WidgetsBinding.instance.removeObserver(this);
    comnLog('!!!MAINFRAME DISPOSING!!!');
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
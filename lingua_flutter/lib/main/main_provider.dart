import 'package:flutter/material.dart';
import 'package:lingua/mainframe/view_model/mainframe_prov.dart';
import 'package:lingua/screens_mobile/read_screen/view_model/read_screen_prov.dart';
import 'package:provider/provider.dart';

class MainProvider extends StatelessWidget {
  const MainProvider({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
          ChangeNotifierProvider<MainframeProv>(
          create: (context) => MainframeProv(),
        ),
        ChangeNotifierProvider<ReadScreenProv>(
          create: (context) => ReadScreenProv(),
        ),
      ],
      child: child,
    );
  }
}

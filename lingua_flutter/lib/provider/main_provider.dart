import 'package:flutter/material.dart';
import 'package:lingua/mainframe/view_model/mainframe_prov.dart';
import 'package:lingua/screens_mobile/home/view_model/home_prov.dart';
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
            create: (context) => MainframeProv()),
        ChangeNotifierProvider<HomeProv>(create: (context) => HomeProv()),
      ],
      child: child,
    );
  }
}

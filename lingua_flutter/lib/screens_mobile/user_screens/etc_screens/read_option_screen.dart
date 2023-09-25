import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class ReadOptionScreen extends StatefulWidget {
  const ReadOptionScreen({super.key});

  @override
  State<ReadOptionScreen> createState() => _ReadOptionScreenState();
}

class _ReadOptionScreenState extends State<ReadOptionScreen>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: GFSegmentTabs(
          height: 40,
          width: 250,
          tabController: tabController,
          tabBarColor: GFColors.WHITE,
          labelColor: GFColors.WHITE,
          unselectedLabelColor: GFColors.DARK,
          indicator: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          border: Border.all(color: GFColors.DARK, width: 0.3),
          length: 3,
          tabs: const <Widget>[
            SizedBox(
              height: 40,
              child: Center(
                child: Text(
                  "상단",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            SizedBox(
              height: 40,
              child: Center(
                child: Text(
                  "중단",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            SizedBox(
              height: 40,
              child: Center(
                child: Text(
                  "하단",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
      body: GFTabBarView(controller: tabController, children: <Widget>[
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Container(
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                  ),
                ),
                Divider(
                  height: 10,
                  color: Colors.grey.shade400,
                  thickness: 0.5,
                )
              ],
            ),
          ),
        ),
        const Center(
          child: Text('Tab 2'),
        ),
        const Center(
          child: Text('Tab 3'),
        ),
      ]),
    );
  }
}

// import 'package:flutter/material.dart';

// Future<dynamic> readOption(BuildContext context) {
//   return showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         contentPadding: EdgeInsets.zero,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15),
//         ),
//         content: Column(
//           children: [
//             Container(
//               width: AppLingua.width,
//               height: 100,
//               decoration: const BoxDecoration(color: Colors.green),
//             ),
//             SizedBox(
//               height: 400,
//               width: AppLingua.width,
//               child: const DefaultTabController(
//                 length: 3,
//                 child: Column(
//                   children: [
//                     TabBar(
//                       indicatorSize: TabBarIndicatorSize.label,
//                       tabs: [
//                         Tab(text: 'Tab 1'),
//                         Tab(text: 'Tab 2'),
//                         Tab(text: 'Tab 3'),
//                       ],
//                     ),
//                     Expanded(
//                       child: TabBarView(
//                         children: [
//                           Center(child: Text('Content 1')),
//                           Center(child: Text('Content 2')),
//                           Center(child: Text('Content 3')),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }

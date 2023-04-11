import 'package:flutter/material.dart';
import 'watch_map.dart';
import'main_page.dart';

// stateless widget
class MapDecision extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        debugPrint('Host device screen width: ${constraints.maxWidth}');

        // Watch-sized device
        if (constraints.maxWidth < 300) {
          return WatchMap();
        }
        // Phone-sized device
        else {
          return MainPage();
        }
      },
    );
  }
}

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

enum FGBGType { foreground, background, pause, resume }

class FGBGEvents {
  static const _channel = EventChannel("com.ajinasokan.flutter_fgbg/events");

  static Stream<FGBGType> get stream =>
      _channel.receiveBroadcastStream().map((event) {
        if (event == "foreground") return FGBGType.foreground;
        else if (event == "pause") return FGBGType.pause;
        else if (event == "resume") return FGBGType.resume;

        return FGBGType.background;
      });
}

class FGBGNotifier extends StatefulWidget {
  final Widget child;
  final ValueChanged<FGBGType> onEvent;

  FGBGNotifier({
    required this.child,
    required this.onEvent,
  });

  @override
  _FGBGNotifierState createState() => _FGBGNotifierState();
}

class _FGBGNotifierState extends State<FGBGNotifier> {
  StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();
    subscription = FGBGEvents.stream.listen((event) {
      widget.onEvent.call(event);
    });
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

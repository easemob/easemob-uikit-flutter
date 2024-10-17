library chat_uikit_record_bar;

import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';
export 'src/record_bar.dart';
export 'src/record_types.dart';
export 'src/error_code.dart';
export 'src/record_error.dart';
export 'src/record_data.dart';

Future<RecordResultData?> showChatUIKitRecordBar<T>({
  required BuildContext context,
  RecordBarController? controller,
  RecordBarOnRecord? onRecordTypeChanged,
  Color? backgroundColor,
  Color? barrierColor,
  int maxDuration = 60,
  int minDuration = 1,
}) {
  return showModalBottomSheet(
    useSafeArea: false,
    transitionAnimationController: AnimationController(
      duration: const Duration(milliseconds: 200),
      reverseDuration: const Duration(milliseconds: 150),
      debugLabel: 'BottomSheet',
      vsync: Navigator.of(context),
    ),
    enableDrag: false,
    isDismissible: true,
    isScrollControlled: true,
    backgroundColor: backgroundColor,
    barrierColor: barrierColor,
    context: context,
    builder: (BuildContext context) {
      return RecordBar(
        controller: controller,
        maxDuration: maxDuration,
        minDuration: minDuration,
        onRecordTypeChanged: onRecordTypeChanged,
        onRecordFinished: (data) {
          Navigator.of(context).pop(data);
        },
      );
    },
  );
}

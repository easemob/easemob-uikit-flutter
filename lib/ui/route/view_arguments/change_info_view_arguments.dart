import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/widgets.dart';

class ChangeInfoViewArguments implements ChatUIKitViewArguments {
  ChangeInfoViewArguments({
    this.title,
    this.hint,
    this.inputTextCallback,
    this.saveButtonTitle,
    this.appBar,
    this.maxLength = 128,
    this.enableAppBar = true,
    this.viewObserver,
    this.attributes,
    this.appBarTrailingActionsBuilder,
  });

  final String? title;
  final String? hint;
  final String? saveButtonTitle;
  final Future<String?> Function()? inputTextCallback;
  final PreferredSizeWidget? appBar;
  final int maxLength;
  final bool enableAppBar;

  @override
  String? attributes;
  @override
  ChatUIKitViewObserver? viewObserver;
  final ChatUIKitAppBarTrailingActionsBuilder? appBarTrailingActionsBuilder;

  ChangeInfoViewArguments copyWith(
      {String? title,
      String? hint,
      String? saveButtonTitle,
      Future<String?> Function()? inputTextCallback,
      ChatUIKitAppBar? appBar,
      int? maxLength,
      bool? enableAppBar,
      ChatUIKitViewObserver? viewObserver,
      String? attributes,
      ChatUIKitAppBarTrailingActionsBuilder? appBarTrailingActionsBuilder}) {
    return ChangeInfoViewArguments(
      title: title ?? this.title,
      hint: hint ?? this.hint,
      saveButtonTitle: saveButtonTitle ?? this.saveButtonTitle,
      inputTextCallback: inputTextCallback ?? this.inputTextCallback,
      appBar: appBar ?? this.appBar,
      maxLength: maxLength ?? this.maxLength,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      viewObserver: viewObserver ?? this.viewObserver,
      attributes: attributes ?? this.attributes,
      appBarTrailingActionsBuilder:
          appBarTrailingActionsBuilder ?? this.appBarTrailingActionsBuilder,
    );
  }
}

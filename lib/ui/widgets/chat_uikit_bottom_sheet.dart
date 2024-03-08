import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

Future<T?> showChatUIKitBottomSheet<T>({
  required BuildContext context,
  required List<ChatUIKitBottomSheetItem<T>> items,
  Color? backgroundColor,
  Color? barrierColor,
  bool enableRadius = true,
  String? title,
  TextStyle? titleStyle,
  Widget? titleWidget,
  String? cancelLabel,
  bool showCancel = true,
  TextStyle? cancelLabelStyle,
}) {
  return showModalBottomSheet(
    clipBehavior: !enableRadius ? null : Clip.hardEdge,
    shape: !enableRadius
        ? null
        : const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
          ),
    backgroundColor: backgroundColor,
    barrierColor: barrierColor,
    context: context,
    builder: (BuildContext context) {
      return ChatUIKitBottomSheet(
        title: title,
        titleStyle: titleStyle,
        titleWidget: titleWidget,
        items: items,
        cancelLabel: cancelLabel,
        cancelLabelStyle: cancelLabelStyle,
        showCancel: showCancel,
      );
    },
  );
}

enum ChatUIKitBottomSheetItemType {
  normal,
  destructive,
}

class ChatUIKitBottomSheetItem<T> {
  ChatUIKitBottomSheetItem.normal({
    required this.label,
    this.style,
    this.onTap,
    this.icon,
  }) : type = ChatUIKitBottomSheetItemType.normal;

  ChatUIKitBottomSheetItem.destructive({
    required this.label,
    this.style,
    this.onTap,
    this.icon,
  }) : type = ChatUIKitBottomSheetItemType.destructive;

  ChatUIKitBottomSheetItem({
    required this.type,
    required this.label,
    this.style,
    this.onTap,
    this.icon,
  });

  final ChatUIKitBottomSheetItemType type;
  final String label;
  final TextStyle? style;
  final Widget? icon;
  final Future<T?> Function()? onTap;

  ChatUIKitBottomSheetItem copyWith({
    ChatUIKitBottomSheetItemType? type,
    String? label,
    TextStyle? style,
    Widget? icon,
    Future<T?> Function()? onTap,
  }) {
    return ChatUIKitBottomSheetItem(
      type: type ?? this.type,
      label: label ?? this.label,
      style: style ?? this.style,
      icon: icon ?? this.icon,
      onTap: onTap ?? this.onTap,
    );
  }
}

class ChatUIKitBottomSheet<T> extends StatelessWidget {
  const ChatUIKitBottomSheet({
    required this.items,
    this.title,
    this.titleStyle,
    this.titleWidget,
    this.cancelLabel,
    this.cancelLabelStyle,
    this.showCancel = true,
    super.key,
  });
  final List<ChatUIKitBottomSheetItem> items;
  final String? title;
  final Widget? titleWidget;
  final TextStyle? titleStyle;
  final String? cancelLabel;
  final TextStyle? cancelLabelStyle;
  final bool showCancel;
  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      enableDrag: false,
      onClosing: () {},
      builder: (context) {
        return _build(context);
      },
    );
  }

  Widget _build(BuildContext context) {
    List<Widget> list = [];
    ChatUIKitTheme theme = ChatUIKitTheme.of(context);

    TextStyle? normalStyle = TextStyle(
      fontWeight: theme.font.bodyLarge.fontWeight,
      fontSize: theme.font.bodyLarge.fontSize,
      color: (theme.color.isDark
          ? theme.color.primaryColor6
          : theme.color.primaryColor5),
    );

    TextStyle? destructive = TextStyle(
      fontWeight: theme.font.bodyLarge.fontWeight,
      fontSize: theme.font.bodyLarge.fontSize,
      color: (theme.color.isDark
          ? theme.color.errorColor6
          : theme.color.errorColor5),
    );

    list.add(
      Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(3)),
          color: (theme.color.isDark
              ? theme.color.neutralColor3
              : theme.color.neutralColor8),
        ),
        margin: const EdgeInsets.symmetric(vertical: 6),
        height: 5,
        width: 36,
      ),
    );

    if (title != null && titleWidget == null) {
      list.add(
        Container(
          padding: const EdgeInsets.symmetric(vertical: 13),
          child: Text(
            title!,
            textScaler: TextScaler.noScaling,
            style: titleStyle ??
                TextStyle(
                  fontWeight: theme.font.labelMedium.fontWeight,
                  fontSize: theme.font.labelMedium.fontSize,
                  color: (theme.color.isDark
                      ? theme.color.neutralColor6
                      : theme.color.neutralColor5),
                ),
          ),
        ),
      );
    }

    if (titleWidget != null) {
      list.add(
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          child: titleWidget,
        ),
      );
    }

    for (var element in items) {
      if (element != items[0] || title?.isNotEmpty == true) {
        list.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              height: .5,
              thickness: .5,
              color: (theme.color.isDark
                  ? theme.color.neutralColor2
                  : theme.color.neutralColor9),
            ),
          ),
        );
      }
      list.add(
        InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: element.onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            alignment: Alignment.center,
            child: element.icon != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        margin: const EdgeInsets.fromLTRB(16, 4, 4, 4),
                        child: element.icon,
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          element.label,
                          textScaler: TextScaler.noScaling,
                          overflow: TextOverflow.ellipsis,
                          style: element.style ??
                              (element.type ==
                                      ChatUIKitBottomSheetItemType.normal
                                  ? normalStyle
                                  : destructive),
                        ),
                      )
                    ],
                  )
                : Text(
                    element.label,
                    textScaler: TextScaler.noScaling,
                    overflow: TextOverflow.ellipsis,
                    style: element.style ??
                        (element.type == ChatUIKitBottomSheetItemType.normal
                            ? normalStyle
                            : destructive),
                  ),
          ),
        ),
      );
    }

    list.add(Container(
      height: 8,
      color: (theme.color.isDark
          ? theme.color.neutralColor0
          : theme.color.neutralColor95),
    ));

    if (showCancel) {
      String? str = cancelLabel;
      str ??= ChatUIKitLocal.bottomSheetCancel.getString(context);
      list.add(
        InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 17),
            alignment: Alignment.center,
            child: Text(
              str,
              textScaler: TextScaler.noScaling,
              overflow: TextOverflow.ellipsis,
              style: cancelLabelStyle ??
                  TextStyle(
                    fontWeight: theme.font.titleMedium.fontWeight,
                    fontSize: theme.font.titleMedium.fontSize,
                    color: (theme.color.isDark
                        ? theme.color.primaryColor6
                        : theme.color.primaryColor5),
                  ),
            ),
          ),
        ),
      );
    }

    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: list,
    );

    content = ListView(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      children: [content],
    );

    content = Container(
      decoration: BoxDecoration(
        color: (theme.color.isDark
            ? theme.color.neutralColor1
            : theme.color.neutralColor98),
      ),
      child: content,
    );

    return content;
  }
}

import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatUIKitAppBar extends StatefulWidget implements PreferredSizeWidget {
  const ChatUIKitAppBar({
    this.title,
    this.titleWidget,
    this.titleTextStyle,
    this.subtitle,
    this.subTitleTextStyle,
    this.leading,
    this.trailingActions,
    this.showBackButton = true,
    this.onBackButtonPressed,
    this.centerTitle = true,
    this.systemOverlayStyle,
    this.backgroundColor,
    super.key,
  });

  final bool showBackButton;
  final VoidCallback? onBackButtonPressed;
  final String? title;
  final TextStyle? titleTextStyle;
  final Widget? titleWidget;
  final String? subtitle;
  final TextStyle? subTitleTextStyle;
  final Widget? leading;
  final List<ChatUIKitAppBarTrailingAction>? trailingActions;
  final bool centerTitle;
  final Color? backgroundColor;
  final SystemUiOverlayStyle? systemOverlayStyle;

  @override
  State<ChatUIKitAppBar> createState() => _ChatUIKitAppBarState();

  @override
  Size get preferredSize {
    return const Size.fromHeight(56);
  }
}

class _ChatUIKitAppBarState extends State<ChatUIKitAppBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);

    Color backgroundColor = widget.backgroundColor ??
        (theme.color.isDark
            ? theme.color.neutralColor1
            : theme.color.neutralColor98);

    Widget? title;
    if (widget.title?.isNotEmpty == true) {
      title = Text(
        widget.title!,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        textScaler: TextScaler.noScaling,
        style: widget.titleTextStyle ??
            TextStyle(
              fontSize: theme.font.titleMedium.fontSize,
              fontWeight: theme.font.titleMedium.fontWeight,
              color: theme.color.isDark
                  ? theme.color.neutralColor98
                  : theme.color.neutralColor1,
            ),
      );
    }

    if (widget.titleWidget != null) {
      title = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          title ?? const SizedBox(),
          widget.titleWidget!,
        ],
      );
    }

    Widget? subTitle;
    if (widget.subtitle?.isNotEmpty == true) {
      subTitle = Text(
        widget.subtitle!,
        textScaler: TextScaler.noScaling,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: widget.subTitleTextStyle ??
            TextStyle(
              fontSize: theme.font.bodyExtraSmall.fontSize,
              fontWeight: theme.font.bodyExtraSmall.fontWeight,
              color: theme.color.isDark
                  ? theme.color.neutralColor6
                  : theme.color.neutralColor5,
            ),
      );
    }

    Widget middle = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: widget.centerTitle
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        title ?? const SizedBox(),
        subTitle ?? const SizedBox(),
      ],
    );

    middle = Padding(
      padding: const EdgeInsets.only(right: 12),
      child: middle,
    );

    // 当centerTitle为false时，leading为null时，点击title返回
    // if (widget.centerTitle == false && widget.leading == null) {
    //   middle = InkWell(
    //     onTap: () {
    //       if (widget.onBackButtonPressed != null) {
    //         widget.onBackButtonPressed?.call();
    //       } else {
    //         Navigator.maybePop(context);
    //       }
    //     },
    //     child: middle,
    //   );
    // }

    Widget? leading;
    List<Widget> leadingWidgets = [];
    if (widget.showBackButton) {
      leadingWidgets.add(
        InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            if (widget.onBackButtonPressed != null) {
              widget.onBackButtonPressed?.call();
            } else {
              Navigator.maybePop(context);
            }
          },
          child: Padding(
            padding: EdgeInsets.only(
              left: 12,
              top: 12,
              bottom: 12,
              right: (widget.leading == null && widget.centerTitle) ? 20 : 2,
            ),
            child: SizedBox(
              width: 24,
              height: 24,
              child: Icon(
                Icons.arrow_back_ios,
                size: 16,
                color: theme.color.isDark
                    ? theme.color.neutralColor95
                    : theme.color.neutralColor3,
              ),
            ),
          ),
        ),
      );
      // leadingWidgets.add(
      //   const SizedBox(width: 10),
      // );
    }
    if (widget.leading != null) {
      leadingWidgets.add(widget.leading!);
      leadingWidgets.add(const SizedBox(width: 12));
    }

    if (leadingWidgets.isNotEmpty) {
      leading = Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: leadingWidgets,
      );
    }

    List<ChatUIKitAppBarTrailingAction>? actions = widget.trailingActions;
    Widget? trailing;
    if (actions?.isNotEmpty == true) {
      trailing = Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: actions!.map((e) {
          return InkWell(
            onTap: () {
              e.onTap?.call(context);
            },
            child: Container(
              padding: const EdgeInsets.only(left: 8, right: 8),
              // color: Colors.red,
              child: e.child,
            ),
          );
        }).toList(),
      );
      trailing = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: trailing,
      );
    }

    Widget content = NavigationToolbar(
      leading: leading,
      middle: middle,
      trailing: trailing,
      centerMiddle: widget.centerTitle,
      middleSpacing: 0,
    );

    content = SafeArea(
      bottom: false,
      child: content,
    );

    content = Container(
      height: MediaQuery.paddingOf(context).top + widget.preferredSize.height,
      color: backgroundColor,
      child: content,
    );

    return updateStatusBar(content, backgroundColor);
  }

  Widget updateStatusBar(Widget content, Color backgroundColor) {
    final ThemeData theme = Theme.of(context);
    final SystemUiOverlayStyle overlayStyle = _systemOverlayStyleForBrightness(
      ThemeData.estimateBrightnessForColor(backgroundColor),
      theme.useMaterial3 ? const Color(0x00000000) : null,
    );

    return Semantics(
      container: true,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: overlayStyle,
        child: Material(
          color: backgroundColor,
          child: Semantics(
            explicitChildNodes: true,
            child: content,
          ),
        ),
      ),
    );
  }

  SystemUiOverlayStyle _systemOverlayStyleForBrightness(Brightness brightness,
      [Color? backgroundColor]) {
    final SystemUiOverlayStyle style = brightness == Brightness.dark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;

    return SystemUiOverlayStyle(
      statusBarColor: backgroundColor,
      statusBarBrightness: style.statusBarBrightness,
      statusBarIconBrightness: style.statusBarIconBrightness,
      systemStatusBarContrastEnforced: style.systemStatusBarContrastEnforced,
    );
  }
}

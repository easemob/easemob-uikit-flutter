import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

class ReportMessageView extends StatefulWidget {
  ReportMessageView.arguments(
    ReportMessageViewArguments arguments, {
    super.key,
  })  : messageId = arguments.messageId,
        appBar = arguments.appBar,
        enableAppBar = arguments.enableAppBar,
        reportReasons = arguments.reportReasons,
        title = arguments.title,
        appBarTrailingActionsBuilder = arguments.appBarTrailingActionsBuilder,
        viewObserver = arguments.viewObserver,
        attributes = arguments.attributes;

  const ReportMessageView({
    required this.messageId,
    required this.reportReasons,
    this.appBar,
    this.enableAppBar = true,
    this.attributes,
    this.title,
    this.viewObserver,
    this.appBarTrailingActionsBuilder,
    super.key,
  });
  final ChatUIKitAppBar? appBar;
  final String messageId;
  final List<String> reportReasons;
  final bool enableAppBar;
  final String? title;
  final String? attributes;

  /// 用于刷新页面的Observer
  final ChatUIKitViewObserver? viewObserver;
  final ChatUIKitAppBarTrailingActionsBuilder? appBarTrailingActionsBuilder;

  @override
  State<ReportMessageView> createState() => _ReportMessageViewState();
}

class _ReportMessageViewState extends State<ReportMessageView> {
  int selectedIndex = -1;

  final scrollController = ScrollController();

  @override
  initState() {
    super.initState();
    widget.viewObserver?.addListener(() {
      setState(() {});
    });
  }

  @override
  dispose() {
    widget.viewObserver?.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    Widget content = CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Text(
                ChatUIKitLocal.reportMessageViewReportReasons
                    .localString(context),
                overflow: TextOverflow.ellipsis,
                textScaler: TextScaler.noScaling,
                maxLines: 1,
                style: TextStyle(
                    fontWeight: theme.font.titleSmall.fontWeight,
                    fontSize: theme.font.titleSmall.fontSize,
                    color: (theme.color.isDark
                        ? theme.color.neutralColor6
                        : theme.color.neutralColor5)),
              );
            },
            childCount: 1,
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child:
                    tile(widget.reportReasons[index], selectedIndex == index),
              );
            },
            childCount: widget.reportReasons.length,
          ),
        ),
      ],
    );

    content = Column(
      children: [
        Expanded(child: content),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: ChatUIKitButton.neutral(
                  ChatUIKitLocal.reportMessageViewCancel.localString(context),
                  radius: 4,
                  fontWeight: theme.font.headlineSmall.fontWeight,
                  fontSize: theme.font.headlineSmall.fontSize,
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ChatUIKitButton.primary(
                  ChatUIKitLocal.reportMessageViewConfirm.localString(context),
                  radius: 4,
                  fontWeight: theme.font.headlineSmall.fontWeight,
                  fontSize: theme.font.headlineSmall.fontSize,
                  onTap: () {
                    if (selectedIndex == -1) {
                      Navigator.of(context).pop();
                    } else {
                      Navigator.of(context)
                          .pop(widget.reportReasons[selectedIndex]);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );

    content = Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: content,
    );

    content = Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      appBar: !widget.enableAppBar
          ? null
          : widget.appBar ??
              ChatUIKitAppBar(
                centerTitle: false,
                title: widget.title ??
                    ChatUIKitLocal.reportMessageViewTitle.localString(context),
                trailingActions:
                    widget.appBarTrailingActionsBuilder?.call(context, null),
              ),
      body: SafeArea(child: content),
    );

    return content;
  }

  Widget tile(String title, bool selected) {
    final theme = ChatUIKitTheme.of(context);
    return SizedBox(
      height: 54,
      child: Row(
        children: [
          Text(
            title,
            textScaler: TextScaler.noScaling,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontWeight: theme.font.titleMedium.fontWeight,
                fontSize: theme.font.titleMedium.fontSize,
                color: (theme.color.isDark
                    ? theme.color.neutralColor98
                    : theme.color.neutralColor1)),
          ),
          Expanded(child: Container()),
          selected
              ? Icon(Icons.radio_button_checked,
                  size: 21.33,
                  color: (theme.color.isDark
                      ? theme.color.neutralColor6
                      : theme.color.primaryColor5))
              : Icon(Icons.radio_button_unchecked,
                  size: 21.33,
                  color: (theme.color.isDark
                      ? theme.color.neutralColor8
                      : theme.color.neutralColor7))
        ],
      ),
    );
  }
}

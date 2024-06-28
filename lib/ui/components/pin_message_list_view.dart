import 'dart:math';

import 'package:em_chat_uikit/ui/controllers/pin_message_list_view_controller.dart';
import 'package:flutter/material.dart';

class PinMessageListView extends StatefulWidget {
  const PinMessageListView({
    required this.pinMessagesController,
    this.itemHeight = 44,
    this.maxHeight = 300,
    this.duration = const Duration(milliseconds: 100),
    this.barrierColor,
    super.key,
  });

  final double itemHeight;
  final double maxHeight;
  final Duration duration;
  final Color? barrierColor;
  final PinMessageListViewController pinMessagesController;

  @override
  State<PinMessageListView> createState() => _PinMessageListViewState();
}

class _PinMessageListViewState extends State<PinMessageListView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Animation<double>? animation;
  late CurvedAnimation cure;
  late Color barrierColor;

  bool isShow = false;
  List<PinListItem> items = [];

  @override
  void initState() {
    super.initState();
    barrierColor = widget.barrierColor ?? Colors.black.withOpacity(0.3);
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    cure = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.addStatusListener((status) {
      debugPrint('status: $status');
    });

    _controller.addListener(() {
      debugPrint('value: ${animation!.value}');
      setState(() {});
    });

    widget.pinMessagesController.list.addListener(() {
      if (items != widget.pinMessagesController.list.value) {
        items = widget.pinMessagesController.list.value;
        animation =
            Tween<double>(begin: 0, end: items.length * widget.itemHeight)
                .animate(cure);
        if (widget.pinMessagesController.isShow) {
          _controller.animateTo(items.length * widget.itemHeight,
              duration: widget.duration);
          setState(() {});
        }
      }
      if (items.isEmpty) {
        widget.pinMessagesController.hide();
      }
    });

    animation = Tween<double>(begin: 0, end: items.length * widget.itemHeight)
        .animate(cure);

    widget.pinMessagesController.addListener(() {
      if (widget.pinMessagesController.isShow) {
        isShow = true;
        _controller.forward();
      } else {
        isShow = false;
        _controller.reverse();
      }
    });
  }

  @override
  void didUpdateWidget(covariant PinMessageListView oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return animation?.status == AnimationStatus.dismissed
        ? const SizedBox()
        : Stack(
            children: [
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                child: AnimatedContainer(
                  duration: widget.duration,
                  color: isShow ? barrierColor : Colors.transparent,
                ),
                onTap: () {
                  widget.pinMessagesController.hide();
                },
              ),
              Container(
                constraints: BoxConstraints(
                  maxHeight: widget.maxHeight,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      children: [
                        AnimatedContainer(
                          color: Colors.blue,
                          height: max(
                              min(constraints.maxHeight, animation!.value) - 3,
                              0),
                          duration: widget.duration,
                          child: Scrollbar(
                              child: ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                height: widget.itemHeight,
                                child: Center(
                                  child: Text(items[index].message.msgId),
                                ),
                              );
                            },
                          )),
                        ),
                        isShow
                            ? SizedBox(
                                height: 3,
                                child: Container(color: Colors.yellow))
                            : const SizedBox(),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
  }

  @override
  void dispose() {
    super.dispose();
    widget.pinMessagesController.dispose();
    _controller.dispose();
  }
}

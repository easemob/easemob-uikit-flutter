import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit_example/pages/help/download_page.dart';
import 'package:flutter/material.dart';

class ChatRouteFilter {
  static RouteSettings chatRouteSettings(RouteSettings settings) {
    // 拦截 ChatUIKitRouteNames.messagesView, 之后对要跳转的页面的 `RouteSettings` 进行自定义，之后返回。
    if (settings.name == ChatUIKitRouteNames.messagesView) {
      return messagesView(settings);
    } else if (settings.name == ChatUIKitRouteNames.createGroupView) {
      return createGroupView(settings);
    }
    return settings;
  }

  // 为 MessagesView 添加文件点击下载
  static RouteSettings messagesView(RouteSettings settings) {
    MessagesViewArguments arguments =
        settings.arguments as MessagesViewArguments;
    arguments = arguments.copyWith(
      onItemTap: (ctx, message) {
        if (message.bodyType == MessageType.FILE) {
          Navigator.of(ctx).push(
            MaterialPageRoute(
              builder: (context) => DownloadFileWidget(
                message: message,
                key: ValueKey(message.localTime),
              ),
            ),
          );
          return true;
        }
        return false;
      },
    );

    return RouteSettings(name: settings.name, arguments: arguments);
  }

  // 为 MessagesView 添加文件点击下载
  static RouteSettings createGroupView(RouteSettings settings) {
    CreateGroupViewArguments arguments =
        settings.arguments as CreateGroupViewArguments;
    arguments = arguments.copyWith(
      willCreateHandler: (context, createGroupInfo, selectedProfiles) async {
        String? groupName = await showChatUIKitDialog(
          context: context,
          title: '请输入群名称',
          hintsText: ['输入群名称'],
          items: [
            ChatUIKitDialogItem.cancel(
              label: '取消',
            ),
            ChatUIKitDialogItem.inputsConfirm(
              label: '确定',
              onInputsTap: (inputs) async {
                Navigator.of(context).pop(inputs.first);
              },
            )
          ],
        );
        if (groupName == null) {
          return null;
        } else {
          return CreateGroupInfo(
            groupName: groupName,
          );
        }
      },
    );

    return RouteSettings(name: settings.name, arguments: arguments);
  }
}

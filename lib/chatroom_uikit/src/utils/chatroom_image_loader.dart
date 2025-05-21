import 'package:flutter/material.dart';

const String packageName = 'em_chat_uikit';

class ChatRoomImageLoader {
  static Widget emoji(String imageName, {double size = 36}) {
    String name = imageName.substring(0, imageName.length);
    return Image.asset(
      'assets/images/chatroom/emojis/$name.png',
      package: packageName,
      width: size,
      height: size,
    );
  }

  static Widget airplane({double size = 30, Color? color}) {
    return Image.asset(
      'assets/images/chatroom/airplane.png',
      package: packageName,
      width: size,
      height: size,
    );
  }

  static Widget pinMessage({double size = 18, Color? color}) {
    return Image.asset(
      'assets/images/chatroom/pin.png',
      package: packageName,
      width: size,
      height: size,
    );
  }

  static Widget textKeyboard({double size = 30, Color? color}) {
    return Image.asset(
      'assets/images/chatroom/textKeyboard.png',
      package: packageName,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget face({double size = 30, Color? color}) {
    return Image.asset(
      'assets/images/chatroom/face.png',
      package: packageName,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget avatar({double size = 30, Color? color}) {
    return Image.asset(
      'assets/images/chatroom/avatar.png',
      package: packageName,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget chatRaise({double size = 30, Color? color}) {
    return Image.asset(
      'assets/images/chatroom/chatRaise.png',
      package: packageName,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget more({double size = 30, Color? color}) {
    return Image.asset(
      'assets/images/chatroom/more.png',
      package: packageName,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget search({double size = 30, Color? color}) {
    return Image.asset(
      'assets/images/chatroom/search.png',
      package: packageName,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget selected({double size = 30, Color? color}) {
    return Image.asset(
      'assets/images/chatroom/selected.png',
      package: packageName,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget success({double size = 30, Color? color}) {
    return Image.asset(
      'assets/images/chatroom/success.png',
      package: packageName,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget unselected({double size = 30, Color? color}) {
    return Image.asset(
      'assets/images/chatroom/unselected.png',
      package: packageName,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget inputChat({double size = 30, Color? color}) {
    return Image.asset(
      'assets/images/chatroom/chat.png',
      package: packageName,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget delete({double size = 30, Color? color}) {
    return Image.asset(
      'assets/images/chatroom/delete.png',
      package: packageName,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget empty({double size = 140, Color? color}) {
    return Image.asset(
      'assets/images/chatroom/empty.png',
      package: packageName,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget defaultGift({double size = 30, Color? color}) {
    return Image.asset(
      'assets/images/chatroom/default_gift.png',
      package: packageName,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget defaultAvatar({double size = 30, Color? color}) {
    return Icon(Icons.perm_identity, size: size, color: color);
  }

  static Widget networkImage({
    String? image,
    Widget? placeholderWidget,
    double? size,
    BoxFit fit = BoxFit.fill,
  }) {
    if (image == null) {
      return placeholderWidget ?? Container();
    }

    return FadeInImage(
      width: size,
      height: size,
      placeholder: const NetworkImage(''),
      placeholderFit: fit,
      placeholderErrorBuilder: (context, error, stackTrace) {
        return placeholderWidget ?? Container();
      },
      image: NetworkImage(image),
      fit: fit,
      imageErrorBuilder: (context, error, stackTrace) {
        return placeholderWidget ?? Container();
      },
    );
  }
}

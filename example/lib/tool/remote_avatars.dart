import 'dart:math';

class RemoteAvatars {
  static const List<String> avatars = [
    'https://cdn0.iconfinder.com/data/icons/user-pictures/100/male-128.png',
    'https://cdn0.iconfinder.com/data/icons/user-pictures/100/matureman1-2-128.png',
    'https://cdn0.iconfinder.com/data/icons/user-pictures/100/matureman2-2-128.png',
    'https://cdn0.iconfinder.com/data/icons/user-pictures/100/malecostume-128.png',
    'https://cdn0.iconfinder.com/data/icons/user-pictures/100/girl-2-128.png',
    'https://cdn0.iconfinder.com/data/icons/user-pictures/100/female-128.png',
    'https://cdn0.iconfinder.com/data/icons/user-pictures/100/maturewoman-2-128.png',
    'https://cdn0.iconfinder.com/data/icons/user-pictures/100/supportmale-2-128.png',
  ];

  static String get getRandomAvatar {
    return avatars[Random().nextInt(avatars.length)];
  }
}

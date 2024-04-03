import 'dart:async';

import 'package:em_chat_uikit/chat_uikit.dart';
// import 'package:em_chat_uikit_example/tool/app_server_helper.dart';
import 'package:em_chat_uikit_example/tool/app_server_helper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int timer = 0;
  Timer? _timer;
  final String serviceAgreementURL = 'https://www.easemob.com/agreement';
  final String privacyPolicyURL = 'https://www.easemob.com/protocol';

  TextEditingController phoneController = TextEditingController();
  TextEditingController codeController = TextEditingController();

  @override
  void dispose() {
    _timer?.cancel();
    phoneController.dispose();
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);

    TextStyle linkStyle = TextStyle(
      color: Colors.blue,
      decoration: TextDecoration.underline,
      fontWeight: FontWeight.w500,
      decorationColor: theme.color.primaryColor5,
    );
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: theme.color.primaryColor95,
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      '登录环信IM',
                      style: TextStyle(
                        color: theme.color.primaryColor5,
                        fontWeight: FontWeight.w500,
                        fontSize: 24,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16),
                  child: TextField(
                    controller: phoneController,
                    keyboardAppearance: ChatUIKitTheme.of(context).color.isDark ? Brightness.dark : Brightness.light,
                    autofocus: true,
                    style: TextStyle(
                        fontWeight: theme.font.bodyLarge.fontWeight,
                        fontSize: theme.font.bodyLarge.fontSize,
                        color: theme.color.neutralColor1),
                    scrollPadding: EdgeInsets.zero,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: '请输入您的手机号',
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                      hintStyle: TextStyle(
                        color: theme.color.neutralColor6,
                      ),
                      border: const OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16),
                  child: TextField(
                    controller: codeController,
                    keyboardAppearance: ChatUIKitTheme.of(context).color.isDark ? Brightness.dark : Brightness.light,
                    autofocus: true,
                    style: TextStyle(
                        fontWeight: theme.font.bodyLarge.fontWeight,
                        fontSize: theme.font.bodyLarge.fontSize,
                        color: theme.color.neutralColor1),
                    // controller: searchController,
                    scrollPadding: EdgeInsets.zero,
                    decoration: InputDecoration(
                      hintText: '请输入验证码',
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                      hintStyle: TextStyle(
                        color: theme.color.neutralColor6,
                      ),
                      suffixIconConstraints: BoxConstraints.loose(const Size(100, 40)),
                      suffixIcon: InkWell(
                        onTap: () {
                          debugPrint('获取验证码');
                          if (phoneController.text.isEmpty) {
                            EasyLoading.showError('请输入手机号');
                            return;
                          }
                          fetchSmsCode();
                          timer = 60;
                          _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                            setState(() {
                              this.timer--;
                              if (this.timer == 0) {
                                timer.cancel();
                              }
                            });
                          });
                        },
                        enableFeedback: false,
                        child: Text(
                          timer == 0 ? '获取验证码' : '重新获取(${timer}s)',
                          style: TextStyle(
                            color: timer == 0 ? theme.color.primaryColor5 : theme.color.neutralColor7,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 46,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: () {
                      if (phoneController.text.isEmpty) {
                        EasyLoading.showError('请输入手机号');
                        return;
                      }

                      if (codeController.text.isEmpty) {
                        EasyLoading.showError('请输入验证码');
                        return;
                      }

                      login();
                    },
                    child: const Text(
                      '登录',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text.rich(
                  TextSpan(
                    children: [
                      WidgetSpan(
                        child: Icon(
                          Icons.check_box,
                          size: 20,
                          color: theme.color.primaryColor5,
                        ),
                      ),
                      const TextSpan(text: '请选择同意 '),
                      TextSpan(
                          text: '《环信服务条款》',
                          style: linkStyle,
                          recognizer: TapGestureRecognizer()..onTap = serviceAgreement),
                      const TextSpan(text: ' 与 '),
                      TextSpan(
                          text: '《环信隐私协议》',
                          style: linkStyle,
                          recognizer: TapGestureRecognizer()..onTap = privacyPolicy),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void fetchSmsCode() {
    AppServerHelper.sendSmsCodeRequest(phoneController.text).then((value) {
      EasyLoading.showSuccess('验证码已发送');
    }).catchError((e) {
      debugPrint(e.toString());
      _timer?.cancel();
      timer = 0;
      setState(() {});
      EasyLoading.showError(e.toString());
    });
  }

  void login() async {
    EasyLoading.show(status: '登录中...');
    Future(() async {
      try {
        LoginUserData data = await AppServerHelper.login(
          phoneController.text,
          codeController.text,
        );

        await ChatUIKit.instance.loginWithToken(
          userId: data.userId,
          token: data.token,
        );
      } catch (e) {
        debugPrint(e.toString());
        rethrow;
      }
    }).then((value) {
      EasyLoading.dismiss();
      Navigator.of(context).pushReplacementNamed('/home');
    }).catchError((e) {
      EasyLoading.showError(e.toString());
    });
  }

  void serviceAgreement() async {
    if (!await launchUrl(Uri.parse(serviceAgreementURL))) {
      throw Exception('Could not launch $serviceAgreementURL');
    }
  }

  void privacyPolicy() async {
    if (!await launchUrl(Uri.parse(privacyPolicyURL))) {
      throw Exception('Could not launch $privacyPolicyURL');
    }
  }
}

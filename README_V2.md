# ChatUIKit for flutter

# 单群聊 UIKit

本产品主要旨在给用户打造一个良好体验的单群聊UIKit。主要为用户解决直接集成SDK繁琐，复杂度高等问题。致力于打造集成简单，自由度高，流程简单，文档说明足够详细的单群聊UIKit产品。

# 单群聊 UIKit 指南

## 简介

本指南介绍了 ChatUIKit 框架在 flutter 开发中的概述和使用示例，并描述了该 UIKit 的各个组件和功能，使开发人员能够很好地了解 UIKit 并有效地使用它。

<!-- ## 目录 
- [ChatUIKit for flutter](#chatuikit-for-flutter)
- [单群聊 UIKit](#单群聊-uikit)
- [单群聊 UIKit 指南](#单群聊-uikit-指南)
  - [简介](#简介)
  - [目录](#目录)
- [前置开发环境要求](#前置开发环境要求)
- [安装](#安装)
- [结构](#结构)
- [快速开始](#快速开始)
- [进阶用法](#进阶用法)
- [自定义](#自定义)
- [设计指南](#设计指南) -->

# 前置开发环境要求

```yaml
environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: ">=3.3.0"
```

- ios 13+
- android 21+

# 安装

```bash
flutter pub add em_chat_uikit
```

# 结构

```bash
.
├── chat_uikit.dart                                             // library
├── chat_uikit_alphabet_sort_helper.dart                        // 联系人首字母排序纠正工具
├── chat_uikit_defines.dart                                     // UIKit handler 定义类
├── chat_uikit_emoji_data.dart                                  // 消息表情数据类
├── chat_uikit_localizations.dart                               // 国际化工具类
├── chat_uikit_service                                          // 对 chat sdk 包装类的二次包装，用于将包装类中不符合的功能再次修改以适配 UIKit 功能
├── chat_uikit_settings.dart                                    // 功能设置类，用于开关和配置某些功能
├── chat_uikit_time_formatter.dart                              // 时间显示格式设置工具
├── provider                                                    // 用户属性工具
│   ├── chat_uikit_profile.dart                                 // 用户属性对象，包括头像，昵称，备注等。
│   └── chat_uikit_provider.dart                                // 用户属性 Provider，需要通过实现 Provider，为 UIKit 中的 Profile 设置数据。
├── sdk_service                                                 // 对 chat sdk 的包装，用于包装 chat sdk 对外接口, UIKit 只与 包装类打交道，不直接调用 chat sdk
├── tools                                                       // 内部的工具类
│   ├── chat_uikit_context.dart                                 // 数据上下文，用于存储一些状态
│   ├── chat_uikit_conversation_extension.dart                  // 会话列表的加工类，用于预加工一些属性
│   ├── chat_uikit_file_size_tool.dart                          // 文件大小显示计算工具
│   ├── chat_uikit_helper.dart                                  // 内部计算圆角类
│   ├── chat_uikit_highlight_tool.dart                          // 计算组件高亮工具类
│   ├── chat_uikit_image_loader.dart                            // 图片加载工具类
│   ├── chat_uikit_message_extension.dart                       // 消息加工类，用于预加工一些属性
│   ├── chat_uikit_time_tool.dart                               // 默认时间格式类
│   ├── chat_uikit_url_helper.dart                              // url preview 工具类
│   └── safe_disposed.dart                                      // 内部对 ChangeNotifier 的加工类
├── ui                                                          // UI 组件
│   ├── components                                              // Components
│   │   ├── block_list_view.dart                                // block list view
│   │   ├── contact_list_view.dart                              // contact list view
│   │   ├── conversation_list_view.dart                         // conversation list view
│   │   ├── group_list_view.dart                                // group list view
│   │   ├── group_member_list_view.dart                         // group member list view
│   │   ├── message_list_view.dart                              // message list view
│   │   ├── new_requests_list_view.dart                         // contact request list view
│   │   ├── pin_message_list_view.dart                          // pin message list view
│   │   └── thread_message_list_view.dart                       // thread list view
│   ├── controllers                                             // list 相关的 controller
│   │   ├── block_list_view_controller.dart                     // block list view controller
│   │   ├── chat_uikit_list_view_controller_base.dart           // base controller
│   │   ├── contact_list_view_controller.dart                   // contact list view controller
│   │   ├── conversation_list_view_controller.dart              // conversation list view controller
│   │   ├── group_list_view_controller.dart                     // group list view controller
│   │   ├── group_member_list_view_controller.dart              // group member list view controller
│   │   ├── messages_view_controller.dart                       // message view controller
│   │   ├── new_request_list_view_controller.dart               // contact request list view controller
│   │   ├── pin_message_list_view_controller.dart               // pin message list view controller
│   │   ├── thread_members_view_controller.dart                 // theme member view controller
│   │   └── thread_messages_view_controller.dart                // thread messages view controller
│   ├── custom                                                  // ui中重写的部分
│   ├── models                                                  // models
│   │   ├── alphabetical_item_model.dart                        // alphabetical item model
│   │   ├── chat_uikit_list_item_model_base.dart                // base list item model
│   │   ├── contact_item_model.dart                             // contact list item model
│   │   ├── conversation_item_model.dart                        // conversation list item model
│   │   ├── group_item_model.dart                               // group list item model
│   │   ├── message_model.dart                                  // message item model
│   │   ├── new_request_item_model.dart                         // contact request list item model
│   │   └── quote_mode.dart                                     // message quote model
│   ├── route                                                   // uikit 中的路由组件
│   │   ├── chat_uikit_route.dart                               // uikit 路由
│   │   ├── chat_uikit_route_names.dart                         // uikit 中对每一个 view 的命名
│   │   ├── chat_uikit_view_observer.dart                       // 使用路由时的页面刷新observer
│   │   └── view_arguments                                      // 每一个 view 对应的 argument settings
│   │       ├── change_info_view_arguments.dart                 // 修改详情页面 argument settings
│   │       ├── contact_details_view_arguments.dart             // 联系人详情页面 argument settings
│   │       ├── contacts_view_arguments.dart                    // 通讯录页面 argument settings
│   │       ├── conversations_view_arguments.dart               // 会话页面 argument settings
│   │       ├── create_group_view_arguments.dart                // 创建群组页面 argument settings
│   │       ├── current_user_info_view_arguments.dart           // 当前用户详情页面 argument settings
│   │       ├── forward_message_select_view_arguments.dart      // 消息选择页面 argument settings
│   │       ├── forward_messages_view_arguments.dart            // 消息转发页面 argument settings
│   │       ├── group_add_members_view_arguments.dart           // 群组添加成员页面 argument settings
│   │       ├── group_change_owner_view_arguments.dart          // 转移群组页面 argument settings
│   │       ├── group_delete_members_view_arguments.dart        // 群组移除成员页面 argument settings
│   │       ├── group_details_view_arguments.dart               // 群详情页面 argument settings
│   │       ├── group_members_view_arguments.dart               // 群成员列表页面 argument settings
│   │       ├── group_mention_view_arguments.dart               // 群成员@页面 argument settings
│   │       ├── groups_view_arguments.dart                      // 群列表页面 argument settings
│   │       ├── messages_view_arguments.dart                    
│   │       ├── new_request_details_view_arguments.dart
│   │       ├── new_requests_view_arguments.dart
│   │       ├── report_message_view_arguments.dart
│   │       ├── search_group_members_view_arguments.dart
│   │       ├── search_history_view_arguments.dart
│   │       ├── search_view_arguments.dart
│   │       ├── select_contact_view_arguments.dart
│   │       ├── show_image_view_arguments.dart
│   │       ├── show_video_view_arguments.dart
│   │       ├── thread_members_view_arguments.dart
│   │       ├── thread_messages_view_arguments.dart
│   │       ├── threads_view_arguments.dart
│   │       └── view_arguments_base.dart
│   ├── views
│   │   ├── change_info_view.dart
│   │   ├── contact_details_view.dart
│   │   ├── contacts_view.dart
│   │   ├── conversations_view.dart
│   │   ├── create_group_view.dart
│   │   ├── current_user_info_view.dart
│   │   ├── forward_message_select_view.dart
│   │   ├── forward_messages_view.dart
│   │   ├── group_add_members_view.dart
│   │   ├── group_change_owner_view.dart
│   │   ├── group_delete_members_view.dart
│   │   ├── group_details_view.dart
│   │   ├── group_members_view.dart
│   │   ├── group_mention_view.dart
│   │   ├── groups_view.dart
│   │   ├── messages_view.dart
│   │   ├── new_request_details_view.dart
│   │   ├── new_requests_view.dart
│   │   ├── report_message_view.dart
│   │   ├── search_group_members_view.dart
│   │   ├── search_history_view.dart
│   │   ├── search_view.dart
│   │   ├── select_contact_view.dart
│   │   ├── show_image_view.dart
│   │   ├── show_video_view.dart
│   │   ├── thread_members_view.dart
│   │   ├── thread_messages_view.dart
│   │   └── threads_view.dart
│   └── widgets
│       ├── chat_uikit_alphabetical_widget.dart
│       ├── chat_uikit_app_bar.dart
│       ├── chat_uikit_avatar.dart
│       ├── chat_uikit_badge.dart
│       ├── chat_uikit_bottom_sheet.dart
│       ├── chat_uikit_button.dart
│       ├── chat_uikit_dialog.dart
│       ├── chat_uikit_downloads_helper_widget.dart
│       ├── chat_uikit_emoji_rich_text_widget.dart
│       ├── chat_uikit_input_bar.dart
│       ├── chat_uikit_input_emoji_bar.dart
│       ├── chat_uikit_list_view.dart
│       ├── chat_uikit_message_reaction_info.dart
│       ├── chat_uikit_message_status_widget.dart
│       ├── chat_uikit_quote_widget.dart
│       ├── chat_uikit_record_bar.dart
│       ├── chat_uikit_reg_exp_text.dart
│       ├── chat_uikit_reply_bar.dart
│       ├── chat_uikit_search_widget.dart
│       ├── chat_uikit_show_image_widget.dart
│       ├── chat_uikit_show_video_widget.dart
│       ├── chat_uikit_water_ripple.dart
│       └── list_view_items
│           ├── chat_uikit_alphabetical_list_view_item.dart
│           ├── chat_uikit_contact_list_view_item.dart
│           ├── chat_uikit_conversation_list_view_item.dart
│           ├── chat_uikit_details_list_view_item.dart
│           ├── chat_uikit_group_list_view_item.dart
│           ├── chat_uikit_list_view_more_item.dart
│           ├── chat_uikit_new_request_list_view_item.dart
│           ├── chat_uikit_reaction_widget.dart
│           ├── chat_uikit_search_list_view_item.dart
│           └── message_list_view_items
│               ├── chat_uikit_message_bubble_widget.dart
│               ├── chat_uikit_message_list_view_alert_item.dart
│               ├── chat_uikit_message_list_view_message_item.dart
│               ├── chat_uikit_message_reactions_row.dart
│               ├── chat_uikit_message_thread_widget.dart
│               └── message_widget
│                   ├── chat_uikit_card_bubble_widget.dart
│                   ├── chat_uikit_combine_bubble_widget.dart
│                   ├── chat_uikit_file_bubble_widget.dart
│                   ├── chat_uikit_image_bubble_widget.dart
│                   ├── chat_uikit_nonsupport_bubble_widget.dart
│                   ├── chat_uikit_text_bubble_widget.dart
│                   ├── chat_uikit_video_bubble_widget.dart
│                   └── chat_uikit_voice_bubble_widget.dart
└── universal
    ├── chat_string_extension.dart
    ├── chat_uikit_action_model.dart
    ├── chat_uikit_log.dart
    ├── chat_uikit_tools.dart
    ├── defines.dart
    └── inner_headers.dart
```

# 快速开始

# 进阶用法

# 自定义

# 设计指南
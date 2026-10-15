# AGENTS.md

`em_chat_uikit` is the Easemob Flutter UI component library for conversations, messages, contacts, groups, threads, presence, and chat rooms. It wraps `im_flutter_sdk` behind service and controller layers and exposes reusable views, components, widgets, routes, themes, localization, and profile providers. This document follows the repository's canonical English documentation.

## Document Baseline

| Item | Current value |
|---|---|
| Package version | `2.4.0` |
| `im_flutter_sdk` | `^5.0.0` |
| `chat_uikit_theme` | `1.0.4` |
| `chat_uikit_keyboard_panel` | `0.1.2` |
| Dart | `>=3.0.0 <4.0.0` |
| Flutter | `>=3.3.0` |
| Android | minSdk 24 |
| iOS | 13.0 |

This file is versioned operating documentation. Whenever the package version or any dependency or platform baseline listed above changes, update this table in the same change. If a release changes architecture, initialization, supported behavior, or validation, update the corresponding sections as well. The example application's version is independent from the library release version.

## Collaboration Conventions

- Keep this file in English, matching the canonical `README.md`. Maintain `README_zh.md` as the Chinese user-documentation counterpart when user-facing behavior changes.
- When the investigation direction is unclear, or the same problem remains unresolved for more than a few minutes, share the symptoms and current hypotheses with the user before continuing.
- Keep changes within the layer that owns the behavior. State which SDK, service, controller, component, and route layers are affected before making a cross-layer change.
- Do not commit or push unless the user authorizes it.

### Work Log

- After completing a task, making an important decision, or receiving a correction from the user, append an entry to `dailylog/YYYY-MM-DD.md` using the local date. Create the file if it does not exist.
- Append only; do not modify existing content. Format each entry as: `- HH:MM <what was done or decided>, reason: <...>`.
- Logs may record progress and process details.
- Track work logs under `dailylog/` in Git; do not add the directory to `.gitignore`. When making a user-authorized Git commit, include the log changes from the current work. Logging itself does not trigger a commit or push.

## Architecture

| Path | Responsibility |
|---|---|
| `lib/chat_uikit.dart` | Root public barrel that exports all supported UIKit modules |
| `lib/chat_sdk_service/` | IM SDK isolation layer: SDK aliases, operations, callback wrappers, and observers |
| `lib/chat_sdk_context/` | Per-user persistent context and lightweight cached state |
| `lib/chat_uikit/` | Main UIKit service plus views, components, controllers, models, widgets, routes, settings, and tools |
| `lib/chat_uikit_provider/` | Contact, group, chat-room, and custom profile lookup, caching, and update notifications |
| `lib/chat_uikit_localizations/` | Localization keys, locale maps, delegates, and locale switching |
| `lib/chat_uikit_universal/` | Shared enums, definitions, emoji data, image loading, and common widgets |
| `lib/chatroom_uikit/` | Chat-room-specific UI, images, dialogs, and sheets |
| `assets/` | Package image and emoji assets used through package-aware asset loading |
| `example/` | Runnable integration app demonstrating initialization, login, routing, provider data, settings, and UI customization |
| `android/`, `ios/` | Thin Flutter plugin shells and deployment configuration |

The command flow is:

`View/controller` -> `ChatUIKit.instance` -> UIKit actions -> `ChatSDKService` actions -> `im_flutter_sdk`.

The event flow is:

`im_flutter_sdk callback` -> service wrapper/observer -> UIKit observer -> controller state -> component/view rebuild.

## Layer Boundaries

- Only `lib/chat_sdk_service/src/chat_sdk_define.dart` should import and re-export `im_flutter_sdk` directly. Add SDK aliases there and consume the neutral types through the service layer elsewhere.
- `chat_sdk_service/src/actions/` owns SDK operations. `wrappers/` translates SDK callbacks, and `observers/` defines events consumed by upper layers.
- `ChatUIKit` is the singleton integration surface. UIKit-specific actions and observers live under `chat_uikit/src/chat_uikit_service/` rather than in widgets.
- Controllers own list data, pagination, SDK observers, loading state, and disposal. Components and views render controller state and expose customization callbacks.
- `ChatUIKitProvider` owns display profiles and their caches. Do not add parallel avatar or display-name caches inside individual views.
- `ChatSDKContext` owns per-user persisted UIKit context. Clear or switch user-scoped state when the logged-in user changes.

## State And Lifecycle Rules

- Initialize `ChatUIKit.instance` with `Options` before login or UI use. For SDK 5.0 data-backed lists, preserve the required `ChatDataSyncType` flags for conversations, contacts, and joined groups.
- Use token login. Password login and SDK automatic-login handling were removed for the 2.4.0 / SDK 5.0 integration.
- Add and remove the same observer instance symmetrically. Controllers that register with `ChatUIKit.instance` must unregister in `dispose` and dispose owned notifiers.
- Respect `hasDisposed` or equivalent guards before notifying UI state after asynchronous work.
- Preserve `_BuildSafeValueNotifier` behavior in the list-controller base: notifications requested during widget build are deferred to a post-frame callback to avoid framework build errors.
- On logout, keep observer cleanup, user-context switching, and `ChatUIKitProvider` cache clearing consistent.
- Treat static values in `ChatUIKitSettings` as application-wide configuration, not per-view transient state.

## Adding Or Changing Features

For an SDK-backed capability, follow the established chain as applicable:

1. Add or update the SDK alias/export in `chat_sdk_define.dart`.
2. Add the low-level action and any callback wrapper/observer in `chat_sdk_service`.
3. Expose UIKit behavior through `ChatUIKit` actions or observers.
4. Update the relevant model/controller and its observer lifecycle.
5. Update the component, view, widget, route arguments, and customization hooks.
6. Export every intended public type from the module barrel and ultimately `lib/chat_uikit.dart`.
7. Update examples, localization, README files, and changelogs for user-visible behavior.

Prefer existing extension points such as builders, action lists, observers, `ChatUIKitSettings`, `ChatUIKitProvider`, and route arguments before adding a parallel customization system.

## Routes, Localization, Theme, And Assets

- A new routed view requires a route name, a `ChatUIKitViewArguments` type, a builder entry in `ChatUIKitRoute.uikitRoutes`, navigation support, and public exports.
- Route customization should preserve typed arguments. Applications can intercept `RouteSettings` and return copied arguments with custom builders or observers.
- Add localization keys to `ChatUIKitLocal`, provide every supported locale value, and render them through the existing localization extension. Keep English and Chinese entries in sync.
- Use `ChatUIKitTheme`, theme mixins, and `chat_uikit_theme` tokens instead of introducing unrelated hard-coded design values in shared UI.
- Register new package assets in `pubspec.yaml` and load them with the correct `em_chat_uikit` package context. Package-name-sensitive asset code is also relevant to overseas synchronization.

## Versioning And Cross-Repository Synchronization

- Release branches use the package version as the branch name. The checked-out release branch and `pubspec.yaml` version must agree.
- A version change must update `pubspec.yaml`, the Document Baseline in this file, `CHANGELOG.md`, `CHANGELOG_zh.md`, and version-specific README content as applicable.
- The root `pubspec.lock` is intentionally untracked for this library package; `example/pubspec.lock` is tracked for reproducible example builds.
- This repository is the domestic source for `AgoraChat-UIKit-flutter`. The parent workspace's `scripts/sync-uikit-to-agora.sh` performs the controlled source-to-overseas conversion.
- Keep native plugin identifiers neutral (`ChatUikitPlugin`, `chat_uikit`, and `com.chat.uikit`) and keep SDK-specific naming isolated so the synchronization remains mechanical.
- When synchronization is in scope, follow the parent workspace guide and run its completeness checks and example builds; do not manually maintain a second implementation in the overseas repository.

## Code Conventions

- Follow `flutter_lints` and the surrounding file's import grouping and documentation language.
- Use package imports consistently across library modules. Avoid reaching across layers to call SDK internals from views.
- Keep controllers focused on state and operations; keep rendering and interaction composition in widgets, components, and views.
- Guard asynchronous UI callbacks with mounted/disposed checks and preserve the current list ordering, pagination, and loading-state semantics.
- Maintain public API compatibility deliberately. Renames or removals require changelog and migration documentation.

## Validation

Run validation from this repository, not from the parent workspace.

- For library changes: run `flutter pub get` and `flutter analyze` at the repository root.
- For example or integration changes: run `flutter pub get` and `flutter analyze` in `example/`.
- For dependency, asset, or platform changes: build or run the example on every affected platform.
- For controller or event changes: exercise initial load, refresh, pagination, live SDK updates, logout/login user switching, and disposal during in-flight work.
- For message UI changes: cover send/receive, status updates, history loading, reply, edit, recall, reaction, thread, pin, translation, attachment, and scrolling behavior as applicable.
- This repository currently has no automated Dart test directory. Do not claim test coverage from `flutter test`; add focused tests when a change introduces logic that can be isolated reliably.

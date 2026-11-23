// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "em_chat_uikit",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "em-chat-uikit",
            targets: ["em_chat_uikit"]
        )
    ],
    dependencies: [
        .package(
            name: "FlutterFramework",
            path: "../FlutterFramework"
        )
    ],
    targets: [
        .target(
            name: "em_chat_uikit",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ],
            path: "Sources/em_chat_uikit"
        )
    ]
)

// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "YABAOCHEAT",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "YABAOCHEAT",
            targets: ["YABAOCHEAT"]
        ),
    ],
    targets: [
        .target(
            name: "YABAOCHEAT",
            path: "Sources",
            resources: [
                .process("../Resources")
            ]
        )
    ]
)

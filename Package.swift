// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "LuckyRemotePanel",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "LuckyRemotePanel", targets: ["LuckyRemotePanel"])
    ],
    targets: [
        .target(
            name: "LuckyRemotePanel",
            path: "Sources"
        )
    ]
)

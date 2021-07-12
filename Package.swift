// swift-tools-version:5.3.0

import PackageDescription

let name: String = "WorkspaceGen"

let platforms: [SupportedPlatform] = [
    .macOS(.v10_13)
]

let products: [Product] = [
    .executable(
        name: "wksgen",
        targets: [
            "WorkspaceGen"
        ]
    )
]

let dependencies: [Package.Dependency] = [
    .package(url: "https://github.com/jpsim/Yams.git", from: "4.0.0"),
    .package(url: "https://github.com/jakeheis/SwiftCLI.git", from: "6.0.0"),
    .package(url: "https://github.com/onevcat/Rainbow.git", .upToNextMajor(from: "4.0.0"))
]

let targets: [Target] = [
    .target(
        name: "WorkspaceGen",
        dependencies: [
            "WorkspaceGenCLI"
        ]
    ),
    .target(
        name: "WorkspaceGenCLI",
        dependencies: [
            "Yams",
            "SwiftCLI",
            "Rainbow"
        ]
    ),
    .testTarget(
        name: "WorkspaceGenCLITests",
        dependencies: [
            "WorkspaceGenCLI"
        ]
    )
]

let package = Package(
    name: name,
    platforms: platforms,
    products: products,
    dependencies: dependencies,
    targets: targets
)

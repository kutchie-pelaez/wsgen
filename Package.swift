// swift-tools-version:5.3.0

import PackageDescription

let name: String = "WorkspaceGen"

let platforms: [SupportedPlatform] = [
    .macOS(.v10_15)
]

let products: [Product] = [
    .executable(
        name: "wsgen",
        targets: [
            "WorkspaceGen"
        ]
    )
]

let dependencies: [Package.Dependency] = [
    .package(url: "https://github.com/MaxDesiatov/XMLCoder.git", from: "0.13.0"),
    .package(url: "https://github.com/jakeheis/SwiftCLI.git", from: "6.0.3"),
    .package(url: "https://github.com/jpsim/Yams.git", from: "4.0.6"),
    .package(url: "https://github.com/kylef/PathKit.git", from: "1.0.1"),
    .package(url: "https://github.com/onevcat/Rainbow.git", .upToNextMajor(from: "4.0.1"))
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
            "Core",
            "SwiftCLI",
            "Rainbow",
            "PathKit",
            "Yams"
        ]
    ),
    .target(
        name: "Core",
        dependencies: [
            "XMLCoder",
            "PathKit"
        ]
    ),
    .testTarget(
        name: "WorkspaceGenCLITests",
        dependencies: [
            "WorkspaceGenCLI",
            "XMLCoder",
            "PathKit"
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

// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "LinAlgTutorials",
    dependencies: [
    ],
    targets: [
        // run with `swift run`
        .executableTarget(
            name: "LinAlgTutorials",
            dependencies: [
            ],
            path: "Sources"),
        // run with `swift test`
        .testTarget(
            name: "LinAlgTutorialsTests",
            dependencies: ["LinAlgTutorials"],
            path: "Tests"),
    ]
)

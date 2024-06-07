// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "NewProject",
    dependencies: [
      // used for printing colored text to the terminal
      .package(url: "https://github.com/onevcat/Rainbow", branch: "master")
    ],
    targets: [
        // run with `swift run`
        .executableTarget(
            name: "NewProject",
            dependencies: [
                .product(name: "Rainbow", package: "Rainbow")
            ],
            path: "Sources"),
        // run with `swift test`
        .testTarget(
            name: "NewProjectTests",
            dependencies: ["NewProject"],
            path: "Tests"),
    ]
)

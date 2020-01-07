// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BuildTools",
    dependencies: [
        .package(url: "https://github.com/shibapm/Komondor.git", from: "1.0.4"),
    ]
)

#if canImport(PackageConfig)
    import PackageConfig

    let config = PackageConfiguration([
        "komondor": [
            "pre-push": [],
            "pre-commit": [
                "mint run nicklockwood/SwiftFormat swiftformat SwiftUIArchitecture/Source --swiftversion 5",
                // "mint run swiftlint swiftlint autocorrect",
                "git add .",
            ],
        ],
    ]).write()
#endif
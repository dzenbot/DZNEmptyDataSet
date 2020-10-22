// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "DZNEmptyDataSet",
    platforms: [
        .iOS(.v8),
        .tvOS(.v9)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "DZNEmptyDataSet",
            targets: ["DZNEmptyDataSet"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),        //

    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "DZNEmptyDataSet",
            dependencies: [
            ],
            path: "Source",
            exclude: ["DZNEmptyDataSet"]
        )
    ]
)

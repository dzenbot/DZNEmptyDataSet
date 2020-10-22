// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "DZNEmptyDataSet",
    platforms: [
        .iOS(.v8),
        .tvOS(.v9)
    ],
    products: [
        .library(
            name: "DZNEmptyDataSet",
            targets: ["DZNEmptyDataSet"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "DZNEmptyDataSet",
            dependencies: [],
            path: "Source",
            exclude: ["DZNEmptyDataSet"],
            publicHeadersPath: "."
        )
    ]
)

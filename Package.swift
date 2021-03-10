// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Yelm.Server",
    platforms: [
        .iOS(.v13),
        .watchOS(.v5),
        .macOS(.v10_14)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Yelm.Server",
            targets: ["Yelm.Server"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.2.0")),
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "4.0.0"),
        .package(name: "Realm", url: "https://github.com/realm/realm-cocoa.git", from: "10.5.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Yelm.Server",
            dependencies: ["Alamofire", "SwiftyJSON", .product(name: "RealmSwift", package: "Realm")]),
        .testTarget(
            name: "Yelm.ServerTests",
            dependencies: ["Yelm.Server"]),
    ]
)

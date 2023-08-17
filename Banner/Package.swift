// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

//let package = Package(
//    name: "Banner",
//    products: [
//        // Products define the executables and libraries a package produces, making them visible to other packages.
//        .library(name: "Banner",targets: ["Banner"]),
//    ],
//    targets: [
//        // Targets are the basic building blocks of a package, defining a module or a test suite.
//        // Targets can depend on other targets in this package and products from dependencies.
//        .target(name: "Banner"),
//        .testTarget(name: "BannerTests",dependencies: ["Banner"]),
//    ]
//)


let package = Package(
    name: "Banner",
    products: [
        //.library(name: "Banner", targets: ["Banner"]) //Target
        
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.0.1"),
        //.product(name: "ArgumentParser", package: "swift-argument-parser"),
    ],
    targets: [
        //.target(name: "Banner", dependencies: ["ArgumentParser"]),
        .executableTarget(name: "Banner", dependencies: [
            // other dependencies
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
        ]),
        .testTarget(name: "BannerTests", dependencies: ["Banner"]),
    ]
)


//        targets: [
//                .executableTarget(name: "<command-line-tool>", dependencies: [
//                    // other dependencies
//                    .product(name: "ArgumentParser", package: "swift-argument-parser"),
//                ]),

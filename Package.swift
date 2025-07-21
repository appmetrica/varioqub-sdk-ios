// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let useSpmExternalPackages = false

let swiftCompilerSettings: [SwiftSetting] = [
    .define("VQ_MODULES"),
]

enum VarioqubTarget: String, CaseIterable {
    case utils = "VarioqubUtils"
    case network = "VarioqubNetwork"
    case varioqub = "Varioqub"
    case objc = "VarioqubObjC"
}

enum VarioqubProduct: String, CaseIterable {
    case varioqub = "Varioqub"
    case varioqubObjC = "VarioqubObjC"
    
    var targets: [VarioqubTarget] {
        switch self {
        case .varioqub: return [.utils, .network, .varioqub]
        case .varioqubObjC: return [.utils, .network, .varioqub, .objc]
        }
    }
}

enum ExternalDependency: String, CaseIterable {
    case swiftLog = "swift-log"
    case protobuf = "protobuf"
    
    var versions: Range<Version> {
        switch self {
        case .swiftLog: return "1.5.2"..<"2.0.0"
        case .protobuf: return "1.21.0"..<"2.0.0"
        }
    }
    
    var regularPackageName: String {
        switch self {
        case .swiftLog: return "swift-log"
        case .protobuf: return "swift-protobuf"
        }
    }
    
    var spmExternalPackageName: String {
        switch self {
        case .swiftLog: return "swift-log"
        case .protobuf: return "SwiftProtobuf"
        }
    }
    
    var targetDependency: Target.Dependency {
        switch self {
        case .swiftLog: return .product(name: "Logging", package: packageName)
        case .protobuf: return .product(name: "SwiftProtobuf", package: packageName)
        }
    }
    
    var regularPackageDependency: Package.Dependency {
        switch self {
        case .swiftLog: return .package(url: "https://github.com/apple/swift-log", versions)
        case .protobuf: return .package(url: "https://github.com/apple/swift-protobuf", versions)
        }
    }
    
    var spmExternalPackageDependency: Package.Dependency {
        switch self {
        case .swiftLog: return .package(id: "spm-external.swift-log", versions)
        case .protobuf: return .package(id: "spm-external.SwiftProtobuf", versions)
        }
    }
    
}

let targets: [Target] = [
    .target(varioqubTarget: .utils, includePrivacyManifest: true),
    .testTarget(varioqubTarget: .utils),
    
    .target(varioqubTarget: .network, dependencies: [.utils], externalDependencies: [.swiftLog]),
    .testTarget(varioqubTarget: .network),
    
    .target(
        varioqubTarget: .varioqub,
        resources: [.process("Protobuf/proto")],
        dependencies: [.utils, .network],
        externalDependencies: [.swiftLog, .protobuf]
    ),
    .testTarget(varioqubTarget: .varioqub),
    
    .target(varioqubTarget: .objc, dependencies: [.varioqub]),
]

let package = Package(
        name: "Varioqub",
        platforms: [
            .iOS(.v13),
            .tvOS(.v13),
        ],
        products: VarioqubProduct.allCases.map(\.product),
        dependencies: ExternalDependency.allCases.map(\.packageDependency),
        targets: targets
)

extension VarioqubTarget {
    var name: String { rawValue }
    var testsName: String { rawValue + "Tests" }
    var path: String { "Sources/\(rawValue)" }
    var testsPath: String { "Tests/\(rawValue)Tests" }
    var dependency: Target.Dependency { .target(name: rawValue) }
}

extension VarioqubProduct {
    var product: Product {
        .library(
            name: rawValue,
            targets: targets.map(\.name)
        )
    }
}

extension ExternalDependency {
    
    var packageName: String {
        useSpmExternalPackages ? "spm-external.\(spmExternalPackageName)" : regularPackageName
    }
    
    var packageDependency: Package.Dependency {
        useSpmExternalPackages ? spmExternalPackageDependency : regularPackageDependency
    }
}

extension Target {
    
    static func target(
        varioqubTarget: VarioqubTarget,
        resources: [Resource]? = nil,
        dependencies: [VarioqubTarget] = [],
        externalDependencies: [ExternalDependency] = [],
        includePrivacyManifest: Bool = true
    ) -> Target {
        var res: [Resource] = resources ?? []
        if includePrivacyManifest {
            res.append(.copy("Resources/PrivacyInfo.xcprivacy"))
        }
        return .target(
            name: varioqubTarget.name,
            dependencies: dependencies.map(\.dependency) + externalDependencies.map(\.targetDependency),
            path: varioqubTarget.path,
            resources: res,
            swiftSettings: swiftCompilerSettings
        )
    }
    
    static func testTarget(
        varioqubTarget: VarioqubTarget,
        dependencies: [VarioqubTarget] = [],
        externalDependencies: [ExternalDependency] = []
    ) -> Target {
        let allDeps = [varioqubTarget.dependency] + dependencies.map(\.dependency) + externalDependencies.map(\.targetDependency)
        return .testTarget(
            name: varioqubTarget.testsName,
            dependencies: allDeps,
            path: varioqubTarget.testsPath,
            swiftSettings: swiftCompilerSettings
        )
    }
    
}

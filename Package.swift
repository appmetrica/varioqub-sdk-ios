// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let usedSource: DependencySource = .regular
let spmExternalScope = "spm-external"

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
    case protobuf = "swift-protobuf"
    case swiftLog = "swift-log"
    
    var version: DependencyVersion {
        switch self {
        case .swiftLog: return .range("1.5.2"..<"2.0.0")
        case .protobuf: return .range("1.21.0"..<"2.0.0")
        }
    }
    
    var regularPackageName: String {
        switch self {
        case .swiftLog: return "swift-log"
        case .protobuf: return "swift-protobuf"
        }
    }
    
    var localPackageName: String {
        switch self {
        case .swiftLog: return "\(spmExternalScope).swift-log"
        case .protobuf: return "\(spmExternalScope).SwiftProtobuf"
        }
    }
    
    var spmExternalPackageName: String {
        switch self {
        case .swiftLog: return "\(spmExternalScope).swift-log"
        case .protobuf: return "\(spmExternalScope).SwiftProtobuf"
        }
    }
    
    var regularPackageDependency: Package.Dependency {
        switch self {
        case .swiftLog: return .package(url: "https://github.com/apple/swift-log", version: version)
        case .protobuf: return .package(url: "https://github.com/apple/swift-protobuf", version: version)
        }
    }
    
    var spmExternalPackageDependency: Package.Dependency {
        switch self {
        case .swiftLog: return .package(id: "\(spmExternalScope).swift-log", version: version)
        case .protobuf: return .package(id: "\(spmExternalScope).SwiftProtobuf", version: version)
        }
    }
    
    var localPackageDependency: Package.Dependency {
        switch self {
        case .swiftLog: return .package(id: "\(spmExternalScope).swift-log", version: version)
        case .protobuf: return .package(id: "\(spmExternalScope).SwiftProtobuf", version: version)
        }
    }
}

enum ExternalTargetDependency: String, CaseIterable {
    case swiftLog = "Logging"
    case protobuf = "SwiftProtobuf"
    
    var package: ExternalDependency {
        switch self {
        case .swiftLog: return .swiftLog
        case .protobuf: return .protobuf
        }
    }
    
    var targetDependency: Target.Dependency {
        .product(name: rawValue, package: package.packageName)
    }
}


let targets: [Target] = [
    .target(varioqubTarget: .utils, includePrivacyManifest: true),
    .testTarget(varioqubTarget: .utils),
    
    .target(varioqubTarget: .network, dependencies: [.utils], externalDependencies: [.swiftLog]),
    .testTarget(varioqubTarget: .network),
    
    .target(
        varioqubTarget: .varioqub,
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
        switch usedSource {
        case .local:
            return localPackageName
        case .regular:
            return regularPackageName
        case .spmExternal:
            return spmExternalPackageName
        }
    }
    
    var packageDependency: Package.Dependency {
        switch usedSource {
        case .local:
            return localPackageDependency
        case .regular:
            return regularPackageDependency
        case .spmExternal:
            return spmExternalPackageDependency
        }
    }
}

extension Target {
    
    static func target(
        varioqubTarget: VarioqubTarget,
        resources: [Resource]? = nil,
        dependencies: [VarioqubTarget] = [],
        externalDependencies: [ExternalTargetDependency] = [],
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
        externalDependencies: [ExternalTargetDependency] = []
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

extension Package.Dependency {
    static func package(id: String, version: DependencyVersion) -> Package.Dependency {
        switch version {
        case .exact(let v):
            return .package(id: id, exact: v)
        case .range(let r):
            return .package(id: id, r)
        }
    }
    
    static func package(url: String, version: DependencyVersion) -> Package.Dependency {
        switch version {
        case .exact(let v):
            return .package(url: url, exact: v)
        case .range(let r):
            return .package(url: url, r)
        }
    }
}

enum DependencyVersion {
    case exact(Version)
    case range(Range<PackageDescription.Version>)
}

enum DependencySource {
    case local
    case regular
    case spmExternal
}

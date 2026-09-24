// swift-tools-version:5.8

import PackageDescription
import Foundation

// MARK: - Dependencies

func hasFile(_ path: String) -> Bool {
    FileManager.default.fileExists(
        atPath: URL(fileURLWithPath: #file)
            .deletingLastPathComponent()
            .appendingPathComponent(path)
            .path
    )
}

// DO NOT CHANGE DEFAULT VALUES IN TRUNK
let useRegistry = hasFile(".spm-use-registry") || false

struct ExternalDependency {
    let package: String
    let dependency: Package.Dependency

    init(url: String, registryId: String, version: VersionSpec) {
        if useRegistry {
            self.package = registryId
            self.dependency = switch version {
            case .upToNextMajor(from: let from): .package(id: self.package, .upToNextMajor(from: from))
            }
        } else {
            self.package = URL(string: url)!.lastPathComponent
            self.dependency = switch version {
            case .upToNextMajor(from: let from): .package(url: url, .upToNextMajor(from: from))
            }
        }
    }

    enum VersionSpec {
        case upToNextMajor(from: Version)
    }
}

enum SwiftLog {
    private static let dep = ExternalDependency(
        url: "https://github.com/apple/swift-log",
        registryId: "spm-external.swift-log",
        version: .upToNextMajor(from: "1.5.2"),
    )

    static let dependency: Package.Dependency = dep.dependency
    static let logging: Target.Dependency = .product(name: "Logging", package: dep.package)
}

enum Protobuf {
    private static let dep = ExternalDependency(
        url: "https://github.com/apple/swift-protobuf",
        registryId: "spm-external.SwiftProtobuf",
        version: .upToNextMajor(from: "1.21.0"),
    )

    static let dependency: Package.Dependency = dep.dependency
    static let protobuf: Target.Dependency = .product(name: "SwiftProtobuf", package: dep.package)
}

// MARK: - Module

protocol ModuleDependency {
    var asTargetDependency: Target.Dependency { get }
}

extension String : ModuleDependency {
    var asTargetDependency: Target.Dependency { .target(name: self) }
}

extension Target.Dependency : ModuleDependency {
    var asTargetDependency: Target.Dependency { self }
}

struct Module {
    let name: String
    let dependencies: [Target.Dependency]
    let hasTests: Bool
    let testDependencies: [Target.Dependency]

    init(name: String, dependencies: [ModuleDependency], hasTests: Bool = true, testDependencies: [ModuleDependency] = []) {
        self.name = name
        self.dependencies = dependencies.map(\.asTargetDependency)
        self.hasTests = hasTests
        self.testDependencies = testDependencies.map(\.asTargetDependency)
    }

    func toTargets() -> [Target] {
        var targets: [Target] = [
            .target(
                name: name,
                dependencies: dependencies,
                resources: [.copy("Resources/PrivacyInfo.xcprivacy")],
                swiftSettings: [.define("VQ_MODULES")],
            )
        ]
        if hasTests {
            targets.append(
                .testTarget(
                    name: "\(name)Tests",
                    dependencies: [.target(name: name)] + dependencies + testDependencies,
                    swiftSettings: [.define("VQ_MODULES")],
                )
            )
        }
        return targets
    }
}

extension Module {
    static let varioqub = "Varioqub"
    static let network = "VarioqubNetwork"
    static let objc = "VarioqubObjC"
    static let utils = "VarioqubUtils"
}

// MARK: - Varioqub Module

let varioqub = Module(
    name: Module.varioqub,
    dependencies: [
        Module.utils,
        Module.network,
        SwiftLog.logging,
        Protobuf.protobuf,
    ],
)

// MARK: - Network Module

let network = Module(
    name: Module.network,
    dependencies: [
        Module.utils,
        SwiftLog.logging,
    ],
)

// MARK: - ObjC Module

let objc = Module(
    name: Module.objc,
    dependencies: [
        Module.varioqub,
    ],
    hasTests: false,
)

// MARK: - Utils Module

let utils = Module(
    name: Module.utils,
    dependencies: [],
)

// MARK: - Package definition

let package = Package(
    name: "Varioqub",
    platforms: [
        .iOS(.v15),
        .tvOS(.v15),
    ],
    products: [
        .library(name: "Varioqub", targets: [Module.varioqub, Module.network, Module.utils]),
        .library(name: "VarioqubObjC", targets: [Module.varioqub, Module.network, Module.objc, Module.utils]),
    ],
    dependencies: [
        SwiftLog.dependency,
        Protobuf.dependency,
    ],
    targets: [
        varioqub,
        network,
        objc,
        utils,
    ].flatMap { $0.toTargets() },
)

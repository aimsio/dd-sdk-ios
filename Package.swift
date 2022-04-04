// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "DatadogSDK",
    platforms: [
        .iOS(.v11),
        .tvOS(.v11)
    ],
    products: [
        .library(
            name: "Datadog",
            type: .dynamic,
            targets: ["Datadog"]
        ),
        .library(
            name: "DatadogObjc",
            type: .dynamic,
            targets: ["DatadogObjc"]
        ),
        .library(
            name: "DatadogStatic",
            type: .static,
            targets: ["Datadog"]
        ),
        .library(
            name: "DatadogStaticObjc",
            type: .static,
            targets: ["DatadogObjc"]
        ),
        .library(
            name: "DatadogCrashReporting",
            type: .dynamic,
            targets: ["DatadogCrashReporting"]
        ),
        .library(
            name: "DatadogCrashReportingStatic",
            type: .static,
            targets: ["DatadogCrashReporting"]
        ),
    ],
    dependencies: [
        .package(name: "PLCrashReporter", url: "https://github.com/microsoft/plcrashreporter.git", from: "1.10.0"),
    ],
    targets: [
        .target(
            name: "Datadog",
            dependencies: [
                "_Datadog_Private",
            ],
            swiftSettings: [
                .define("SPM_BUILD"),
                .define("DD_SDK_ENABLE_INTERNAL_MONITORING"),
                .define("DD_SDK_ENABLE_EXPERIMENTAL_APIS"),
            ]
        ),
        .target(
            name: "DatadogObjc",
            dependencies: [
                "Datadog",
            ],
            swiftSettings: [
                .define("DD_SDK_ENABLE_INTERNAL_MONITORING"),
                .define("DD_SDK_ENABLE_EXPERIMENTAL_APIS"),
            ]
        ),
        .target(
            name: "_Datadog_Private"
        ),
        .target(
            name: "DatadogCrashReporting",
            dependencies: [
                "Datadog",
                .product(name: "CrashReporter", package: "PLCrashReporter"),
            ],
            swiftSettings: [
                .define("DD_SDK_ENABLE_INTERNAL_MONITORING"),
                .define("DD_SDK_ENABLE_EXPERIMENTAL_APIS"),
            ]
        )
    ]
)

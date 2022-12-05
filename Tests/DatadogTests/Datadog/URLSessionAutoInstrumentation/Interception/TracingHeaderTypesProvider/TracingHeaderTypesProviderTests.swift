/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at Datadog (https://www.datadoghq.com/).
 * Copyright 2019-2020 Datadog, Inc.
 */

import XCTest
@testable import Datadog

class TracingHeaderTypesProviderTests: XCTestCase {
    let firstPartyHosts: FirstPartyHosts = [
        "http://first-party.com/": .init(arrayLiteral: .w3c, .b3s),
        "https://first-party.com/": .init(arrayLiteral: .w3c, .b3s),
        "https://api.first-party.com/v2/users": .init(arrayLiteral: .w3c, .b3s),
        "https://www.first-party.com/": .init(arrayLiteral: .w3c, .b3s),
        "https://login:p4ssw0rd@first-party.com:999/": .init(arrayLiteral: .w3c, .b3s),
        "http://any-domain.eu/": .init(arrayLiteral: .w3c, .b3s),
        "https://any-domain.eu/": .init(arrayLiteral: .w3c, .b3s),
        "https://api.any-domain.eu/v2/users": .init(arrayLiteral: .w3c, .b3s),
        "https://www.any-domain.eu/": .init(arrayLiteral: .w3c, .b3s),
        "https://login:p4ssw0rd@www.any-domain.eu:999/": .init(arrayLiteral: .w3c, .b3s),
        "https://api.any-domain.org.eu/": .init(arrayLiteral: .w3c, .b3s),
    ]

    let otherHosts = [
        "http://third-party.com/",
        "https://third-party.com/",
        "https://api.third-party.com/v2/users",
        "https://www.third-party.com/",
        "https://login:p4ssw0rd@third-party.com:999/",
        "http://any-domain.org/",
        "https://any-domain.org/",
        "https://api.any-domain.org/v2/users",
        "https://www.any-domain.org/",
        "https://login:p4ssw0rd@www.any-domain.org:999/",
        "https://api.any-domain.eu.org/",
    ]

    func test_TracingHeaderTypesProviderWithEmptyDictionary_itReturnsDefaultTracingHeaderTypes() {
        let headerTypesProvider = TracingHeaderTypesProvider(
            firstPartyHosts: [:]
        )
        (firstPartyHosts.keys + otherHosts).forEach { fixture in
            let url = URL(string: fixture)
            XCTAssertEqual(headerTypesProvider.tracingHeaderTypes(for: url), .init())
        }
    }

    func test_TracingHeaderTypesProviderWithEmptyTracingHeaderTypes_itReturnsNoTracingHeaderTypes() {
        let headerTypesProvider = TracingHeaderTypesProvider(
            firstPartyHosts: ["http://first-party.com/": .init()]
        )
        XCTAssertEqual(headerTypesProvider.tracingHeaderTypes(for: URL(string: "http://first-party.com/")), .init())
    }

    func test_TracingHeaderTypesProviderWithValidDictionary_itReturnsTracingHeaderTypes_forSubdomainURL() {
        let headerTypesProvider = TracingHeaderTypesProvider(
            firstPartyHosts: ["first-party.com": .init(arrayLiteral: .b3m)]
        )
        XCTAssertEqual(headerTypesProvider.tracingHeaderTypes(for: URL(string: "api.first-party.com")), .init(arrayLiteral: .b3m))
        XCTAssertEqual(headerTypesProvider.tracingHeaderTypes(for: URL(string: "apifirst-party.com")), .init())
        XCTAssertEqual(headerTypesProvider.tracingHeaderTypes(for: URL(string: "https://api.first-party.com/v1/endpoint")), .init(arrayLiteral: .b3m))

    }

    func test_TracingHeaderTypesProviderWithValidDictionary_itReturnsCorrectTracingHeaderTypes() {
        let headerTypesProvider = TracingHeaderTypesProvider(
            firstPartyHosts: firstPartyHosts
        )
        firstPartyHosts.keys.forEach { fixture in
            let url = URL(string: fixture)
            XCTAssertEqual(headerTypesProvider.tracingHeaderTypes(for: url), .init(arrayLiteral: .w3c, .b3s))
        }
        otherHosts.forEach { fixture in
            let url = URL(string: fixture)
            XCTAssertEqual(headerTypesProvider.tracingHeaderTypes(for: url), .init())
        }
    }

    func testTracingHeaderTypes() {
        let firstPartyHosts: FirstPartyHosts = [
            "example.com": [.dd, .b3m],
            "subdomain.example.com": [.w3c],
            "otherdomain.com": [.b3s]
        ]

        let provider = TracingHeaderTypesProvider(firstPartyHosts: firstPartyHosts)

        let url1 = URL(string: "http://example.com/path1")
        let url2 = URL(string: "https://subdomain.example.com/path2")
        let url3 = URL(string: "http://otherdomain.com/path3")
        let url4 = URL(string: "https://somedomain.com/path4")

        let expected1 = Set<TracingHeaderType>([.dd, .b3m])
        let expected2 = Set<TracingHeaderType>([.w3c, .dd, .b3m])
        let expected3 = Set<TracingHeaderType>([.b3s])
        let expected4 = Set<TracingHeaderType>()

        let actual1 = provider.tracingHeaderTypes(for: url1)
        let actual2 = provider.tracingHeaderTypes(for: url2)
        let actual3 = provider.tracingHeaderTypes(for: url3)
        let actual4 = provider.tracingHeaderTypes(for: url4)

        XCTAssertEqual(actual1, expected1)
        XCTAssertEqual(actual2, expected2)
        XCTAssertEqual(actual3, expected3)
        XCTAssertEqual(actual4, expected4)
    }
}

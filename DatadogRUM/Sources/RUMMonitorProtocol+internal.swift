/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at Datadog (https://www.datadoghq.com/).
 * Copyright 2019-Present Datadog, Inc.
 */

import Foundation
import DatadogInternal

public extension RUMMonitorProtocol {
    var _internal: DatadogInternalInterface {
        DatadogInternalInterface(monitor: self)
    }
}

/// This class exposes internal methods that are used by other Datadog modules and cross platform
/// frameworks. It is not meant for public use.
///
/// DO NOT USE this class or its methods if you are not working on the internals of the Datadog SDK
/// or one of the cross platform frameworks.
///
/// Methods, members, and functionality of this class  are subject to change without notice, as they
/// are not considered part of the public interface of the Datadog SDK.
public struct DatadogInternalInterface {
    let monitor: RUMMonitorProtocol

    func addLongTask(at: Date, duration: TimeInterval, attributes: [AttributeKey: AttributeValue] = [:]) {
        guard let monitor = monitor as? RUMCommandSubscriber else {
            return
        }

        let longTaskCommand = RUMAddLongTaskCommand(time: at, attributes: attributes, duration: duration)
        monitor.process(command: longTaskCommand)
    }

    func updatePerformanceMetric(
        at: Date,
        metric: PerformanceMetric,
        value: Double,
        attributes: [AttributeKey: AttributeValue] = [:]
    ) {
        guard let monitor = monitor as? RUMCommandSubscriber else {
            return
        }

        let performanceMetric = RUMUpdatePerformanceMetric(
            metric: metric,
            value: value,
            time: at,
            attributes: attributes
        )
        monitor.process(command: performanceMetric)
    }
}
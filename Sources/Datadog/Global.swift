/*
* Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
* This product includes software developed at Datadog (https://www.datadoghq.com/).
* Copyright 2019-Present Datadog, Inc.
*/

import DatadogRUM

/// Because `Global` is a common name widely used across different projects,
/// `DDGlobal` typealias can be used to avoid compiler ambiguity.
public typealias DDGlobal = Global

/// Namespace storing global Datadog components.
public struct Global {
    /// Shared RUM Monitor instance to use throughout the app.
    public static var rum: DDRUMMonitor { RUMMonitor.shared() }
}

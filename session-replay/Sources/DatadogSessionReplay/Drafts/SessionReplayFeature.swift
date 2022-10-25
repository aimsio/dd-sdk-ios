/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at Datadog (https://www.datadoghq.com/).
 * Copyright 2019-2020 Datadog, Inc.
 */

import Foundation
import Datadog

/// A draft of the main SR component (TODO: RUMM-2268 Design convenient public API).
/// - It conforms to `DatadogFeature` for communicating with `DatadogCore`.
/// - It implements `SessionReplayController` for being used from the public API.
///
/// An instance of `SessionReplayFeature` is kept by `DatadogCore` but can be also
/// retained by the user.
internal class SessionReplayFeature: DatadogFeature, SessionReplayController {
    // MARK: - DatadogFeature

    let name: String = "session-replay"
    let requestBuilder: FeatureRequestBuilder = RequestBuilder()
    let messageReceiver: FeatureMessageReceiver

    // MARK: - Main Components

    let recorder: Recorder

    // MARK: - Initialization

    convenience init(configuration: SessionReplayConfiguration) {
        let rumContextReceiver = RUMContextReceiver()
        let recorder = Recorder(
            configuration: configuration,
            rumContextObserver: rumContextReceiver,
            processor: Processor()
        )

        self.init(
            messageReceiver: rumContextReceiver,
            recorder: recorder
        )
    }

    internal init(
        messageReceiver: FeatureMessageReceiver,
        recorder: Recorder
    ) {
        self.messageReceiver = messageReceiver
        self.recorder = recorder
    }

    // MARK: - SessionReplayController

    func start() { recorder.start() }
    func stop() { recorder.stop() }
    func change(privacy: SessionReplayPrivacy) { recorder.change(privacy: privacy) }
}

// MARK: - WIP: RUMM-2662 Session replay data is automatically uploaded

internal struct RequestBuilder: FeatureRequestBuilder {
    func request(for events: [Data], with context: DatadogContext) -> URLRequest { // swiftlint:disable:this unavailable_function
        fatalError("TODO: RUMM-2662 Session replay data is automatically uploaded")
    }
}

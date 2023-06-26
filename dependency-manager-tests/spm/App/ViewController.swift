/*
* Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
* This product includes software developed at Datadog (https://www.datadoghq.com/).
* Copyright 2019-Present Datadog, Inc.
*/

import UIKit
import Datadog
import DatadogLogs
import DatadogTrace
import DatadogRUM
import DatadogCrashReporting

internal class ViewController: UIViewController {
    private var logger: DatadogLogger! // swiftlint:disable:this implicitly_unwrapped_optional

    override func viewDidLoad() {
        super.viewDidLoad()

        DatadogCore.initialize(
            with: DatadogCore.Configuration(clientToken: "abc", env: "tests"),
            trackingConsent: .granted
        )

        Logs.enable()

        DatadogCrashReporter.initialize()

        self.logger = DatadogLogger.builder
            .sendLogsToDatadog(false)
            .printLogsToConsole(true)
            .build()

        // RUM APIs must be visible:
        RUM.enable(with: .init(applicationID: "app-id"))
        RUMMonitor.shared().startView(viewController: self)

        // DDURLSessionDelegate APIs must be visible:
        _ = DDURLSessionDelegate()
        _ = DatadogURLSessionDelegate()
        class CustomDelegate: NSObject, __URLSessionDelegateProviding {
            var ddURLSessionDelegate: DatadogURLSessionDelegate { DatadogURLSessionDelegate() }
        }

        // Trace APIs must be visible:
        Trace.enable()

        logger.info("It works")
        _ = Tracer.shared().startSpan(operationName: "this too")

        addLabel()
    }

    private func addLabel() {
        let label = UILabel()
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(label)

        label.text = "Testing..."
        label.textColor = .white
        label.sizeToFit()
        label.center = view.center
    }
}

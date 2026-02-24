//
//  AppLogger.swift
//  MeliApp
//
//  Created by william niño on 18/02/26.
//

import OSLog

enum AppLogger {
    static let network = Logger(subsystem: "com.yourcompany.TapChallenge", category: "network")
    static let ui = Logger(subsystem: "com.yourcompany.TapChallenge", category: "ui")
    static let business = Logger(subsystem: "com.yourcompany.TapChallenge", category: "business")
}

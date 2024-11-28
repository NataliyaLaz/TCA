//
//  LogService.swift
//  TCA
//
//  Created by Nataliya Lazouskaya on 26/11/2024.
//

import ComposableArchitecture
import Foundation
import OSLog

struct LogService {
    var logErrorInfo: @Sendable (LogCategory, String) -> Void

    static let subsystem: String = Bundle.main.bundleIdentifier ?? "TCA"
}

extension LogService: DependencyKey {

    static var liveValue: Self {

        return Self(
            logErrorInfo: { category, message in
                logError(category: category, message: message)
            }
        )
        
        @Sendable func logError(category: LogCategory, message: String) {
            Logger.init(subsystem: LogService.subsystem, category: category.rawValue).error("\(message)")
        }
    }
}

extension DependencyValues {
    var logService: LogService {
        get { self[LogService.self] }
        set { self[LogService.self] = newValue }
    }
}

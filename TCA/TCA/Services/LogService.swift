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
    var logInfo: @Sendable (LogCategory, String) -> Void
    var logWarning: @Sendable (LogCategory, String) -> Void
    var logErrorInfo: @Sendable (LogCategory, String) -> Void
    var logLocalizedError: @Sendable (LocalizedError) -> Void
    var logHttpRequest: @Sendable (URLRequest, UUID) -> Void
    var logHttpResponse: @Sendable (URLResponse, Data, UUID) -> Void

    static let subsystem: String = Bundle.main.bundleIdentifier ?? "TCA"
}

extension LogService: DependencyKey {

    static var liveValue: Self {

        return Self(
            logInfo: { category, message in
                logInfo(category: category, message: message)
            },
            logWarning: { category, message in
                logWarning(category: category, message: message)
            },
            logErrorInfo: { category, message in
                logError(category: category, message: message)
            },
            logLocalizedError: { error in
                Logger.init(subsystem: LogService.subsystem, category: LogCategory.error.rawValue).error("\(error.localizedDescription)")
            },
            logHttpRequest: { request, id in
                var message = ""
                let method = request.httpMethod ?? ""
                let url = request.url?.absoluteString ?? ""
                let headers = request.allHTTPHeaderFields ?? [String: String]()
                var body = ""
                if let httpBody = request.httpBody {
                    body += String(data: httpBody, encoding: .utf8) ?? "body exists but unexpected empty"
                }
                message += "\n-------------- Begin request \(id) --------------\n"

                message += "-> Method: \(method)\n"
                message += "-> Url: \(url)\n"
                message += "-> Headers: \(headers)\n"
                message += "-> Body: \(body)"

                message += "\n-------------- End request \(id) --------------"
                logInfo(category: .network, message: message)
            },
            logHttpResponse: { response, data, id in
                guard let response = response as? HTTPURLResponse else {
                    debugPrint("-> Unexpected response!")
                    return
                }

                var message = ""
                let url = response.url?.absoluteString ?? ""
                let status = response.statusCode
                let responseData = String(data: data, encoding: .utf8) ?? ""
                message += "\n-------------- Begin response \(id) --------------\n"

                message += "-> Url: \(url)\n"
                message += "-> Status: \(status)\n"
                message += "-> Data: \(responseData)"

                message += "\n-------------- End response \(id) --------------"
                logInfo(category: .network, message: message)
            }
        )

        @Sendable func logInfo(category: LogCategory, message: String) {
            Logger.init(subsystem: LogService.subsystem, category: category.rawValue).info("\(message)")
        }

        @Sendable func logWarning(category: LogCategory, message: String) {
            Logger.init(subsystem: LogService.subsystem, category: category.rawValue).warning("\(message)")
        }

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

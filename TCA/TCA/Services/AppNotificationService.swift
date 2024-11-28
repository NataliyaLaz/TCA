//
//  AppNotificationService.swift
//  TCA
//
//  Created by Nataliya Lazouskaya on 28/11/2024.
//

import SwiftUI
import ComposableArchitecture
import UserNotifications

enum AppNotificationKeys {
    static let authStatus = "authStatus"
}

@DependencyClient
public struct AppNotificationService: Sendable {
    static let notificationService = NotificationCenter.default
    
    var updateAuthStatus: @Sendable (Status) -> Void
    var errorToast: @Sendable (_ error: String) -> Void
}

extension AppNotificationService: DependencyKey {
    public static var liveValue: Self {
        return Self(
            updateAuthStatus: { status in
                DispatchQueue.main.async {
                    notificationService.post(name: .updateGlobalScreenState,
                                             object: nil,
                                             userInfo: [AppNotificationKeys.authStatus: status])
                }
            },
            errorToast: { description in
                Toast.shared.present(title: description)
            }
        )
    }
}

extension DependencyValues {
    var appNotificationService: AppNotificationService {
        get { self[AppNotificationService.self] }
        set { self[AppNotificationService.self] = newValue }
    }
}

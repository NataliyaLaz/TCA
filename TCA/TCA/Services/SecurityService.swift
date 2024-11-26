//
//  SecurityService.swift
//  TCA
//
//  Created by Nataliya Lazouskaya on 26/11/2024.
//

import Foundation
import ComposableArchitecture

@DependencyClient
public struct SecurityService: Sendable {
    var getToken: @Sendable () async throws -> String?
}

extension SecurityService: DependencyKey {
    public static var liveValue: Self {

        return Self(
            getToken: {
                let identity = try await getIdentity()
                return identity?.token
            }
        )

        @Sendable
        func getIdentity() async throws -> UserIdentity? {
            // Simulate a delay of 1 second
            try await Task.sleep(nanoseconds: 1_000_000_000)

            let shouldReturnValue = Bool.random()
            if shouldReturnValue {
                let randomInt = Int.random(in: 1...100)
                return UserIdentity(token: String(randomInt))
            } else {
                return nil
            }
        }
    }
}

extension SecurityService: TestDependencyKey {
    public static let testValue = Self()
}

extension DependencyValues {
    public var securityService: SecurityService {
        get { self[SecurityService.self] }
        set { self[SecurityService.self] = newValue }
    }
}


//
//  PaywallReducer.swift
//  TCA
//
//  Created by Nataliya Lazouskaya on 27/11/2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct PaywallFeature {
    @ObservableState
    struct State: Equatable {
        var isLoading: Bool = false
        var status: Status = .unauthorized
    }
    
    enum Action: BindableAction  {
        case binding(BindingAction<State>)
        case tryToProceedToMainTab
        case changeState(Status)
    }
    
    @Dependency(\.securityService) var securityService
    @Dependency(\.logService) var logService
    @Dependency(\.appNotificationService) var appNotificationService
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
                case .tryToProceedToMainTab:
                    state.isLoading = true
                    return .run { send in
                        guard try await securityService.getToken() != nil else {
                            logService.logErrorInfo(.authorization, "impossible to read the token")
                            await send(.changeState(.unauthorized), animation: .default)
                            return
                        }
                        await send(.changeState(.authorized), animation: .default)
                    } catch: { _, send in
                        await send(.changeState(.unauthorized), animation: .default)
                    }
                case let .changeState(status):
                    switch status {
                        case .authorized:
                            state.isLoading = false
                            state.status = .authorized
                            NotificationCenter.default.post(
                                name: .updateGlobalScreenState,
                                object: nil,
                                userInfo: ["authStatus": Status.authorized]
                            )
                            return .none
                        case .unauthorized:
                            state.isLoading = false
                            state.status = .unauthorized
                            appNotificationService.errorToast("Try again")
                            return .none
                        default:
                            state.isLoading = false
                            return .none
                    }
                    
                case .binding:
                    return .none
            }
        }
    }
}

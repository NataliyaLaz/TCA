//
//  RootReducer.swift
//  TCA
//
//  Created by Nataliya Lazouskaya on 26/11/2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct RootFeature {
    @ObservableState
    struct State {
        var authStatus: Status = .unknown
        var mainTab = MainTabFeature.State()
        var onboarding = OnboardingFeature.State()
        var paywall = PaywallFeature.State()
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case changeState(Status)
        case mainTab(MainTabFeature.Action)
        case onboarding(OnboardingFeature.Action)
        case paywall(PaywallFeature.Action)
    }
    
    @Dependency(\.securityService) var securityService
    @Dependency(\.logService) var logService
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
                case .onAppear:
                    return .run { send in
                        if !UserDefaults.standard.bool(forKey: UserDefaultsKeys.firstRun) {
                            UserDefaults.standard.setValue(true, forKey: UserDefaultsKeys.firstRun)
                            await send(.changeState(.onboarding), animation: .default)
                            return
                        }
                        
                        guard try await securityService.getToken() != nil else {
                            logService.logErrorInfo(.authorization, "impossible to read the token")
                            await send(.changeState(.unauthorized), animation: .default)
                            return
                        }
                        await send(.changeState(.authorized))
                    } catch: { _, send in
                        await send(.changeState(.unauthorized), animation: .default)
                    }
                case let .changeState(status):
                    state.authStatus = status
                    switch status {
                        case .onboarding:
                            state.onboarding = .init()
                            return .none
                        case .authorized:
                            state.mainTab = .init()
                            return .none
                        case .unauthorized:
                            state.paywall = .init()
                            return .none
                        default:
                            return .none
                    }
                case .mainTab:
                    return .none
                case .onboarding:
                    return .none
                case .paywall:
                    return .none
                case .binding:
                    return .none
            }
        }
        
        Scope(state: \.mainTab, action: /Action.mainTab) {
            MainTabFeature()
        }
        
        Scope(state: \.onboarding, action: /Action.onboarding) {
            OnboardingFeature()
        }
        
        Scope(state: \.paywall, action: /Action.paywall) {
            PaywallFeature()
        }
    }
}

//
//  RootView.swift
//  TCA
//
//  Created by Nataliya Lazouskaya on 26/11/2024.
//

import ComposableArchitecture
import SwiftUI

struct RootView: View {
    let screenStateNotification = NotificationCenter.default.publisher(for: .updateGlobalScreenState)
    @Perception.Bindable var store: StoreOf<RootFeature>
    
    var body: some View {
        WithPerceptionTracking {
            switch store.authStatus {
                case .unknown:
                    progressView()
                case .unauthorized:
                    paywallView()
                case .onboarding:
                    onboardingView()
                case .authorized:
                    tabView()
            }
        }
        .onReceive(screenStateNotification) { notification in
            guard let userInfo = notification.userInfo,
                  let appState = userInfo["authStatus"] as? Status else {
                return
            }
            store.send(.changeState(appState), animation: .default)
        }
    }

    @ViewBuilder
    private func progressView() -> some View {
        ProgressView()
    }

    @ViewBuilder
    private func onboardingView() -> some View {
        OnboardingView(store: store.scope(state: \.onboarding, action: \.onboarding))
            .transition(.move(edge: .trailing))
    }
    
    @ViewBuilder
    private func paywallView() -> some View {
        PaywallView(store: store.scope(state: \.paywall, action: \.paywall))
    }

    @ViewBuilder
    private func tabView() -> some View {
        MainTabView(store: store.scope(state: \.mainTab, action: \.mainTab))
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        var state = RootFeature.State()
        
        RootView(store: Store(initialState: state, reducer: {
            RootFeature()
        }))
        .previewDisplayName("Unknown")
        
        let _ = state.authStatus = .onboarding
        
        RootView(store: Store(initialState: state, reducer: {
            RootFeature()
        }))
        .previewDisplayName("Onboarding")
        
        let _ = state.authStatus = .unauthorized
        
        RootView(store: Store(initialState: state, reducer: {
            RootFeature()
        }))
        .previewDisplayName("Unauthorized")
        
        let _ = state.authStatus = .authorized
        
        RootView(store: Store(initialState: state, reducer: {
            RootFeature()
        }))
        .previewDisplayName("Authorized")
    }
}

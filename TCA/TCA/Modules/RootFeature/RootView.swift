//
//  RootView.swift
//  TCA
//
//  Created by Nataliya Lazouskaya on 26/11/2024.
//

import ComposableArchitecture
import SwiftUI

struct RootView: View {
    
 //   let screenStateNotification = NotificationCenter.default.publisher(for: .updateGlobalScreenState)
    @Perception.Bindable var store: StoreOf<RootFeature>
    
    var body: some View {
        WithPerceptionTracking {
            switch store.authStatus {
                case .unknown:
                    progressView()
                case .firstRun:
//                    PaywallView(store: store.scope(state: \.paywall, action: \.paywall))
//                    PaywallFeature()
                    progressView()
                case .unauthorized:
  //                  signInView(store: store.scope(state: \.signIn, action: \.signIn))
                    progressView()
                case .onboarding:
   //                 onboardingView()
                    progressView()
                case .authorized:
         //           tabView(store: store.scope(state: \.mainTab, action: \.mainTab))
                    progressView()
            }
        }
//        .onReceive(screenStateNotification) { notification in
//            guard let userInfo = notification.userInfo,
//                  let appState = userInfo["authStatus"] as? AuthStatus else {
//                return
//            }
//            store.send(.changeState(appState), animation: .default)
//        }
    }

    @ViewBuilder
    private func progressView() -> some View {
        ProgressView()
    }

//    @ViewBuilder
//    private func onboardingView() -> some View {
//        OnboardingView(store: store.scope(state: \.onboarding, action: \.onboarding))
//            .transition(.move(edge: .trailing))
//    }

//    @ViewBuilder
//    private func tabView(store: StoreOf<MainTabFeature>) -> some View {
//        MainTabView(store: store)
//    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        var state = RootFeature.State()
        
        RootView(store: Store(initialState: state, reducer: {
            RootFeature()
        }))
        .previewDisplayName("Unknown")
        
        let _ = state.authStatus = .firstRun
        
        RootView(store: Store(initialState: state, reducer: {
            RootFeature()
        }))
        .previewDisplayName("First Run")
        
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

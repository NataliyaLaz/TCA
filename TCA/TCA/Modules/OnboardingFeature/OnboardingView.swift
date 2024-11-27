//
//  OnboardingView.swift
//  TCA
//
//  Created by Nataliya Lazouskaya on 27/11/2024.
//

import SwiftUI
import ComposableArchitecture

struct OnboardingView: View {
    
    @Perception.Bindable var store: StoreOf<OnboardingFeature>
    
    var body: some View {
        WithPerceptionTracking {
            switch store.status {
                case .authorized:
                    tabView()
                case .unauthorized:
                    paywallView()
                default:
                    if store.isLoading {
                        ProgressView()
                    } else {
                        Button {
                            store.send(.onboardingIsFinishedTapped)
                        } label: {
                            Text("Onboarding is finished")
                                .accentColor(.green)
                        }
                    }
            }
        }
    }
    
    @ViewBuilder
    private func tabView() -> some View {
        MainTabView(store: store.scope(state: \.mainTab, action: \.mainTab))
    }
    
    @ViewBuilder
    private func paywallView() -> some View {
        PaywallView(store: store.scope(state: \.paywall, action: \.paywall))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(store: Store(initialState: OnboardingFeature.State()) {
            OnboardingFeature()
        })
    }
}

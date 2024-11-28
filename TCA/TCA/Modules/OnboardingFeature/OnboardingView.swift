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
            if store.isLoading {
                ProgressView()
            } else {
                Button {
                    store.send(.onboardingIsFinishedTapped)
                } label: {
                    Text("Onboarding is finished")
                        .accentColor(.green)
                }
                .buttonStyle(.bordered)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(store: Store(initialState: OnboardingFeature.State()) {
            OnboardingFeature()
        })
    }
}

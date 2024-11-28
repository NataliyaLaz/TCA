//
//  PaywallView.swift
//  TCA
//
//  Created by Nataliya Lazouskaya on 27/11/2024.
//

import SwiftUI
import ComposableArchitecture

struct PaywallView: View {
    
    @Perception.Bindable var store: StoreOf<PaywallFeature>
    
    var body: some View {
        WithPerceptionTracking {            
            if store.isLoading {
                ProgressView()
            } else {
                Button {
                    store.send(.tryToProceedToMainTab)
                } label: {
                    Text("Proceed")
                        .accentColor(.green)
                }
                .buttonStyle(.bordered)
            }
        }
    }
}

struct Paywall_Previews: PreviewProvider {
    static var previews: some View {
        PaywallView(store: Store(initialState: PaywallFeature.State()) {
            PaywallFeature()
        })
    }
}

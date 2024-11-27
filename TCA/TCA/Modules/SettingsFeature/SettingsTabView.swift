//
//  SettingsView.swift
//  TCA
//
//  Created by Nataliya Lazouskaya on 27/11/2024.
//

import SwiftUI
import ComposableArchitecture

struct SettingsTabView: View {
    
    let store: StoreOf<SettingsTabFeature>
    
    var body: some View {
        WithPerceptionTracking {
            VStack {
                Button {
                    store.send(.moveToContent)
                } label: {
                    Text("Go to Content")
                }
                
                Button {
                    store.send(.logoutTapped)
                } label: {
                    Text("Log out")
                }
            }
        }
    }
}

struct SettingsTabView_Preview: PreviewProvider {
    static var previews: some View {
        SettingsTabView(store: Store(initialState: SettingsTabFeature.State()) {
            SettingsTabFeature()
        })
    }
}

//
//  MainTabView.swift
//  TCA
//
//  Created by Nataliya Lazouskaya on 27/11/2024.
//

import ComposableArchitecture
import SwiftUI

struct MainTabView: View {
    
    @Perception.Bindable var store: StoreOf<MainTabFeature>
    
    var body: some View {
        WithPerceptionTracking {
            TabView(selection: $store.selectedTab.sending(\.selectTab)) {
                ContentTabView(store: store.scope(state: \.content, action: \.content))
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Content")
                    }
                    .tag(MainTabFeature.Tab.content)
                    .toolbarBackground(.white, for: .tabBar)
                    .toolbarBackground(.visible, for: .tabBar)
                
                SettingsTabView(store: store.scope(state: \.settings, action: \.settings))
                    .tabItem {
                        Image(systemName: "person.circle")
                        Text("Settings")
                    }
                    .tag(MainTabFeature.Tab.settings)
                    .toolbarBackground(.white, for: .tabBar)
                    .toolbarBackground(.visible, for: .tabBar)
            }
            .accentColor(.green)
        }
        .onAppear {
            store.send(.view(.onAppear))
        }
    }
}

#Preview {
    MainTabView(store: Store(initialState: MainTabFeature.State(), reducer: {
        MainTabFeature()
    }))
}

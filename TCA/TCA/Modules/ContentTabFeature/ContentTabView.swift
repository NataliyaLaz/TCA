//
//  ContentView.swift
//  TCA
//
//  Created by Nataliya Lazouskaya on 27/11/2024.
//

import SwiftUI
import ComposableArchitecture

struct ContentTabView: View {
    
    @Perception.Bindable var store: StoreOf<ContentTabFeature>
    
    var body: some View {
        WithPerceptionTracking {
            Button {
                store.send(.moveToSettings)
            } label: {
                Text("Go to Settings")
            }
        }
    }
}

struct ContentTabView_Preview: PreviewProvider {
    static var previews: some View {
        ContentTabView(store: Store(initialState: ContentTabFeature.State()) {
            ContentTabFeature()
        })
    }
}

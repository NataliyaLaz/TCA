//
//  TCAApp.swift
//  TCA
//
//  Created by Nataliya Lazouskaya on 25/11/2024.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCAApp: App {

    static let store = Store(initialState: RootFeature.State()) {
        RootFeature()
    }
    
    init() {
        TCAApp.store.send(.onAppear)
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(store: TCAApp.store)
        }
    }
}

//
//  SettingsReducer.swift
//  TCA
//
//  Created by Nataliya Lazouskaya on 27/11/2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SettingsTabFeature {
    @ObservableState
    struct State: Equatable {
    }

    enum Action {
        case moveToContent
        case logoutTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
                case .moveToContent:
                    return .none
                case .logoutTapped:
                    return .none
            }
            return .none
        }
    }
}

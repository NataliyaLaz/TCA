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
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case moveToContent
        case logoutTapped
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { _, action in
            switch action {
                case .moveToContent:
                    return .none
                case .logoutTapped:
                    return .none
                case .binding:
                    return .none
            }
        }
    }
}

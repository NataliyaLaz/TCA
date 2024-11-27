//
//  ContentReducer.swift
//  TCA
//
//  Created by Nataliya Lazouskaya on 27/11/2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ContentTabFeature {
    @ObservableState
    struct State: Equatable {
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case moveToSettings
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { _, action in
            switch action {
                case .moveToSettings:
                    return .none
                case .binding:
                    return .none
            }
        }
    }
}

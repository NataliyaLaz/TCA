//
//  MainTabReducer.swift
//  TCA
//
//  Created by Nataliya Lazouskaya on 27/11/2024.
//

import ComposableArchitecture
import Foundation

@Reducer
struct MainTabFeature {
    enum Tab { case content, settings }
    @ObservableState
    struct State: Equatable {
        var selectedTab: Tab = .content
        var content = ContentTabFeature.State()
        var settings = SettingsTabFeature.State()
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case view(View)
        case content(ContentTabFeature.Action)
        case settings(SettingsTabFeature.Action)
        case selectTab(Tab)
        
        enum View {
            case onAppear
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .content(.moveToSettings):
                    state.selectedTab = .settings
                    return .none
                    
                case .settings(.logoutTapped):
                    return .none
                    
                case .settings(.moveToContent):
                    state.selectedTab = .content
                    return .none

                case .content, .settings:
                    return .none
                    
                    // For some reason vanila binding doesn't works with Tabview and doesn't update the selected tab under hood
                case let .selectTab(tab):
                    state.selectedTab = tab
                    return .none
                    
                    // MARK: View
                case .view(let viewAction):
                    switch viewAction {
                        case .onAppear:
                            debugPrint("View has appeared")
                            return .none
                    }
                    
                    // MARK: Binding
                case .binding:
                    return .none
            }
        }
    }
}

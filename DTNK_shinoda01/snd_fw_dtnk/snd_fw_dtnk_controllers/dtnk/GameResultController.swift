//
//  GameResultController.swift
//  Dtnk-ver002
//
//  Created by Takuma Shinoda on 2023/06/06.
//

import SwiftUI

struct GameResultController {
    
    func onTapPlay() {
        
        appState.gamesystem = nil
        appState.gameUiState = GameUiState()
        appState.resultState = nil
        
        Router().pushBasePage(pageId: .home)
    }

}

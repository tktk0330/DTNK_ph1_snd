//
//  RoomController.swift
//  DTNK_shinoda01
//
//  Created by Takuma Shinoda on 2023/06/29.
//

import SwiftUI

struct RoomController {
    
    func onOpenMenu(animated: Bool = false) {
        DispatchQueue.main.async {
            if animated {
                withAnimation {
                    appState.room.roommode = .pop
                }
            } else {
                appState.room.roommode = .pop
            }
        }
    }
    
    func onCloseMenu(animated: Bool = false) {
        DispatchQueue.main.async {
            if animated {
                withAnimation {
                    appState.room.roommode = .base
                }
            } else {
                appState.room.roommode = .base
            }
        }
    }
    
    func moveMatchingView() {
        // Matchingへ
        appState.matching = MatchingState(seatCount: 4, message: "プレイヤーを募集しています...")
        Router().pushBasePage(pageId: .dtnkMatching)
    }
}

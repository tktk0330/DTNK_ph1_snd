


import SwiftUI
import Foundation

enum vsInfo: Int {
    case vsBot = 0
    case vsFriend = 1
}

enum GamePhaseOrigine: Int {
    case playing = 0
    case gameresult = 1
}

enum GamePhase: Int {
    case dealcard = 0
    case gamenum = 1
    case countdown = 2
    case ratefirst = 3
    case gamefirst = 4
    case decisioninitialplayer = 5
    case gamefirst_sub = 6
    case main = 7
    case dtnk = 8
    case burst = 15
    case revenge = 14
    case q_challenge = 9
    case challenge = 10
    case decisionrate_pre = 11
    case decisionrate = 12
    case result = 13
    case waiting = 50
    case other = 99
}


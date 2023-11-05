/**
 定数ファイル
 */

import SwiftUI

struct Constants {
    
    // MARK: - logLevel
    static let currentLogLevel: LogLevel = .info // 現在のログレベルを指定
    
    // MARK: - lifeTime
    static let lifeTime: Int = 60
    
    // MARK: - lifeMax
    static let lifeMax: Int = 5
        
    // MARK: - cardFaceUp
    static let cardFaceUp: Bool = false
    
    // MARK: - screenWidth
    static let scrWidth = UIScreen.main.bounds.width

    // MARK: - screenHeight
    static let scrHeight = UIScreen.main.bounds.height
    
    // MARK: - myCardWidth
    static let myCardWidth = UIScreen.main.bounds.width * 0.23

    // MARK: - otherCardWidth
    static let otherCardWidth = UIScreen.main.bounds.width * 0.16

    // MARK: - BurstCount
    static let burstCount = 7
    
    // MARK: - TurnTime
    static let turnTime = 30

    // MARK: - DotenkoCode
    static let dtnkCode = 50
    
    // MARK: - SyotenkoCode
    static let stnkCode = 99
    
    // MARK: - BurstCode
    static let burstCode = 88
    
    // MARK: - RevengeCode
    static let revengeCode = 77
    
    // MARK: - RevengeCode
    static let challengeCode = 66
    
    // MARK: - NGCode
    static let ngCode = 00
    
    // MARK: - OKFlg
    static let okFlg = 1
    
    // MARK: - NGFlg
    static let ngFlg = 0
    
    // MARK: - AnnounceTime
    static let announceTime = 0

}

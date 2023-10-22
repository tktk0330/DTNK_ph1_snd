


import SwiftUI

/**
 カード基本情報
 @var  suit CardSuit　マーク
 @var num Int　数字 1-13   joker 0
 @cardid: CardId
 */

struct Card: Hashable, Identifiable {
    let id = UUID()
    let suit: Suit
    let number: Int
    let cardid: CardId
}

enum Suit: String, CaseIterable {
    case spade = "S"
    case heart = "H"
    case diamond = "D"
    case club = "C"
    case all = "A"
}

struct N_Card: Equatable {
    let id: CardId
    var location: CardLocation
}

/**
 カード詳細
 @var CardId Int
 @func value [int]　手札値　1-13　Joker -1 0 1
 
 */
enum CardId: Int, CaseIterable, JSONSerializable, Identifiable {
    
    var id: Int { self.rawValue }
    
    case spade1 = 101
    case spade2 = 102
    case spade3 = 103
    case spade4 = 104
    case spade5 = 105
    case spade6 = 106
    case spade7 = 107
    case spade8 = 108
    case spade9 = 109
    case spade10 = 110
    case spade11 = 111
    case spade12 = 112
    case spade13 = 113
    case heart1 = 201
    case heart2 = 202
    case heart3 = 203
    case heart4 = 204
    case heart5 = 205
    case heart6 = 206
    case heart7 = 207
    case heart8 = 208
    case heart9 = 209
    case heart10 = 210
    case heart11 = 211
    case heart12 = 212
    case heart13 = 213
    case diamond1 = 301
    case diamond2 = 302
    case diamond3 = 303
    case diamond4 = 304
    case diamond5 = 305
    case diamond6 = 306
    case diamond7 = 307
    case diamond8 = 308
    case diamond9 = 309
    case diamond10 = 310
    case diamond11 = 311
    case diamond12 = 312
    case diamond13 = 313
    case club1 = 401
    case club2 = 402
    case club3 = 403
    case club4 = 404
    case club5 = 405
    case club6 = 406
    case club7 = 407
    case club8 = 408
    case club9 = 409
    case club10 = 410
    case club11 = 411
    case club12 = 412
    case club13 = 413
    case blackJorker1 = 996
    case whiteJorker1 = 997
    case blackJorker2 = 998
    case whiteJorker2 = 999

    case back = 900
}


extension CardId {
    
    // ロケーション合計 deck total : 0, hand: その手札合計
    func total(for location: CardLocation) -> Int {
        switch location {
        case .deck, .table:
            return 0
        case .hand(let playerIndex, _):
            return appState.gameUIState.players[playerIndex].hand.count
        }
    }
        
    // 座標　total: 手札合計, index: 何枚目のカードか
    func location(for location: CardLocation, total: Int) -> CGSize {
        let resize = Constants.scrWidth * 0.47
        let game = appState.gameUIState
        let space = 0.09
        
        switch location {
        case .deck:
            return CGSize(width: UIScreen.main.bounds.width * -space, height: -Constants.scrHeight * 0.046)
        case .table:
            return CGSize(width: UIScreen.main.bounds.width * space, height: -Constants.scrHeight * 0.046)
        case .hand(let playerIndex, let cardIndex):
            let cardSpacingDegrees: Double = playerIndex == game!.myside ? 30 : 10
            var prex = CGFloat(0)
            var prey = CGFloat(0)
            
            if  playerIndex == (game!.myside + 2) % game!.players.count {
                // 正面
                prex = CGFloat(cardSpacingDegrees * (Double(cardIndex) - Double(total - 1) / 2))
                prey = CGFloat(pow((Double(cardIndex) - Double(total - 1) / 2), 2) * cardSpacingDegrees * -0.10)
            } else {
                prex = CGFloat(cardSpacingDegrees * (Double(cardIndex) - Double(total - 1) / 2))
                prey = CGFloat(pow((Double(cardIndex) - Double(total - 1) / 2), 2) * cardSpacingDegrees * 0.10)
            }
            
            let x = prex
            let y = prey

            // 自分のサイドのプレイヤーの座標
            if playerIndex == game!.myside {
                return CGSize(width: x, height: y + resize)
            }
            // 自分のサイドの次のプレイヤーの座標(左)
            else if playerIndex == (game!.myside + 1) % game!.players.count {
                return CGSize(width: -y - resize, height: x - Constants.scrHeight * 0.16)
            }
            // 自分のサイドの次の次のプレイヤーの座標(正面)
            else if playerIndex == (game!.myside + 2) % game!.players.count {
                return CGSize(width: -x, height: y - Constants.scrHeight * 0.35)
            }
            // 自分のサイドの次の次の次のプレイヤーの座標(右)
            else if playerIndex == (game!.myside + 3) % game!.players.count {
                return CGSize(width: y + resize, height: -x - Constants.scrHeight * 0.16)
            }
            else {
                return .zero
            }
        }
    }

    // 角度を計算 total: 手札合計, index: 何枚目のカードか
    func angle(for location: CardLocation, total: Int) -> Double {
        let cardSpacingDegrees: Double = 10
        let game = appState.gameUIState

        switch location {
        case .deck:
            return 0
        case .table:
            return 0
        case .hand(let playerIndex, let cardIndex):
            // 自分のサイドのプレイヤーの角度
            if playerIndex == game!.myside {
                return (cardSpacingDegrees * (Double(cardIndex) - Double(total - 1) / 2))
            }
            // 自分のサイドの次のプレイヤーの角度
            else if playerIndex == (game!.myside + 1) % game!.players.count {
                return 90 + (cardSpacingDegrees * (Double(cardIndex) - Double(total - 1) / 2))
            }
            // 自分のサイドの次の次のプレイヤーの角度
            else if playerIndex == (game!.myside + 2) % game!.players.count {
                return 180 + (cardSpacingDegrees * (Double(cardIndex) - Double(total - 1) / 2))
            }
            // 自分のサイドの次の次の次のプレイヤーの角度
            else if playerIndex == (game!.myside + 3) % game!.players.count {
                return -90 + (cardSpacingDegrees * (Double(cardIndex) - Double(total - 1) / 2))
            }
            else {
                return .zero
            }
        }
    }

    func suit() -> Suit {
        switch self {
        case .spade1, .spade2, .spade3, .spade4, .spade5, .spade6, .spade7, .spade8, .spade9, .spade10, .spade11, .spade12, .spade13:
            return .spade
        case .heart1, .heart2, .heart3, .heart4, .heart5, .heart6, .heart7, .heart8, .heart9, .heart10, .heart11, .heart12, .heart13:
            return .heart
        case .diamond1, .diamond2, .diamond3, .diamond4, .diamond5, .diamond6, .diamond7, .diamond8, .diamond9, .diamond10, .diamond11, .diamond12, .diamond13:
            return .diamond
        case .club1, .club2, .club3, .club4, .club5, .club6, .club7, .club8, .club9, .club10, .club11, .club12, .club13:
            return .club
        case .blackJorker1, .whiteJorker1, .blackJorker2, .whiteJorker2:
            return .all
        case .back:
            return .all
        }
    }

    
    //　手札で取りうる値
    func value() -> [Int] {
        switch self {
        case .spade1, .heart1, .diamond1, .club1:
            return [1]
        case .spade2, .heart2, .diamond2, .club2:
            return [2]
        case .spade3, .heart3, .diamond3, .club3:
            return [3]
        case .spade4, .heart4, .diamond4, .club4:
            return [4]
        case .spade5, .heart5, .diamond5, .club5:
            return [5]
        case .spade6, .heart6, .diamond6, .club6:
            return [6]
        case .spade7, .heart7, .diamond7, .club7:
            return [7]
        case .spade8, .heart8, .diamond8, .club8:
            return [8]
        case .spade9, .heart9, .diamond9, .club9:
            return [9]
        case .spade10, .heart10, .diamond10, .club10:
            return [10]
        case .spade11, .heart11, .diamond11, .club11:
            return [11]
        case .spade12, .heart12, .diamond12, .club12:
            return [12]
        case .spade13, .heart13, .diamond13, .club13:
            return [13]
        case .blackJorker1, .whiteJorker1, .blackJorker2, .whiteJorker2:
            return [-1,0,1]
        case .back:
            return [900]
        }
    }
    
    //　最初にめくった時のレート値[開始時, 終了時]([0,1])　倍：５０　逆転：２０　ダイ３：３０
    func rate() -> [Int] {
        switch self {
        case .spade1, .heart1, .diamond1, .club1, .spade2, .heart2, .diamond2, .club2, .whiteJorker1, .blackJorker1, .whiteJorker2, .blackJorker2:
            return [50,50]
        case .spade3, .club3:
            return [3,20]
        case .diamond3:
            return [3,30]
        case .heart3:
            return [3,3]
        case .spade4, .heart4, .diamond4, .club4:
            return [4,4]
        case .spade5, .heart5, .diamond5, .club5:
            return [5,5]
        case .spade6, .heart6, .diamond6, .club6:
            return [6,6]
        case .spade7, .heart7, .diamond7, .club7:
            return [7,7]
        case .spade8, .heart8, .diamond8, .club8:
            return [8,8]
        case .spade9, .heart9, .diamond9, .club9:
            return [9,9]
        case .spade10, .heart10, .diamond10, .club10:
            return [10,10]
        case .spade11, .heart11, .diamond11, .club11:
            return [11,11]
        case .spade12, .heart12, .diamond12, .club12:
            return [12,12]
        case .spade13, .heart13, .diamond13, .club13:
            return [13,13]
        case .back:
            return [900]
        }
    }
    
    func number() -> Int {
        switch self {
        case .spade1, .heart1, .diamond1, .club1:
            return 1
        case .spade2, .heart2, .diamond2, .club2:
            return 2
        case .spade3, .heart3, .diamond3, .club3:
            return 3
        case .spade4, .heart4, .diamond4, .club4:
            return 4
        case .spade5, .heart5, .diamond5, .club5:
            return 5
        case .spade6, .heart6, .diamond6, .club6:
            return 6
        case .spade7, .heart7, .diamond7, .club7:
            return 7
        case .spade8, .heart8, .diamond8, .club8:
            return 8
        case .spade9, .heart9, .diamond9, .club9:
            return 9
        case .spade10, .heart10, .diamond10, .club10:
            return 10
        case .spade11, .heart11, .diamond11, .club11:
            return 11
        case .spade12, .heart12, .diamond12, .club12:
            return 12
        case .spade13, .heart13, .diamond13, .club13:
            return 13
        case .blackJorker1, .whiteJorker1, .blackJorker2, .whiteJorker2:
            return 100
        case .back:
            return 900
        }
    }
    
    func imageName() -> String {
        switch self {
        case .spade1:
            return ImageName.Card.spade1.rawValue
        case .spade2:
            return ImageName.Card.spade2.rawValue
        case .spade3:
            return ImageName.Card.spade3.rawValue
        case .spade4:
            return ImageName.Card.spade4.rawValue
        case .spade5:
            return ImageName.Card.spade5.rawValue
        case .spade6:
            return ImageName.Card.spade6.rawValue
        case .spade7:
            return ImageName.Card.spade7.rawValue
        case .spade8:
            return ImageName.Card.spade8.rawValue
        case .spade9:
            return ImageName.Card.spade9.rawValue
        case .spade10:
            return ImageName.Card.spade10.rawValue
        case .spade11:
            return ImageName.Card.spade11.rawValue
        case .spade12:
            return ImageName.Card.spade12.rawValue
        case .spade13:
            return ImageName.Card.spade13.rawValue
        case .club1:
            return ImageName.Card.club1.rawValue
        case .club2:
            return ImageName.Card.club2.rawValue
        case .club3:
            return ImageName.Card.club3.rawValue
        case .club4:
            return ImageName.Card.club4.rawValue
        case .club5:
            return ImageName.Card.club5.rawValue
        case .club6:
            return ImageName.Card.club6.rawValue
        case .club7:
            return ImageName.Card.club7.rawValue
        case .club8:
            return ImageName.Card.club8.rawValue
        case .club9:
            return ImageName.Card.club9.rawValue
        case .club10:
            return ImageName.Card.club10.rawValue
        case .club11:
            return ImageName.Card.club11.rawValue
        case .club12:
            return ImageName.Card.club12.rawValue
        case .club13:
            return ImageName.Card.club13.rawValue
        case .heart1:
            return ImageName.Card.heart1.rawValue
        case .heart2:
            return ImageName.Card.heart2.rawValue
        case .heart3:
            return ImageName.Card.heart3.rawValue
        case .heart4:
            return ImageName.Card.heart4.rawValue
        case .heart5:
            return ImageName.Card.heart5.rawValue
        case .heart6:
            return ImageName.Card.heart6.rawValue
        case .heart7:
            return ImageName.Card.heart7.rawValue
        case .heart8:
            return ImageName.Card.heart8.rawValue
        case .heart9:
            return ImageName.Card.heart9.rawValue
        case .heart10:
            return ImageName.Card.heart10.rawValue
        case .heart11:
            return ImageName.Card.heart11.rawValue
        case .heart12:
            return ImageName.Card.heart12.rawValue
        case .heart13:
            return ImageName.Card.heart13.rawValue
        case .diamond1:
            return ImageName.Card.diamond1.rawValue
        case .diamond2:
            return ImageName.Card.diamond2.rawValue
        case .diamond3:
            return ImageName.Card.diamond3.rawValue
        case .diamond4:
            return ImageName.Card.diamond4.rawValue
        case .diamond5:
            return ImageName.Card.diamond5.rawValue
        case .diamond6:
            return ImageName.Card.diamond6.rawValue
        case .diamond7:
            return ImageName.Card.diamond7.rawValue
        case .diamond8:
            return ImageName.Card.diamond8.rawValue
        case .diamond9:
            return ImageName.Card.diamond9.rawValue
        case .diamond10:
            return ImageName.Card.diamond10.rawValue
        case .diamond11:
            return ImageName.Card.diamond11.rawValue
        case .diamond12:
            return ImageName.Card.diamond12.rawValue
        case .diamond13:
            return ImageName.Card.diamond13.rawValue
        case .whiteJorker1:
            return  ImageName.Card.whiteJorker.rawValue
        case .blackJorker1:
            return  ImageName.Card.blackJorker.rawValue
        case .whiteJorker2:
            return  ImageName.Card.whiteJorker.rawValue
        case .blackJorker2:
            return  ImageName.Card.blackJorker.rawValue
        case .back:
            return  ImageName.Card.back.rawValue

        }
    }
}


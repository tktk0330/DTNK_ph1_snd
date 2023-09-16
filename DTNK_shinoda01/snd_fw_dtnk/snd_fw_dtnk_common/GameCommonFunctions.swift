/**
 共通関数
 */

import Foundation

struct GameCommonFunctions {
    
    // Idと一致するプレイヤーを返す
    func findPlayerById(players: [Player_f], id: String) -> Player_f? {
        return players.first(where: { $0.id == id })
    }
    
    // Idと一致するプレイヤーのsideを返す
    func findSideById(players: [Player_f], id: String) -> Int? {
        for player in players {
            if player.id == id {
                return player.side
            }
        }
        return nil
    }
    
    // ライフの計算
    func calcuLife(life: Int, lifeTime: Int, lastUpdated: Date) -> (Int, Int, Date) {
        var newLifeCount = 0  // 新しいライフ数
        var newRemainTime = 0 // 新しい現在回復中の残り時間
        let lastUpdated = lastUpdated
        let now = Date()
        let timeInterval = now.timeIntervalSince(lastUpdated)                                     // 経過時間（秒）
        let totalTime = (Constants.lifeTime - lifeTime) + (life * Constants.lifeTime)             // 保有時間
        let totalNewTime = Double(totalTime) + Double(timeInterval)                               // 新保有時間
        let item = Int(totalNewTime).quotientAndRemainder(dividingBy: Constants.lifeTime)         // 何個ぶん回復できたか
        let quotient = item.quotient     // 商　何個回復できるか
        let remainder = item.remainder   // 余り　何秒回復できるか

        if Constants.lifeMax <= quotient {
            // 全回復
            newLifeCount = Constants.lifeMax
        } else {
            newLifeCount = quotient
            newRemainTime = Constants.lifeTime - remainder
        }
//        log("保有時間：\(totalTime) →　新保有時間：\(totalNewTime)　新ライフ；\(quotient) 新途中時間：\(remainder)")
//        log("変動 ライフ：\(life) →　\(newLifeCount)　回復中の残り時間：\(newRemainTime)　経過時間：\(timeInterval)")
        return (newLifeCount, newRemainTime, now)
    }
}

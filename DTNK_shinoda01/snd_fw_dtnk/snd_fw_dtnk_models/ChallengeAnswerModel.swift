/**
 通知系
 */

/**
チャレンジするかしないか
 */
enum ChallengeAnswer: Int {
    case initial = 0
    case nochallenge = 1
    case challenge = 2
    case other = 3
}

/**
 次のゲームに行けるか
 */
enum NextGameAnnouns: Int {
    case initial = 0
    case waiting = 1
    case other = 2
}

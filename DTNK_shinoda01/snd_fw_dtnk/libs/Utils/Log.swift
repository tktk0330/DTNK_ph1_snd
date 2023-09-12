/**
ログに関して
 
 利用：
 .warning
 log("これは情報メッセージです", level: .info) // 出力されない
 log("これはデバッグメッセージです", level: .debug) // 出力されない
 log("これは警告メッセージです", level: .warning) // 出力される
 log("これはエラーメッセージです", level: .error) // 出力される
 */

enum LogLevel: Int {
    case info = 1
    case debug = 2
    case warning = 3
    case error = 4
}

func log(_ message: String, level: LogLevel = .info) {
    #if DEBUG
    if level.rawValue >= Constants.currentLogLevel.rawValue {
        var prefix: String
        switch level {
        case .info:
            prefix = "[INFO]"
        case .debug:
            prefix = "[DEBUG]"
        case .warning:
            prefix = "[WARNING]"
        case .error:
            prefix = "[ERROR]"
        }
        print("\(prefix) \(message)")
    }
    #endif
}

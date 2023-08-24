import Foundation
import UIKit
import Combine


class HeartsRecoverController: ObservableObject {
    public var timer: Timer?
    static let shared = HeartsRecoverController() // シングルトンインスタンス
    
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    public init() {
        // アプリが終了した時刻を記録
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillTerminate), name: UIApplication.willTerminateNotification, object: nil)
        
        // アプリがバックグラウンドに移行した時刻を記録
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        // アプリがフォアグラウンドに移行した時の処理
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    // アプリが終了したときの処理
    @objc public func applicationWillTerminate() {
        // ハートのデータを保存
        HeartsDataManager.shared.saveHeartsData(appState.home.heartsData)
        // アプリ終了時に必要な処理を追加
    }
    
    // アプリがバックグラウンドに移行した時の処理
    @objc public func applicationDidEnterBackground() {
        // アプリがバックグラウンドに移行した時刻を記録
        UserDefaults.standard.set(Date(), forKey: "backgroundTime")
        
        // ハートのデータを保存
        HeartsDataManager.shared.saveHeartsData(appState.home.heartsData)
        
        // タイマーを一旦停止
        stopTimer()
        print("タイマー停止applicationDidEnterBackground")
        
        // バックグラウンドタスクを開始
        self.backgroundTask = UIApplication.shared.beginBackgroundTask(expirationHandler: { [weak self] in
            self?.endBackgroundTask()
        })
    }
    
    // アプリがフォアグラウンドに移行した時の処理
    @objc public func applicationDidBecomeActive() {
        
        if let savedHeartsData = HeartsDataManager.shared.loadHeartsData() {
                    appState.home.heartsData = savedHeartsData
                }
        
        if appState.home.heartsData.heartsCount != 5{
            // タイマーを停止
            stopTimer()
            print("タイマー停止applicationDidBecomeActive")
            
            // アプリが再開した時刻を取得
            let currentTime = Date()
            
            // バックグラウンドに移行した時刻を取得
            guard let backgroundTime = UserDefaults.standard.object(forKey: "backgroundTime") as? Date else {
                return
            }
            
            // 時間の差を計算し、タイマーの残り時間を減少させる
            let timeDifference = currentTime.timeIntervalSince(backgroundTime)
            appState.home.heartsData.remainingTime -= timeDifference
            
           // if timer == nil {
                    // 既存のタイマーが動作していない場合のみ新しいタイマーを開始
                    self.startTimer()
                    print("タイマー再開applicationDidBecomeActive")
             //   }
                   
            // バックグラウンドタスクを終了
            self.endBackgroundTask()
            
            
        }
    }
    
    // バックグラウンドタスクを終了するメソッド
    public func endBackgroundTask() {
        UIApplication.shared.endBackgroundTask(self.backgroundTask)
        self.backgroundTask = .invalid
    }
    
    // タイマーを開始するメソッド
    public func startTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard self != nil else { return }
            
            // ハートの回復処理を実行
            if appState.home.heartsData.remainingTime > 0 {
                appState.home.heartsData.remainingTime -= 1
            } else {
                appState.home.heartsData.heartsCount += 1
                appState.home.heartsData.remainingTime = 300
            }
        }
    }

    public func stopTimer(){
        // 既存のタイマーを停止
        timer?.invalidate()
    }

}




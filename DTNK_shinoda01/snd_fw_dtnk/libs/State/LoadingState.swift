


import SwiftUI

final class LoadingState: ObservableObject {
    @Published var loadingTasks: [LoadingTask]
    
    init(loadingTasks: [LoadingTask] = []) {
        self.loadingTasks = loadingTasks
    }
}

extension LoadingState {
    func updateLoading(isLoading: Bool) {
        self.loadingTasks = loadingTasks
    }
}
